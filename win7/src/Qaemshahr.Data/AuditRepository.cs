using System;
using System.Collections.Generic;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class AuditRepository
    {
        readonly AppDatabase _db;

        public AuditRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<AuditRow> List(int limit = 500)
        {
            var list = new List<AuditRow>();
            using (var r = _db.Query("SELECT * FROM audit_logs ORDER BY created_at DESC LIMIT @n", Sql.P("@n", limit)))
            {
                while (r.Read())
                {
                    list.Add(new AuditRow
                    {
                        Id = Sql.Str(r["id"]),
                        ActorUsername = Sql.Str(r["actor_username"]),
                        Action = Sql.Str(r["action"]),
                        EntityType = Sql.Str(r["entity_type"]),
                        EntityId = HasCol(r, "entity_id") ? Sql.Str(r["entity_id"]) : null,
                        Details = Sql.Str(r["details_json"]),
                        CreatedAt = Sql.Long(r["created_at"])
                    });
                }
            }
            return list;
        }

        public void Add(string userId, string username, string action, string entityType, string details)
        {
            _db.Execute(@"INSERT INTO audit_logs (id, actor_user_id, actor_username, action, entity_type, entity_id, details_json, created_at)
                          VALUES (@id,@uid,@un,@a,@et,@eid,@d,@n)",
                Sql.P("@id", Sql.NewId()), Sql.P("@uid", userId), Sql.P("@un", username), Sql.P("@a", action),
                Sql.P("@et", entityType),
                Sql.P("@eid", details),
                Sql.P("@d", details), Sql.P("@n", Sql.Now()));
        }

        static bool HasCol(System.Data.IDataRecord r, string name)
        {
            for (var i = 0; i < r.FieldCount; i++)
            {
                if (string.Equals(r.GetName(i), name, StringComparison.OrdinalIgnoreCase))
                    return true;
            }
            return false;
        }
    }
}
