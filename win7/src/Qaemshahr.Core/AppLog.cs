using System;
using System.IO;
using System.Text;

namespace Qaemshahr.Core
{
    public static class AppLog
    {
        static readonly object Gate = new object();

        public static void Info(string message)
        {
            Write("INFO", message);
        }

        public static void Error(string message, Exception ex = null)
        {
            Write("ERROR", ex == null ? message : message + " " + ex);
        }

        static void Write(string level, string message)
        {
            try
            {
                AppPaths.EnsureDataDirectories();
                var line = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + " [" + level + "] " + message + Environment.NewLine;
                lock (Gate)
                {
                    File.AppendAllText(AppPaths.LogFile, line, Encoding.UTF8);
                }
            }
            catch
            {
            }
        }
    }
}
