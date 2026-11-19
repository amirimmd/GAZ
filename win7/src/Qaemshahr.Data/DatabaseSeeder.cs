using System;
using System.Collections.Generic;
using System.Data.SQLite;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class DatabaseSeeder
    {
        public static void SeedIfEmpty(AppDatabase db)
        {
            var count = Convert.ToInt64(db.Scalar("SELECT COUNT(*) FROM users") ?? 0);
            if (count > 0)
                return;

            var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
            var adminRoleId = Guid.NewGuid().ToString();
            var hrRoleId = Guid.NewGuid().ToString();
            var operatorRoleId = Guid.NewGuid().ToString();
            var viewerRoleId = Guid.NewGuid().ToString();

            InsertRole(db, adminRoleId, "administrator", "مدیر سیستم", "Administrator", true);
            InsertRole(db, hrRoleId, "hr_manager", "مدیر منابع انسانی", "HR Manager", true);
            InsertRole(db, operatorRoleId, "operator", "اپراتور", "Operator", true);
            InsertRole(db, viewerRoleId, "viewer", "بازدیدکننده", "Viewer", true);

            var permissionIds = new Dictionary<string, string>();
            foreach (var code in PermissionCodes.All)
            {
                var id = Guid.NewGuid().ToString();
                permissionIds[code] = id;
                var module = code.Split('.')[0];
                db.Execute(
                    "INSERT INTO permissions (id, code, module, name_fa, name_en) VALUES (@id,@code,@m,@code,@code)",
                    P("@id", id), P("@code", code), P("@m", module));
            }

            Grant(db, adminRoleId, PermissionCodes.All, permissionIds);

            Grant(db, hrRoleId, new[]
            {
                PermissionCodes.EmployeesView, PermissionCodes.EmployeesCreate, PermissionCodes.EmployeesEdit,
                PermissionCodes.EmployeesDelete, PermissionCodes.EmployeesBulk, PermissionCodes.EmployeesExport,
                PermissionCodes.EmployeesImport, PermissionCodes.DocumentsView, PermissionCodes.DocumentsUpload,
                PermissionCodes.DocumentsDownload, PermissionCodes.DocumentsDelete, PermissionCodes.ReportsView,
                PermissionCodes.ReportsBuild, PermissionCodes.ReportsPrint, PermissionCodes.ReportsExport,
                PermissionCodes.SearchAdvanced, PermissionCodes.SystemAuditView, PermissionCodes.GroupsView,
                PermissionCodes.GroupsCreate, PermissionCodes.GroupsEdit, PermissionCodes.GroupsDelete,
                PermissionCodes.GroupsExport
            }, permissionIds);

            Grant(db, operatorRoleId, new[]
            {
                PermissionCodes.EmployeesView, PermissionCodes.EmployeesCreate, PermissionCodes.EmployeesEdit,
                PermissionCodes.DocumentsView, PermissionCodes.DocumentsUpload, PermissionCodes.ReportsView
            }, permissionIds);

            Grant(db, viewerRoleId, new[]
            {
                PermissionCodes.EmployeesView, PermissionCodes.DocumentsView, PermissionCodes.ReportsView
            }, permissionIds);

            var adminId = Guid.NewGuid().ToString();
            var hash = PasswordHasher.HashPassword(AppConstants.DefaultAdminPassword);
            db.Execute(
                @"INSERT INTO users (id, username, display_name, password_hash, is_active, failed_attempts,
                  must_change_password, remember_me_enabled, created_at, updated_at)
                  VALUES (@id,@u,@n,@h,1,0,1,0,@now,@now)",
                P("@id", adminId),
                P("@u", AppConstants.DefaultAdminUser),
                P("@n", "مدیر سیستم"),
                P("@h", hash),
                P("@now", now));
            db.Execute(
                "INSERT INTO user_roles (user_id, role_id) VALUES (@u,@r)",
                P("@u", adminId), P("@r", adminRoleId));

            InsertSetting(db, "organization.name.fa", AppConstants.OrganizationNameFa, now);
            InsertSetting(db, "organization.name.en", AppConstants.OrganizationNameEn, now);
            InsertSetting(db, "security.session_timeout_minutes", AppConstants.DefaultSessionTimeoutMinutes.ToString(), now);
            InsertSetting(db, "security.auto_lock_minutes", AppConstants.DefaultAutoLockMinutes.ToString(), now);
            InsertSetting(db, "locale", "fa", now);
        }

        static void InsertRole(AppDatabase db, string id, string code, string fa, string en, bool system)
        {
            db.Execute(
                "INSERT INTO roles (id, code, name_fa, name_en, is_system) VALUES (@id,@c,@fa,@en,@s)",
                P("@id", id), P("@c", code), P("@fa", fa), P("@en", en), P("@s", system ? 1 : 0));
        }

        static void Grant(AppDatabase db, string roleId, IReadOnlyList<string> codes, Dictionary<string, string> map)
        {
            foreach (var code in codes)
            {
                string pid;
                if (!map.TryGetValue(code, out pid))
                    continue;
                db.Execute(
                    "INSERT INTO role_permissions (role_id, permission_id) VALUES (@r,@p)",
                    P("@r", roleId), P("@p", pid));
            }
        }

        static void InsertSetting(AppDatabase db, string key, string value, long now)
        {
            db.Execute(
                "INSERT INTO app_settings (key, value, updated_at) VALUES (@k,@v,@n)",
                P("@k", key), P("@v", value), P("@n", now));
        }

        static SQLiteParameter P(string name, object value)
        {
            return new SQLiteParameter(name, value ?? DBNull.Value);
        }
    }
}
