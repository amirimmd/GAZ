using System;
using Newtonsoft.Json;

namespace Qaemshahr.Core
{
    public sealed class DataVersionInfo
    {
        [JsonProperty("appVersion")]
        public string AppVersion { get; set; }

        [JsonProperty("schemaVersion")]
        public int SchemaVersion { get; set; }

        [JsonProperty("updatedAtUtc")]
        public string UpdatedAtUtc { get; set; }

        public static DataVersionInfo Current()
        {
            return new DataVersionInfo
            {
                AppVersion = AppConstants.AppVersion,
                SchemaVersion = AppConstants.SchemaVersion,
                UpdatedAtUtc = DateTime.UtcNow.ToString("o")
            };
        }
    }
}
