namespace Qaemshahr.Data
{
    public sealed class SettingsRepository
    {
        readonly AppDatabase _db;

        public SettingsRepository(AppDatabase db)
        {
            _db = db;
        }

        public string Get(string key, string fallback = null)
        {
            var v = _db.Scalar("SELECT value FROM app_settings WHERE key=@k", Sql.P("@k", key));
            if (v == null || v == System.DBNull.Value)
                return fallback;
            return v.ToString();
        }

        public int GetInt(string key, int fallback)
        {
            int n;
            return int.TryParse(Get(key, fallback.ToString()), out n) ? n : fallback;
        }

        public void Set(string key, string value)
        {
            _db.Execute("INSERT OR REPLACE INTO app_settings (key, value, updated_at) VALUES (@k,@v,@n)",
                Sql.P("@k", key), Sql.P("@v", value ?? string.Empty), Sql.P("@n", Sql.Now()));
        }
    }
}
