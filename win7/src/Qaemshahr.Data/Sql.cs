using System;
using System.Data.SQLite;

namespace Qaemshahr.Data
{
    static class Sql
    {
        public static SQLiteParameter P(string name, object value)
        {
            return new SQLiteParameter(name, value ?? DBNull.Value);
        }

        public static string Str(object v)
        {
            if (v == null || v == DBNull.Value)
                return null;
            var s = v.ToString();
            return string.IsNullOrWhiteSpace(s) ? null : s;
        }

        public static int Int(object v, int fallback = 0)
        {
            if (v == null || v == DBNull.Value)
                return fallback;
            return Convert.ToInt32(v);
        }

        public static long Long(object v, long fallback = 0)
        {
            if (v == null || v == DBNull.Value)
                return fallback;
            return Convert.ToInt64(v);
        }

        public static double Dbl(object v, double fallback = 0)
        {
            if (v == null || v == DBNull.Value)
                return fallback;
            return Convert.ToDouble(v);
        }

        public static double? DblN(object v)
        {
            if (v == null || v == DBNull.Value)
                return null;
            return Convert.ToDouble(v);
        }

        public static long? LongN(object v)
        {
            if (v == null || v == DBNull.Value)
                return null;
            return Convert.ToInt64(v);
        }

        public static long Now()
        {
            return DateTimeOffset.UtcNow.ToUnixTimeMilliseconds();
        }

        public static string NewId()
        {
            return Guid.NewGuid().ToString();
        }
    }
}
