using System.Collections.Generic;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class GroupRepository
    {
        readonly AppDatabase _db;

        public GroupRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<EmployeeGroup> List(string search = null, string status = "active")
        {
            var sql = @"SELECT g.*, (SELECT COUNT(*) FROM employee_group_members m WHERE m.group_id = g.id) AS member_count
                        FROM employee_groups g WHERE g.deleted_at IS NULL";
            if (!string.IsNullOrEmpty(status))
                sql += " AND g.status = @st";
            sql += " ORDER BY g.updated_at DESC";
            var list = new List<EmployeeGroup>();
            using (var r = _db.Query(sql, string.IsNullOrEmpty(status) ? new System.Data.SQLite.SQLiteParameter[0] : new[] { Sql.P("@st", status) }))
            {
                while (r.Read())
                {
                    var g = Map(r);
                    if (!string.IsNullOrWhiteSpace(search))
                    {
                        var hay = ((g.Name ?? "") + " " + (g.Description ?? "")).ToLowerInvariant();
                        if (hay.IndexOf(search.Trim().ToLowerInvariant()) < 0)
                            continue;
                    }
                    list.Add(g);
                }
            }
            return list;
        }

        public EmployeeGroup Get(string id)
        {
            using (var r = _db.Query("SELECT g.*, (SELECT COUNT(*) FROM employee_group_members m WHERE m.group_id = g.id) AS member_count FROM employee_groups g WHERE g.id=@id AND g.deleted_at IS NULL", Sql.P("@id", id)))
            {
                if (!r.Read())
                    return null;
                var g = Map(r);
                g.MemberIds = MemberIds(id);
                return g;
            }
        }

        public List<string> MemberIds(string groupId)
        {
            var ids = new List<string>();
            using (var r = _db.Query("SELECT employee_id FROM employee_group_members WHERE group_id=@id", Sql.P("@id", groupId)))
            {
                while (r.Read())
                    ids.Add(r["employee_id"].ToString());
            }
            return ids;
        }

        public string Save(EmployeeGroup g, IList<string> memberIds, string userId)
        {
            if (g == null || string.IsNullOrWhiteSpace(g.Name))
                return "نام گروه الزامی است";
            var now = Sql.Now();
            var isNew = string.IsNullOrEmpty(g.Id);
            if (isNew)
                g.Id = Sql.NewId();
            if (string.IsNullOrEmpty(g.PurposeType))
                g.PurposeType = "other";
            if (string.IsNullOrEmpty(g.Status))
                g.Status = "active";
            if (isNew)
            {
                _db.Execute(@"INSERT INTO employee_groups (id, name, description, purpose_type, starts_at, ends_at, status, photo_path, created_by, created_at, updated_at)
                              VALUES (@id,@n,@d,@p,@s,@e,@st,@ph,@cb,@now,@now)",
                    Sql.P("@id", g.Id), Sql.P("@n", g.Name.Trim()), Sql.P("@d", g.Description), Sql.P("@p", g.PurposeType),
                    Sql.P("@s", (object)g.StartsAt ?? System.DBNull.Value), Sql.P("@e", (object)g.EndsAt ?? System.DBNull.Value),
                    Sql.P("@st", g.Status), Sql.P("@ph", (object)g.PhotoPath ?? System.DBNull.Value),
                    Sql.P("@cb", userId), Sql.P("@now", now));
            }
            else
            {
                _db.Execute(@"UPDATE employee_groups SET name=@n, description=@d, purpose_type=@p, starts_at=@s, ends_at=@e, status=@st, photo_path=@ph, updated_at=@now WHERE id=@id",
                    Sql.P("@id", g.Id), Sql.P("@n", g.Name.Trim()), Sql.P("@d", g.Description), Sql.P("@p", g.PurposeType),
                    Sql.P("@s", (object)g.StartsAt ?? System.DBNull.Value), Sql.P("@e", (object)g.EndsAt ?? System.DBNull.Value),
                    Sql.P("@st", g.Status), Sql.P("@ph", (object)g.PhotoPath ?? System.DBNull.Value), Sql.P("@now", now));
            }
            _db.Execute("DELETE FROM employee_group_members WHERE group_id=@id", Sql.P("@id", g.Id));
            if (memberIds != null)
            {
                foreach (var eid in memberIds)
                {
                    if (string.IsNullOrEmpty(eid)) continue;
                    _db.Execute("INSERT OR IGNORE INTO employee_group_members (id, group_id, employee_id, added_at, added_by) VALUES (@id,@g,@e,@now,@u)",
                        Sql.P("@id", Sql.NewId()), Sql.P("@g", g.Id), Sql.P("@e", eid), Sql.P("@now", now), Sql.P("@u", userId));
                }
            }
            return null;
        }

        public void SoftDelete(string id)
        {
            var g = Get(id);
            if (g != null && !string.IsNullOrWhiteSpace(g.PhotoPath))
                EmployeePhotoStore.Delete(g.PhotoPath);
            _db.Execute("UPDATE employee_groups SET deleted_at=@n, updated_at=@n WHERE id=@id", Sql.P("@n", Sql.Now()), Sql.P("@id", id));
        }

        public void SetPhotoPath(string groupId, string relativePath)
        {
            if (string.IsNullOrWhiteSpace(groupId))
                return;
            _db.Execute("UPDATE employee_groups SET photo_path=@p, updated_at=@n WHERE id=@id",
                Sql.P("@p", (object)relativePath ?? System.DBNull.Value),
                Sql.P("@n", Sql.Now()),
                Sql.P("@id", groupId));
        }

        public List<GroupActivity> ListActivities(string groupId, int limit = 50)
        {
            var list = new List<GroupActivity>();
            if (string.IsNullOrWhiteSpace(groupId))
                return list;
            var sql = @"SELECT * FROM employee_group_activities
                        WHERE group_id=@g AND deleted_at IS NULL
                        ORDER BY COALESCE(activity_date,'' ) DESC, created_at DESC";
            if (limit > 0)
                sql += " LIMIT " + limit;
            using (var r = _db.Query(sql, Sql.P("@g", groupId)))
            {
                while (r.Read())
                    list.Add(MapActivity(r));
            }
            return list;
        }

        public string AddActivity(GroupActivity a, string userId, string userName)
        {
            if (a == null || string.IsNullOrWhiteSpace(a.GroupId))
                return "گروه نامعتبر است";
            if (string.IsNullOrWhiteSpace(a.Title))
                return "عنوان فعالیت الزامی است";
            a.Id = Sql.NewId();
            a.CreatedAt = Sql.Now();
            a.CreatedBy = userId;
            a.CreatedByName = userName;
            var date = string.IsNullOrWhiteSpace(a.ActivityDate)
                ? PersianDate.Today()
                : (PersianDate.Normalize(a.ActivityDate.Trim()) ?? a.ActivityDate.Trim());
            _db.Execute(@"INSERT INTO employee_group_activities
                (id, group_id, title, note, activity_date, created_by, created_by_name, created_at)
                VALUES (@id,@g,@t,@n,@d,@cb,@cn,@now)",
                Sql.P("@id", a.Id),
                Sql.P("@g", a.GroupId),
                Sql.P("@t", a.Title.Trim()),
                Sql.P("@n", string.IsNullOrWhiteSpace(a.Note) ? null : a.Note.Trim()),
                Sql.P("@d", date),
                Sql.P("@cb", userId),
                Sql.P("@cn", userName),
                Sql.P("@now", a.CreatedAt));
            _db.Execute("UPDATE employee_groups SET updated_at=@n WHERE id=@id",
                Sql.P("@n", a.CreatedAt), Sql.P("@id", a.GroupId));
            return null;
        }

        public void SoftDeleteActivity(string activityId)
        {
            if (string.IsNullOrWhiteSpace(activityId))
                return;
            _db.Execute("UPDATE employee_group_activities SET deleted_at=@n WHERE id=@id",
                Sql.P("@n", Sql.Now()), Sql.P("@id", activityId));
        }

        static GroupActivity MapActivity(System.Data.IDataRecord r)
        {
            return new GroupActivity
            {
                Id = Sql.Str(r["id"]),
                GroupId = Sql.Str(r["group_id"]),
                Title = Sql.Str(r["title"]),
                Note = Sql.Str(r["note"]),
                ActivityDate = Sql.Str(r["activity_date"]),
                CreatedBy = Sql.Str(r["created_by"]),
                CreatedByName = Sql.Str(r["created_by_name"]),
                CreatedAt = Sql.Long(r["created_at"])
            };
        }

        static EmployeeGroup Map(System.Data.IDataRecord r)
        {
            return new EmployeeGroup
            {
                Id = Sql.Str(r["id"]),
                Name = Sql.Str(r["name"]),
                Description = Sql.Str(r["description"]),
                PurposeType = Sql.Str(r["purpose_type"]) ?? "other",
                Status = Sql.Str(r["status"]) ?? "active",
                PhotoPath = HasCol(r, "photo_path") ? Sql.Str(r["photo_path"]) : null,
                StartsAt = r["starts_at"] == System.DBNull.Value ? (long?)null : Sql.Long(r["starts_at"]),
                EndsAt = r["ends_at"] == System.DBNull.Value ? (long?)null : Sql.Long(r["ends_at"]),
                CreatedBy = Sql.Str(r["created_by"]),
                MemberCount = Sql.Int(r["member_count"])
            };
        }

        static bool HasCol(System.Data.IDataRecord r, string name)
        {
            for (var i = 0; i < r.FieldCount; i++)
            {
                if (string.Equals(r.GetName(i), name, System.StringComparison.OrdinalIgnoreCase))
                    return true;
            }
            return false;
        }
    }
}
