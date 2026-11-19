using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class ReportLayoutRepository
    {
        public const string DefaultId = "layout-1";

        readonly AppDatabase _db;

        public ReportLayoutRepository(AppDatabase db)
        {
            _db = db;
        }

        public void EnsureDefaults()
        {
            if (Get(DefaultId) == null)
            {
                Save(DefaultLayout(
                    DefaultId,
                    "پیش‌فرض",
                    ExcelService.Catalog().FindAll(c => c.Selected).ConvertAll(c => c.Key).ToArray()));
            }
            else
            {
                var existing = Get(DefaultId);
                if (existing != null && (existing.Name == "چیدمان ۱" || string.IsNullOrWhiteSpace(existing.Name)))
                {
                    existing.Name = "پیش‌فرض";
                    Save(existing);
                }
            }
        }

        public ReportLayout Get(string id)
        {
            using (var r = _db.Query("SELECT id, name, config_json FROM report_templates WHERE id=@id", Sql.P("@id", id)))
            {
                if (!r.Read())
                    return null;
                return Map(r);
            }
        }

        public List<ReportLayout> ListAll()
        {
            EnsureDefaults();
            var list = new List<ReportLayout>();
            using (var r = _db.Query(
                "SELECT id, name, config_json FROM report_templates ORDER BY CASE WHEN id=@d THEN 0 ELSE 1 END, created_at ASC",
                Sql.P("@d", DefaultId)))
            {
                while (r.Read())
                    list.Add(Map(r));
            }
            return list;
        }

        public List<ReportLayout> ListSlots()
        {
            return ListAll();
        }

        public string NewId()
        {
            return "layout-" + Guid.NewGuid().ToString("N");
        }

        public void Delete(string id)
        {
            if (string.IsNullOrWhiteSpace(id) || string.Equals(id, DefaultId, StringComparison.OrdinalIgnoreCase))
                return;
            _db.Execute("DELETE FROM report_templates WHERE id=@id", Sql.P("@id", id));
        }

        public void Save(ReportLayout layout)
        {
            if (layout == null || string.IsNullOrWhiteSpace(layout.Id))
                return;
            var payload = new ReportLayoutPayload
            {
                Options = layout.Options ?? ReportExportOptions.CreateDefault(),
                ColumnKeys = layout.ColumnKeys ?? new string[0],
                Filters = layout.Filters ?? ReportEmployeeFilter.CreateDefault()
            };
            var json = JsonConvert.SerializeObject(payload);
            var now = Sql.Now();
            var existing = Get(layout.Id);
            if (existing == null)
            {
                _db.Execute(
                    "INSERT INTO report_templates (id, name, config_json, created_by, created_at, updated_at) VALUES (@id,@n,@j,@u,@c,@u2)",
                    Sql.P("@id", layout.Id),
                    Sql.P("@n", layout.Name ?? layout.Id),
                    Sql.P("@j", json),
                    Sql.P("@u", (object)null),
                    Sql.P("@c", now),
                    Sql.P("@u2", now));
            }
            else
            {
                _db.Execute(
                    "UPDATE report_templates SET name=@n, config_json=@j, updated_at=@u WHERE id=@id",
                    Sql.P("@n", layout.Name ?? existing.Name),
                    Sql.P("@j", json),
                    Sql.P("@u", now),
                    Sql.P("@id", layout.Id));
            }
        }

        static ReportLayout Map(System.Data.IDataRecord r)
        {
            var json = Sql.Str(r["config_json"]) ?? "{}";
            var payload = JsonConvert.DeserializeObject<ReportLayoutPayload>(json) ?? new ReportLayoutPayload();
            return new ReportLayout
            {
                Id = Sql.Str(r["id"]),
                Name = Sql.Str(r["name"]),
                Options = payload.Options ?? ReportExportOptions.CreateDefault(),
                ColumnKeys = payload.ColumnKeys ?? new string[0],
                Filters = payload.Filters ?? ReportEmployeeFilter.CreateDefault()
            };
        }

        static ReportLayout DefaultLayout(string id, string name, string[] keys)
        {
            return new ReportLayout
            {
                Id = id,
                Name = name,
                Options = ReportExportOptions.CreateDefault(),
                ColumnKeys = keys
            };
        }
    }
}
