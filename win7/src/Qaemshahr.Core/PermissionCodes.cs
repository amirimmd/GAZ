using System.Collections.Generic;

namespace Qaemshahr.Core
{
    public static class PermissionCodes
    {
        public const string SystemSettings = "system.settings";
        public const string SystemBackup = "system.backup";
        public const string SystemRestore = "system.restore";
        public const string SystemAuditView = "system.audit.view";
        public const string SystemAuditExport = "system.audit.export";
        public const string UsersView = "users.view";
        public const string UsersCreate = "users.create";
        public const string UsersEdit = "users.edit";
        public const string UsersDelete = "users.delete";
        public const string UsersRoles = "users.roles";
        public const string EmployeesView = "employees.view";
        public const string EmployeesCreate = "employees.create";
        public const string EmployeesEdit = "employees.edit";
        public const string EmployeesDelete = "employees.delete";
        public const string EmployeesBulk = "employees.bulk";
        public const string EmployeesExport = "employees.export";
        public const string EmployeesImport = "employees.import";
        public const string DocumentsView = "documents.view";
        public const string DocumentsUpload = "documents.upload";
        public const string DocumentsDownload = "documents.download";
        public const string DocumentsDelete = "documents.delete";
        public const string ReportsView = "reports.view";
        public const string ReportsBuild = "reports.build";
        public const string ReportsPrint = "reports.print";
        public const string ReportsExport = "reports.export";
        public const string SearchAdvanced = "search.advanced";
        public const string GroupsView = "groups.view";
        public const string GroupsCreate = "groups.create";
        public const string GroupsEdit = "groups.edit";
        public const string GroupsDelete = "groups.delete";
        public const string GroupsExport = "groups.export";

        public static readonly IReadOnlyList<string> All = new[]
        {
            SystemSettings, SystemBackup, SystemRestore, SystemAuditView, SystemAuditExport,
            UsersView, UsersCreate, UsersEdit, UsersDelete, UsersRoles,
            EmployeesView, EmployeesCreate, EmployeesEdit, EmployeesDelete, EmployeesBulk,
            EmployeesExport, EmployeesImport,
            DocumentsView, DocumentsUpload, DocumentsDownload, DocumentsDelete,
            ReportsView, ReportsBuild, ReportsPrint, ReportsExport,
            SearchAdvanced,
            GroupsView, GroupsCreate, GroupsEdit, GroupsDelete, GroupsExport
        };
    }
}
