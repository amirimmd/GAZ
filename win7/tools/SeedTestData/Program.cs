using System;
using System.IO;
using Qaemshahr.Core;
using Qaemshahr.Data;

namespace SeedTestData
{
    static class Program
    {
        static int Main(string[] args)
        {
            var active = 300;
            var inactive = 60;
            var incomplete = 5;
            var clear = true;
            var full = true;
            var backupSmoke = false;
            var fillOrg = false;
            string dbPath = null;

            for (var i = 0; i < args.Length; i++)
            {
                var a = args[i];
                if ((a == "--db" || a == "-db") && i + 1 < args.Length)
                    dbPath = args[++i];
                else if ((a == "--count" || a == "-n") && i + 1 < args.Length)
                    int.TryParse(args[++i], out active);
                else if (a == "--active" && i + 1 < args.Length)
                    int.TryParse(args[++i], out active);
                else if (a == "--inactive" && i + 1 < args.Length)
                    int.TryParse(args[++i], out inactive);
                else if (a == "--incomplete" && i + 1 < args.Length)
                    int.TryParse(args[++i], out incomplete);
                else if (a == "--keep" || a == "-keep")
                    clear = false;
                else if (a == "--people-only")
                    full = false;
                else if (a == "--backup-smoke")
                    backupSmoke = true;
                else if (a == "--fill-org")
                    fillOrg = true;
                else if (a == "--help" || a == "-h")
                {
                    PrintHelp();
                    return 0;
                }
            }

            if (string.IsNullOrWhiteSpace(dbPath))
                dbPath = DiscoverDb();

            Console.OutputEncoding = System.Text.Encoding.UTF8;
            Console.WriteLine("DB: " + dbPath);

            if (string.IsNullOrWhiteSpace(dbPath) || !File.Exists(dbPath))
            {
                Console.Error.WriteLine("پایگاه داده پیدا نشد. اول بسته پرتابل را بسازید یا مسیر --db را بدهید.");
                return 2;
            }

            // AppData/data/gaz_hrms.db → install = parent of AppData
            var dataDir = Path.GetDirectoryName(dbPath);
            var appData = Path.GetDirectoryName(dataDir);
            var install = Path.GetDirectoryName(appData);
            AppPaths.ConfigureForTool(install);
            Console.WriteLine("Portable root: " + AppPaths.InstallDirectory + " (portable=" + AppPaths.IsPortable + ")");

            try
            {
                using (var db = AppDatabase.OpenFile(dbPath, writeVersionStore: false, initKeys: true))
                {
                    if (fillOrg)
                    {
                        var n = new EmployeeRepository(db).FillTestOrganizationalFields(new Random(1404));
                        Console.WriteLine("Filled org fields for " + n + " employees");
                        db.Checkpoint();
                        return 0;
                    }

                    if (backupSmoke)
                    {
                        var outPath = Path.Combine(Path.GetTempPath(), "gaz_backup_smoke_" + Guid.NewGuid().ToString("N") + ".gazbak");
                        Console.WriteLine("Backup smoke → " + outPath);
                        var err = BackupService.Create(db, "BackupSmoke1", outPath);
                        if (err != null)
                        {
                            Console.Error.WriteLine("BACKUP FAIL: " + err);
                            return 3;
                        }
                        var size = new FileInfo(outPath).Length;
                        Console.WriteLine("BACKUP OK bytes=" + size);
                        try { File.Delete(outPath); } catch { }
                        return 0;
                    }

                    if (full)
                    {
                        var report = TestScenarioSeeder.SeedAll(db, new TestScenarioSeeder.Options
                        {
                            ActiveCount = active,
                            InactiveCount = inactive,
                            IncompleteCount = incomplete,
                            ClearExisting = clear,
                            SampleYears = 10,
                            GroupCount = 6
                        });
                        Console.WriteLine("Active: " + report.Active);
                        Console.WriteLine("Inactive: " + report.Inactive);
                        Console.WriteLine("Photos: " + report.WithPhoto);
                        Console.WriteLine("Birth docs: " + report.WithBirth);
                        Console.WriteLine("National docs: " + report.WithNational);
                        Console.WriteLine("Military docs: " + report.WithMilitary);
                        Console.WriteLine("Incomplete (active): " + report.IncompleteActive);
                        Console.WriteLine("Sample titles: " + report.SampleTitles);
                        Console.WriteLine("Groups: " + report.Groups);
                        foreach (var e in report.Errors)
                            Console.WriteLine("  ERR " + e);
                    }
                    else
                    {
                        var result = TestEmployeeSeeder.Seed(db, active, inactive, clear);
                        Console.WriteLine("Inserted: " + result.Inserted + " / " + result.Requested);
                        Console.WriteLine("Failed: " + result.Failed);
                        foreach (var e in result.Errors)
                            Console.WriteLine("  ERR " + e);
                    }

                    Console.WriteLine("Active employees SQL: " +
                        db.Scalar("SELECT COUNT(*) FROM employees WHERE deleted_at IS NULL AND employment_status='active'"));
                    Console.WriteLine("Inactive employees SQL: " +
                        db.Scalar("SELECT COUNT(*) FROM employees WHERE deleted_at IS NULL AND employment_status='inactive'"));
                    db.Checkpoint();
                }
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine(ex.ToString());
                return 1;
            }

            return 0;
        }

        static void PrintHelp()
        {
            Console.WriteLine("SeedTestData --db <gaz_hrms.db> [--active 300] [--inactive 60] [--incomplete 5] [--keep] [--people-only] [--backup-smoke]");
        }

        static string DiscoverDb()
        {
            var root = FindRepoRoot();
            var preferred = Path.Combine(root, "dist", "QaemshahrPortable_2.3.3", "AppData", "data", "gaz_hrms.db");
            if (File.Exists(preferred))
                return preferred;
            var dist = Path.Combine(root, "dist");
            if (!Directory.Exists(dist))
                return preferred;
            var dirs = Directory.GetDirectories(dist, "QaemshahrPortable_*");
            Array.Sort(dirs);
            if (dirs.Length == 0)
                return preferred;
            return Path.Combine(dirs[dirs.Length - 1], "AppData", "data", "gaz_hrms.db");
        }

        static string FindRepoRoot()
        {
            var dir = new DirectoryInfo(AppDomain.CurrentDomain.BaseDirectory);
            while (dir != null)
            {
                if (File.Exists(Path.Combine(dir.FullName, "scripts", "build.ps1"))
                    || Directory.Exists(Path.Combine(dir.FullName, "src", "Qaemshahr.App")))
                    return dir.FullName;
                if (dir.Name == "win7" && Directory.Exists(Path.Combine(dir.FullName, "src")))
                    return dir.FullName;
                dir = dir.Parent;
            }
            return Path.GetFullPath(Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..", "..", "..", ".."));
        }
    }
}
