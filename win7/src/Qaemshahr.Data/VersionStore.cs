using System;
using System.IO;
using Newtonsoft.Json;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class VersionStore
    {
        public static DataVersionInfo Read()
        {
            try
            {
                if (!File.Exists(AppPaths.VersionFile))
                    return null;
                var json = File.ReadAllText(AppPaths.VersionFile);
                return JsonConvert.DeserializeObject<DataVersionInfo>(json);
            }
            catch (Exception ex)
            {
                AppLog.Error("Could not read version.json", ex);
                return null;
            }
        }

        public static void WriteCurrent()
        {
            AppPaths.EnsureDataDirectories();
            var json = JsonConvert.SerializeObject(DataVersionInfo.Current(), Formatting.Indented);
            File.WriteAllText(AppPaths.VersionFile, json);
        }
    }
}
