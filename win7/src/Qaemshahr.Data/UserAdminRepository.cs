using System.Collections.Generic;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class UserAdminRepository
    {
        readonly AppDatabase _db;

        public UserAdminRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<UserSummary> List()
        {
            var list = new List<UserSummary>();
            using (var r = _db.Query(@"SELECT u.*, r.code AS role_code, r.name_fa AS role_name
                                       FROM users u
                                       LEFT JOIN user_roles ur ON ur.user_id = u.id
                                       LEFT JOIN roles r ON r.id = ur.role_id
                                       WHERE u.deleted_at IS NULL
                                       ORDER BY u.username"))
            {
                while (r.Read())
                {
                    list.Add(new UserSummary
                    {
                        Id = Sql.Str(r["id"]),
                        Username = Sql.Str(r["username"]),
                        DisplayName = Sql.Str(r["display_name"]),
                        IsActive = Sql.Int(r["is_active"]) != 0,
                        RoleCode = Sql.Str(r["role_code"]),
                        RoleNameFa = Sql.Str(r["role_name"]),
                        MustChangePassword = Sql.Int(r["must_change_password"]) != 0
                    });
                }
            }
            return list;
        }

        public List<KeyValuePair<string, string>> Roles()
        {
            var list = new List<KeyValuePair<string, string>>();
            using (var r = _db.Query("SELECT id, name_fa FROM roles ORDER BY name_fa"))
            {
                while (r.Read())
                    list.Add(new KeyValuePair<string, string>(r["id"].ToString(), r["name_fa"].ToString()));
            }
            return list;
        }

        public string Create(string username, string displayName, string password, string roleId)
        {
            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrEmpty(password))
                return "نام کاربری و رمز الزامی است";
            if (TextUtil.ContainsPersianOrArabic(username) || TextUtil.ContainsPersianOrArabic(password))
                return "نام کاربری و رمز را با صفحه کلید انگلیسی وارد کنید";
            var user = TextUtil.NormalizeUsername(username);
            var policy = PasswordPolicy.ValidateNewPassword(password, user);
            if (policy != null)
                return policy;
            var exists = _db.Scalar("SELECT id FROM users WHERE lower(username)=@u AND deleted_at IS NULL", Sql.P("@u", user));
            if (exists != null && exists != System.DBNull.Value)
                return "این نام کاربری تکراری است";
            var id = Sql.NewId();
            var now = Sql.Now();
            var name = string.IsNullOrWhiteSpace(displayName) ? user : displayName.Trim();
            _db.Execute(@"INSERT INTO users (id, username, display_name, password_hash, is_active, must_change_password, created_at, updated_at)
                          VALUES (@id,@u,@n,@h,1,1,@now,@now)",
                Sql.P("@id", id), Sql.P("@u", user), Sql.P("@n", name),
                Sql.P("@h", PasswordHasher.HashPassword(password)), Sql.P("@now", now));
            if (!string.IsNullOrEmpty(roleId))
                _db.Execute("INSERT INTO user_roles (user_id, role_id) VALUES (@u,@r)", Sql.P("@u", id), Sql.P("@r", roleId));
            return null;
        }

        public void SetActive(string userId, bool active)
        {
            _db.Execute("UPDATE users SET is_active=@a, updated_at=@n WHERE id=@id", Sql.P("@a", active ? 1 : 0), Sql.P("@n", Sql.Now()), Sql.P("@id", userId));
        }

        public void SetRole(string userId, string roleId)
        {
            _db.Execute("DELETE FROM user_roles WHERE user_id=@u", Sql.P("@u", userId));
            if (!string.IsNullOrEmpty(roleId))
                _db.Execute("INSERT INTO user_roles (user_id, role_id) VALUES (@u,@r)", Sql.P("@u", userId), Sql.P("@r", roleId));
        }

        public string ResetPassword(string userId, string newPassword)
        {
            var policy = PasswordPolicy.ValidateNewPassword(newPassword);
            if (policy != null)
                return policy;
            _db.Execute("UPDATE users SET password_hash=@h, must_change_password=1, failed_attempts=0, locked_until=NULL, updated_at=@n WHERE id=@id",
                Sql.P("@h", PasswordHasher.HashPassword(newPassword)), Sql.P("@n", Sql.Now()), Sql.P("@id", userId));
            return null;
        }
    }
}
