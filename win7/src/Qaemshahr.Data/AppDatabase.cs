using System;
using System.Data;
using System.Data.SQLite;
using System.IO;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public sealed class AppDatabase : IDisposable
    {
        readonly SQLiteConnection _connection;

        public AppDatabase(string path)
        {
            var cs = new SQLiteConnectionStringBuilder
            {
                DataSource = path,
                ForeignKeys = true,
                JournalMode = SQLiteJournalModeEnum.Wal,
                FailIfMissing = false,
                Version = 3
            };
            _connection = new SQLiteConnection(cs.ToString());
            _connection.Open();
            using (var cmd = _connection.CreateCommand())
            {
                cmd.CommandText = "PRAGMA foreign_keys = ON; PRAGMA journal_mode = WAL;";
                cmd.ExecuteNonQuery();
            }
        }

        public SQLiteConnection Connection { get { return _connection; } }

        public int ReadUserVersion()
        {
            using (var cmd = _connection.CreateCommand())
            {
                cmd.CommandText = "PRAGMA user_version";
                var v = cmd.ExecuteScalar();
                return Convert.ToInt32(v);
            }
        }

        public void SetUserVersion(int version)
        {
            using (var cmd = _connection.CreateCommand())
            {
                cmd.CommandText = "PRAGMA user_version = " + version;
                cmd.ExecuteNonQuery();
            }
        }

        public int Execute(string sql, params SQLiteParameter[] parameters)
        {
            using (var cmd = _connection.CreateCommand())
            {
                cmd.CommandText = sql;
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteNonQuery();
            }
        }

        public void RunInTransaction(Action work)
        {
            if (work == null)
                return;
            using (var tx = _connection.BeginTransaction())
            {
                try
                {
                    work();
                    tx.Commit();
                }
                catch
                {
                    try { tx.Rollback(); } catch { }
                    throw;
                }
            }
        }

        public object Scalar(string sql, params SQLiteParameter[] parameters)
        {
            using (var cmd = _connection.CreateCommand())
            {
                cmd.CommandText = sql;
                if (parameters != null)
                    cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteScalar();
            }
        }

        public SQLiteDataReader Query(string sql, params SQLiteParameter[] parameters)
        {
            var cmd = _connection.CreateCommand();
            cmd.CommandText = sql;
            if (parameters != null)
                cmd.Parameters.AddRange(parameters);
            return cmd.ExecuteReader();
        }

        public static AppDatabase OpenOrCreate()
        {
            AppPaths.EnsureDataDirectories();
            var db = OpenFile(AppPaths.DatabaseFile, writeVersionStore: true, initKeys: true);
            ClearStaleLockouts(db);
            return db;
        }

        /// <summary>باز کردن پایگاه در مسیر دلخواه (برای ابزار seed/تست).</summary>
        public static AppDatabase OpenFile(string databaseFile, bool writeVersionStore = false, bool initKeys = false)
        {
            if (string.IsNullOrWhiteSpace(databaseFile))
                throw new ArgumentException("مسیر پایگاه داده خالی است.", "databaseFile");

            var dir = Path.GetDirectoryName(databaseFile);
            if (!string.IsNullOrEmpty(dir))
                Directory.CreateDirectory(dir);

            var created = !File.Exists(databaseFile);
            var db = new AppDatabase(databaseFile);
            try
            {
                if (writeVersionStore)
                {
                    var fileVersion = VersionStore.Read();
                    if (fileVersion != null)
                    {
                        Version newer;
                        Version current;
                        if (Version.TryParse(Normalize(fileVersion.AppVersion), out newer)
                            && Version.TryParse(Normalize(AppConstants.AppVersion), out current)
                            && newer > current)
                        {
                            db.Dispose();
                            throw new SchemaTooNewException(
                                "این پرونده با نسخهٔ بالاتر " + fileVersion.AppVersion
                                + " ساخته شده است. ستاپ جدید را نصب کنید.");
                        }
                    }
                }

                var userVersion = db.ReadUserVersion();
                if (userVersion > AppConstants.SchemaVersion)
                {
                    db.Dispose();
                    throw new SchemaTooNewException(
                        "ساختار پایگاه داده جدیدتر از این برنامه است. ستاپ جدید را نصب کنید.");
                }

                if (created || userVersion == 0)
                {
                    ApplyCreate(db);
                    DatabaseSeeder.SeedIfEmpty(db);
                    db.SetUserVersion(AppConstants.SchemaVersion);
                    if (writeVersionStore)
                        VersionStore.WriteCurrent();
                    AppLog.Info(created ? "Database created and seeded." : "Empty database seeded.");
                }
                else if (userVersion < AppConstants.SchemaVersion)
                {
                    DatabaseMigrator.Upgrade(db, userVersion, AppConstants.SchemaVersion);
                    if (writeVersionStore)
                        VersionStore.WriteCurrent();
                    AppLog.Info("Database migrated " + userVersion + " -> " + AppConstants.SchemaVersion);
                }
                else if (writeVersionStore)
                {
                    VersionStore.WriteCurrent();
                }

                if (initKeys)
                    KeyStore.Initialize();
                return db;
            }
            catch
            {
                db.Dispose();
                throw;
            }
        }

        static void ClearStaleLockouts(AppDatabase db)
        {
            try
            {
                var flag = db.Scalar("SELECT value FROM app_settings WHERE key=@k",
                    new SQLiteParameter("@k", "security.lockout_repaired_2_1_2"));
                if (flag != null && flag != DBNull.Value && flag.ToString() == "1")
                    return;

                db.Execute("UPDATE users SET failed_attempts=0, locked_until=NULL WHERE failed_attempts<>0 OR locked_until IS NOT NULL");
                var now = DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
                db.Execute(
                    "INSERT OR REPLACE INTO app_settings (key, value, updated_at) VALUES (@k,@v,@n)",
                    new SQLiteParameter("@k", "security.lockout_repaired_2_1_2"),
                    new SQLiteParameter("@v", "1"),
                    new SQLiteParameter("@n", now));
                AppLog.Info("Cleared lockouts created by the Argon2 assembly-load bug.");
            }
            catch (Exception ex)
            {
                AppLog.Error("ClearStaleLockouts failed", ex);
            }
        }

        static void ApplyCreate(AppDatabase db)
        {
            using (var tx = db._connection.BeginTransaction())
            using (var cmd = db._connection.CreateCommand())
            {
                cmd.Transaction = tx;
                cmd.CommandText = SchemaSql.CreateAll;
                cmd.ExecuteNonQuery();
                tx.Commit();
            }
        }

        static string Normalize(string v)
        {
            if (string.IsNullOrEmpty(v))
                return "0.0.0";
            var parts = v.Split('.');
            if (parts.Length >= 4)
                return v;
            if (parts.Length == 3)
                return v;
            if (parts.Length == 2)
                return v + ".0";
            return v + ".0.0";
        }

        public void Checkpoint()
        {
            try
            {
                using (var cmd = _connection.CreateCommand())
                {
                    cmd.CommandText = "PRAGMA wal_checkpoint(TRUNCATE);";
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                AppLog.Error("WAL checkpoint failed", ex);
            }
        }

        /// <summary>
        /// کپی یکپارچه از پایگاه در حال استفاده (بدون خطای «being used by another process»).
        /// </summary>
        public byte[] ExportConsistentBytes()
        {
            Checkpoint();
            var temp = Path.Combine(Path.GetTempPath(), "gaz_bak_" + Guid.NewGuid().ToString("N") + ".db");
            try
            {
                if (File.Exists(temp))
                    File.Delete(temp);
                var cs = new SQLiteConnectionStringBuilder
                {
                    DataSource = temp,
                    Version = 3,
                    JournalMode = SQLiteJournalModeEnum.Delete,
                    FailIfMissing = false
                };
                using (var dest = new SQLiteConnection(cs.ToString()))
                {
                    dest.Open();
                    _connection.BackupDatabase(dest, "main", "main", -1, null, 100);
                    dest.Close();
                }
                return File.ReadAllBytes(temp);
            }
            finally
            {
                try
                {
                    if (File.Exists(temp))
                        File.Delete(temp);
                }
                catch
                {
                }
            }
        }

        public void Dispose()
        {
            try
            {
                if (_connection != null && _connection.State != ConnectionState.Closed)
                    Checkpoint();
            }
            catch
            {
            }
            try
            {
                if (_connection != null)
                {
                    if (_connection.State != ConnectionState.Closed)
                        _connection.Close();
                    _connection.Dispose();
                }
            }
            catch
            {
            }
        }
    }

    public sealed class SchemaTooNewException : Exception
    {
        public SchemaTooNewException(string message) : base(message) { }
    }
}
