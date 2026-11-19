using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Services
{
    public static class SessionContext
    {
        public static AppDatabase Database { get; set; }
        public static AuthRepository Auth { get; set; }
        public static EmployeeRepository Employees { get; set; }
        public static GroupRepository Groups { get; set; }
        public static DocumentRepository Documents { get; set; }
        public static UserAdminRepository Users { get; set; }
        public static AuditRepository Audit { get; set; }
        public static SettingsRepository Settings { get; set; }
        public static FieldSuggestionRepository FieldSuggestions { get; set; }
        public static ReportLayoutRepository ReportLayouts { get; set; }
        public static PerformanceReviewRepository Performance { get; set; }
        public static SampleTitleRepository SampleTitles { get; set; }
        public static HrDashboardService Dashboard { get; set; }
        public static UserSession Current { get; set; }

        public static void Bind(AppDatabase db)
        {
            Database = db;
            Auth = new AuthRepository(db);
            Employees = new EmployeeRepository(db);
            Groups = new GroupRepository(db);
            Documents = new DocumentRepository(db);
            Users = new UserAdminRepository(db);
            Audit = new AuditRepository(db);
            Settings = new SettingsRepository(db);
            FieldSuggestions = new FieldSuggestionRepository(db);
            try { FieldSuggestions.SeedFromEmployeesIfEmpty(); }
            catch { }
            ReportLayouts = new ReportLayoutRepository(db);
            Performance = new PerformanceReviewRepository(db);
            SampleTitles = new SampleTitleRepository(db);
            Dashboard = new HrDashboardService(Employees, Documents, Groups);
            try { Employees.ApplyDueRetirements(); }
            catch { }
        }

        /// <summary>قطع اتصال و پاک‌کردن رفرنس‌ها تا بعد از Dispose چیزی به SQLite دسترسی نکند.</summary>
        public static void Unbind(bool disposeDatabase = true)
        {
            var db = Database;
            Database = null;
            Auth = null;
            Employees = null;
            Groups = null;
            Documents = null;
            Users = null;
            Audit = null;
            Settings = null;
            FieldSuggestions = null;
            ReportLayouts = null;
            Performance = null;
            SampleTitles = null;
            Dashboard = null;
            if (disposeDatabase && db != null)
            {
                try { db.Dispose(); }
                catch { }
            }
        }

        public static bool Can(string permission)
        {
            return Current != null && Current.User != null && Current.User.Permissions != null
                && Current.User.Permissions.Contains(permission);
        }
    }
}
