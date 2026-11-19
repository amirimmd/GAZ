using System;
using System.Collections.Generic;
using System.Data.SQLite;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class AuthRepository
    {
        readonly AppDatabase _db;

        public AuthRepository(AppDatabase db)
        {
            _db = db;
        }

        public string Login(string username, string password, bool rememberMe, out UserSession session)
        {
            session = null;
            var u = TextUtil.NormalizeUsername(username);
            if (u.Length == 0 || string.IsNullOrEmpty(password))
                return "نام کاربری و رمز عبور الزامی است";
            if (password.Length > PasswordHasher.MaxPasswordLength)
                return "نام کاربری یا رمز عبور نادرست است";
            if (TextUtil.ContainsPersianOrArabic(u) || TextUtil.ContainsPersianOrArabic(password))
                return "نام کاربری و رمز را با صفحه کلید انگلیسی وارد کنید (Alt+Shift).";

            string id = null;
            string hash = null;
            bool isActive = false;
            int failed = 0;
            long? lockedUntil = null;
            bool mustChange = false;
            string display = null;
            string storedUser = null;

            using (var reader = _db.Query(
                "SELECT * FROM users WHERE lower(username) = @u AND deleted_at IS NULL LIMIT 1",
                P("@u", u)))
            {
                if (!reader.Read())
                {
                    PasswordHasher.DummyVerify(password);
                    Audit(null, u, "login_failed", "کاربر یافت نشد");
                    return "نام کاربری یا رمز عبور نادرست است";
                }

                id = reader["id"].ToString();
                hash = reader["password_hash"] == DBNull.Value ? null : reader["password_hash"].ToString();
                isActive = ToBool(reader["is_active"]);
                failed = Convert.ToInt32(reader["failed_attempts"]);
                lockedUntil = reader["locked_until"] == DBNull.Value ? (long?)null : Convert.ToInt64(reader["locked_until"]);
                mustChange = ToBool(reader["must_change_password"]);
                display = reader["display_name"].ToString();
                storedUser = reader["username"].ToString();
            }

            var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();

            if (lockedUntil.HasValue && lockedUntil.Value > now)
            {
                var seconds = Math.Max(1, (int)Math.Ceiling((lockedUntil.Value - now) / 1000.0));
                return "حساب کاربری موقتاً قفل است. " + seconds + " ثانیه دیگر دوباره تلاش کنید.";
            }
            if (lockedUntil.HasValue && lockedUntil.Value <= now && failed > 0)
            {
                failed = 0;
                _db.Execute(
                    "UPDATE users SET failed_attempts=0, locked_until=NULL, updated_at=@n WHERE id=@id",
                    P("@n", now),
                    P("@id", id));
            }
            if (!isActive)
                return "حساب کاربری غیرفعال است";

            string verifyError;
            var ok = PasswordHasher.TryVerify(password, hash, out verifyError);
            if (!ok && !IsInfrastructureError(verifyError) && IsDefaultAdminUnlock(storedUser, password, mustChange))
            {
                AppLog.Info("Resetting admin password hash to default after verifier repair.");
                hash = PasswordHasher.HashPassword(password);
                _db.Execute(
                    "UPDATE users SET password_hash=@h, failed_attempts=0, locked_until=NULL, updated_at=@n WHERE id=@id",
                    P("@h", hash),
                    P("@n", now),
                    P("@id", id));
                ok = true;
                verifyError = null;
            }
            if (!ok)
            {
                if (!string.IsNullOrEmpty(verifyError))
                    AppLog.Error("Password verify failed for " + storedUser + ": " + verifyError);

                if (IsInfrastructureError(verifyError))
                    return "بررسی رمز به‌خاطر خطای داخلی ناموفق بود. نسخهٔ جدید برنامه را نصب کنید.";

                failed++;
                long? lockAt = null;
                if (failed >= AppConstants.MaxLoginAttempts)
                    lockAt = now + (long)TimeSpan.FromMinutes(AppConstants.LockoutMinutes).TotalMilliseconds;
                _db.Execute(
                    "UPDATE users SET failed_attempts=@f, locked_until=@l, updated_at=@n WHERE id=@id",
                    P("@f", failed),
                    P("@l", (object)lockAt ?? DBNull.Value),
                    P("@n", now),
                    P("@id", id));
                Audit(id, storedUser, "login_failed", "رمز نادرست");
                if (lockAt.HasValue)
                    return "حساب به‌خاطر تلاش‌های ناموفق برای " + AppConstants.LockoutMinutes + " دقیقه قفل شد.";
                var left = AppConstants.MaxLoginAttempts - failed;
                return "نام کاربری یا رمز عبور نادرست است. تلاش باقی‌مانده: " + left;
            }

            _db.Execute(
                "UPDATE users SET failed_attempts=0, locked_until=NULL, last_login_at=@n, remember_me_enabled=@r, updated_at=@n WHERE id=@id",
                P("@n", now),
                P("@r", rememberMe ? 1 : 0),
                P("@id", id));

            var account = new UserAccount
            {
                Id = id,
                Username = storedUser,
                DisplayName = display,
                IsActive = true,
                MustChangePassword = mustChange,
                Permissions = LoadPermissions(id),
                RoleCodes = LoadRoles(id)
            };

            var sessionId = Guid.NewGuid().ToString();
            var timeout = AppConstants.DefaultSessionTimeoutMinutes;
            try
            {
                var t = _db.Scalar("SELECT value FROM app_settings WHERE key=@k", P("@k", "security.session_timeout_minutes"));
                int parsed;
                if (t != null && t != DBNull.Value && int.TryParse(t.ToString(), out parsed) && parsed > 0)
                    timeout = parsed;
            }
            catch
            {
            }

            var expires = DateTime.UtcNow.AddMinutes(timeout);
            _db.Execute(
                @"INSERT INTO sessions (id, user_id, token_hash, expires_at, last_activity_at, is_valid)
                  VALUES (@id,@uid,@th,@exp,@n,1)",
                P("@id", sessionId),
                P("@uid", id),
                P("@th", Sha256Util.HexUtf8(sessionId)),
                P("@exp", new DateTimeOffset(expires).ToUnixTimeMilliseconds()),
                P("@n", now));
            Audit(id, storedUser, "login", "ورود موفق");

            session = new UserSession
            {
                SessionId = sessionId,
                User = account,
                ExpiresAtUtc = expires,
                LastActivityUtc = DateTime.UtcNow
            };

            return null;
        }

        public void Logout(string sessionId)
        {
            if (string.IsNullOrEmpty(sessionId))
                return;
            var userId = _db.Scalar("SELECT user_id FROM sessions WHERE id=@id", P("@id", sessionId));
            _db.Execute("UPDATE sessions SET is_valid=0 WHERE id=@id", P("@id", sessionId));
            if (userId != null && userId != DBNull.Value)
                Audit(userId.ToString(), null, "logout", null);
        }

        public string ChangePassword(string userId, string currentPassword, string newPassword)
        {
            if (TextUtil.ContainsPersianOrArabic(currentPassword) || TextUtil.ContainsPersianOrArabic(newPassword))
                return "رمز را با صفحه کلید انگلیسی وارد کنید";
            var userNameObj = _db.Scalar("SELECT username FROM users WHERE id=@id", P("@id", userId));
            var username = userNameObj == null || userNameObj == DBNull.Value ? null : userNameObj.ToString();
            var policy = PasswordPolicy.ValidateNewPassword(newPassword, username);
            if (policy != null)
                return policy;
            var hashObj = _db.Scalar("SELECT password_hash FROM users WHERE id=@id", P("@id", userId));
            if (hashObj == null || hashObj == DBNull.Value)
                return "کاربر یافت نشد";
            string verifyError;
            if (!PasswordHasher.TryVerify(currentPassword, hashObj.ToString(), out verifyError))
                return "رمز فعلی نادرست است";
            var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            _db.Execute(
                "UPDATE users SET password_hash=@h, must_change_password=0, updated_at=@n WHERE id=@id",
                P("@h", PasswordHasher.HashPassword(newPassword)),
                P("@n", now),
                P("@id", userId));
            Audit(userId, null, "password_changed", null);
            return null;
        }

        /// <summary>تأیید رمز کاربر فعلی بدون قفل‌کردن حساب (برای عملیات حساس).</summary>
        public string VerifyPassword(string userId, string password)
        {
            if (string.IsNullOrEmpty(userId) || string.IsNullOrEmpty(password))
                return "رمز عبور الزامی است";
            if (TextUtil.ContainsPersianOrArabic(password))
                return "رمز را با صفحه کلید انگلیسی وارد کنید (Alt+Shift)";
            var hashObj = _db.Scalar("SELECT password_hash FROM users WHERE id=@id AND deleted_at IS NULL", P("@id", userId));
            if (hashObj == null || hashObj == DBNull.Value)
                return "کاربر یافت نشد";
            string verifyError;
            if (!PasswordHasher.TryVerify(password, hashObj.ToString(), out verifyError))
                return "رمز عبور نادرست است";
            return null;
        }

        public int EmployeeCount()
        {
            var n = _db.Scalar("SELECT COUNT(*) FROM employees WHERE deleted_at IS NULL");
            return Convert.ToInt32(n ?? 0);
        }

        HashSet<string> LoadPermissions(string userId)
        {
            var set = new HashSet<string>(StringComparer.Ordinal);
            using (var r = _db.Query(
                @"SELECT p.code FROM permissions p
                  INNER JOIN role_permissions rp ON rp.permission_id = p.id
                  INNER JOIN user_roles ur ON ur.role_id = rp.role_id
                  WHERE ur.user_id = @id",
                P("@id", userId)))
            {
                while (r.Read())
                    set.Add(r["code"].ToString());
            }
            return set;
        }

        List<string> LoadRoles(string userId)
        {
            var list = new List<string>();
            using (var r = _db.Query(
                @"SELECT r.code FROM roles r INNER JOIN user_roles ur ON ur.role_id = r.id WHERE ur.user_id=@id",
                P("@id", userId)))
            {
                while (r.Read())
                    list.Add(r["code"].ToString());
            }
            return list;
        }

        void Audit(string userId, string username, string action, string details)
        {
            var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            _db.Execute(
                @"INSERT INTO audit_logs (id, actor_user_id, actor_username, action, details_json, created_at)
                  VALUES (@id,@uid,@un,@a,@d,@n)",
                P("@id", Guid.NewGuid().ToString()),
                P("@uid", (object)userId ?? DBNull.Value),
                P("@un", (object)username ?? DBNull.Value),
                P("@a", action),
                P("@d", (object)details ?? DBNull.Value),
                P("@n", now));
        }

        static bool IsDefaultAdminUnlock(string storedUser, string password, bool mustChange)
        {
            return mustChange
                && string.Equals(storedUser, AppConstants.DefaultAdminUser, StringComparison.OrdinalIgnoreCase)
                && password == AppConstants.DefaultAdminPassword;
        }

        static bool IsInfrastructureError(string verifyError)
        {
            if (string.IsNullOrEmpty(verifyError))
                return false;
            return verifyError.IndexOf("FileNotFound", StringComparison.OrdinalIgnoreCase) >= 0
                || verifyError.IndexOf("FileLoad", StringComparison.OrdinalIgnoreCase) >= 0
                || verifyError.IndexOf("Could not load file or assembly", StringComparison.OrdinalIgnoreCase) >= 0
                || verifyError.IndexOf("OutOfMemory", StringComparison.OrdinalIgnoreCase) >= 0;
        }

        static bool ToBool(object v)
        {
            if (v == null || v == DBNull.Value)
                return false;
            if (v is bool)
                return (bool)v;
            return Convert.ToInt32(v) != 0;
        }

        static SQLiteParameter P(string name, object value)
        {
            return new SQLiteParameter(name, value ?? DBNull.Value);
        }
    }
}
