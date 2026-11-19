using System;

namespace Qaemshahr.Core
{
    public static class AuditLabels
    {
        public static string ActionFa(string action)
        {
            if (string.IsNullOrWhiteSpace(action))
                return "—";
            switch (action.Trim())
            {
                case "backup.create": return "ساخت پشتیبان";
                case "backup.restore": return "بازیابی پشتیبان";
                case "employee_create":
                case "employee.create": return "ثبت پرسنل";
                case "employee_update":
                case "employee.update":
                case "employee_edit": return "ویرایش پرسنل";
                case "employee_delete":
                case "employee.delete": return "حذف پرسنل";
                case "sample_title_add": return "ثبت عنوان نمونه";
                case "sample_intro_add": return "معرفی فراسازمانی";
                case "login": return "ورود";
                case "logout": return "خروج";
                case "password.change":
                case "password_change": return "تغییر رمز";
                case "user.create": return "ایجاد کاربر";
                case "user.reset_password": return "بازنشانی رمز کاربر";
                case "wipe": return "پاک‌سازی داده";
                case "document_upload":
                case "document.upload": return "بارگذاری سند";
                case "document_delete":
                case "document.delete": return "حذف سند";
                case "document.export_zip": return "خروجی ZIP اسناد";
                case "bulk_import": return "ورود گروهی";
                default: return action.Trim();
            }
        }

        public static string EntityFa(string entityType)
        {
            if (string.IsNullOrWhiteSpace(entityType))
                return "—";
            switch (entityType.Trim())
            {
                case "employee": return "پرسنل";
                case "backup": return "پشتیبان";
                case "sample_title": return "عنوان نمونه";
                case "user": return "کاربر";
                case "document": return "سند";
                case "settings": return "تنظیمات";
                case "group": return "گروه";
                default: return entityType.Trim();
            }
        }

        public static string DetailsFa(string details, string entityId)
        {
            var d = (details ?? "").Trim();
            if (d.Length == 0)
                return string.IsNullOrWhiteSpace(entityId) ? "—" : entityId.Trim();
            // اگر JSON ساده نباشد، همان متن را نشان بده
            if (d.StartsWith("{", StringComparison.Ordinal) || d.StartsWith("[", StringComparison.Ordinal))
            {
                d = d.Replace("\"", "").Replace("{", "").Replace("}", "").Replace("[", "").Replace("]", "");
            }
            if (!string.IsNullOrWhiteSpace(entityId) && d.IndexOf(entityId, StringComparison.OrdinalIgnoreCase) < 0)
                return d + "  ·  " + entityId.Trim();
            return d;
        }
    }
}
