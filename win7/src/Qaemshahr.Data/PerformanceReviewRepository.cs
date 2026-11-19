using System;
using System.Collections.Generic;
using System.Globalization;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class PerformanceReviewRepository
    {
        readonly AppDatabase _db;

        public PerformanceReviewRepository(AppDatabase db)
        {
            _db = db;
        }

        public PerformanceReview Get(string employeeId, int year, int season, string track)
        {
            if (string.IsNullOrEmpty(employeeId))
                return null;
            using (var r = _db.Query(
                "SELECT * FROM employee_performance_reviews WHERE employee_id=@e AND year=@y AND season=@s AND track=@t",
                Sql.P("@e", employeeId), Sql.P("@y", year), Sql.P("@s", season), Sql.P("@t", track ?? PerformanceTracks.Staff)))
            {
                if (!r.Read())
                    return null;
                var review = Map(r);
                review.Projects = LoadProjects(review.Id);
                return review;
            }
        }

        public PerformanceReview GetOrCreate(string employeeId, int year, int season, string track, string evaluatorName, string evaluatorUserId)
        {
            var existing = Get(employeeId, year, season, track);
            if (existing != null)
                return existing;
            return new PerformanceReview
            {
                Id = Sql.NewId(),
                EmployeeId = employeeId,
                Year = year,
                Season = season,
                Track = string.IsNullOrWhiteSpace(track) ? PerformanceTracks.Staff : track,
                Status = PerformanceStatuses.Draft,
                EvaluatorName = evaluatorName,
                EvaluatorUserId = evaluatorUserId,
                CreatedAt = Sql.Now(),
                UpdatedAt = Sql.Now()
            };
        }

        public List<PerformanceReview> ListForEmployee(string employeeId)
        {
            var list = new List<PerformanceReview>();
            if (string.IsNullOrEmpty(employeeId))
                return list;
            using (var r = _db.Query(
                "SELECT * FROM employee_performance_reviews WHERE employee_id=@e ORDER BY year DESC, season DESC, track",
                Sql.P("@e", employeeId)))
            {
                while (r.Read())
                {
                    var review = Map(r);
                    review.Projects = LoadProjects(review.Id);
                    list.Add(review);
                }
            }
            return list;
        }

        public string Save(PerformanceReview review, bool approve)
        {
            if (review == null || string.IsNullOrEmpty(review.EmployeeId))
                return "کارمند نامعتبر است";
            if (review.Year < 1300 || review.Year > 1600)
                return "سال شمسی نامعتبر است";
            if (review.Season < 1 || review.Season > 4)
                return "فصل باید بین ۱ تا ۴ باشد";
            if (review.Track != PerformanceTracks.Staff && review.Track != PerformanceTracks.Worker)
                return "مسیر ارزیابی نامعتبر است";

            if (approve)
            {
                var check = EvaluationScoring.Compute(review);
                if (!check.IsComplete)
                    return check.Message ?? "برای تأیید، همه فیلدهای الزامی مسیر را کامل کنید.";
                if (check.ExtraScore != null && check.ExtraScore.Value >= EvaluationScoring.ExtraOrgBadgeThreshold
                    && string.IsNullOrWhiteSpace(review.ExtraEvidence))
                    return "برای نشان فراسازمانی (نمره ≥ ۸۰) شرح شاهد الزامی است.";
                review.Status = PerformanceStatuses.Approved;
                review.ApprovedAt = Sql.Now();
            }
            else
            {
                review.Status = PerformanceStatuses.Draft;
                review.ApprovedAt = null;
            }

            EvaluationScoring.Apply(review);
            var now = Sql.Now();
            if (string.IsNullOrEmpty(review.Id))
                review.Id = Sql.NewId();
            if (review.CreatedAt <= 0)
                review.CreatedAt = now;
            review.UpdatedAt = now;

            try
            {
                _db.RunInTransaction(() => PersistCore(review, now));
            }
            catch (Exception ex)
            {
                return "ذخیره ارزیابی ناموفق بود: " + ex.Message;
            }
            return null;
        }

        void PersistCore(PerformanceReview review, long now)
        {
            var exists = _db.Scalar("SELECT id FROM employee_performance_reviews WHERE id=@id", Sql.P("@id", review.Id));
            if (exists == null || exists == DBNull.Value)
            {
                var conflict = _db.Scalar(
                    "SELECT id FROM employee_performance_reviews WHERE employee_id=@e AND year=@y AND season=@s AND track=@t",
                    Sql.P("@e", review.EmployeeId), Sql.P("@y", review.Year), Sql.P("@s", review.Season), Sql.P("@t", review.Track));
                if (conflict != null && conflict != DBNull.Value)
                    review.Id = conflict.ToString();
            }

            exists = _db.Scalar("SELECT id FROM employee_performance_reviews WHERE id=@id", Sql.P("@id", review.Id));
            if (exists != null && exists != DBNull.Value)
            {
                _db.Execute(@"UPDATE employee_performance_reviews SET
                  year=@y, season=@s, track=@t, status=@st, evaluator_name=@en, evaluator_user_id=@eu, notes=@notes,
                  check_in=@ci, check_out=@co, presence_hours=@ph, duty_hours=@dh,
                  worksheet_count=@wc, worksheet_quota=@wq,
                  complaints_filed=@cf, complaints_valid=@cv, complaints_answered=@ca,
                  response_quality=@rq, social_participation=@sp,
                  extra_effort=@ee, extra_human_capital=@eh, extra_org_relations=@eo, extra_club=@ec, extra_evidence=@ev,
                  expected_projects=@xp, expected_volume=@xv, expected_checklists=@xc,
                  main_score=@ms, extra_score=@xs, light_code=@lc, safety_red_flag=@sf, exemplary=@ex, extra_org_badge=@ob,
                  approved_at=@aa, updated_at=@now
                  WHERE id=@id", Params(review, now));
            }
            else
            {
                _db.Execute(@"INSERT INTO employee_performance_reviews (
                  id, employee_id, year, season, track, status, evaluator_name, evaluator_user_id, notes,
                  check_in, check_out, presence_hours, duty_hours, worksheet_count, worksheet_quota,
                  complaints_filed, complaints_valid, complaints_answered, response_quality, social_participation,
                  extra_effort, extra_human_capital, extra_org_relations, extra_club, extra_evidence,
                  expected_projects, expected_volume, expected_checklists,
                  main_score, extra_score, light_code, safety_red_flag, exemplary, extra_org_badge,
                  approved_at, created_at, updated_at)
                  VALUES (
                  @id,@eid,@y,@s,@t,@st,@en,@eu,@notes,
                  @ci,@co,@ph,@dh,@wc,@wq,
                  @cf,@cv,@ca,@rq,@sp,
                  @ee,@eh,@eo,@ec,@ev,
                  @xp,@xv,@xc,
                  @ms,@xs,@lc,@sf,@ex,@ob,
                  @aa,@created,@now)", Params(review, now));
            }

            SaveProjects(review);
            SyncLegacySummary(review);
        }

        public void AttachLatestApproved(IList<Employee> people)
        {
            if (people == null || people.Count == 0)
                return;
            var map = new Dictionary<string, PerformanceReview>(people.Count);
            using (var r = _db.Query(@"
SELECT employee_id, main_score, light_code, track, year, season,
       exemplary, extra_org_badge, updated_at
FROM employee_performance_reviews
WHERE status='approved'
ORDER BY year DESC, season DESC, updated_at DESC"))
            {
                while (r.Read())
                {
                    var eid = Sql.Str(r["employee_id"]);
                    if (string.IsNullOrEmpty(eid) || map.ContainsKey(eid))
                        continue;
                    map[eid] = new PerformanceReview
                    {
                        EmployeeId = eid,
                        MainScore = Sql.DblN(r["main_score"]),
                        LightCode = Sql.Str(r["light_code"]) ?? PerformanceLights.Gray,
                        Track = Sql.Str(r["track"]),
                        Year = Sql.Int(r["year"]),
                        Season = Sql.Int(r["season"]),
                        Exemplary = Sql.Int(r["exemplary"]) == 1,
                        ExtraOrgBadge = Sql.Int(r["extra_org_badge"]) == 1
                    };
                }
            }
            foreach (var p in people)
            {
                if (p == null || string.IsNullOrEmpty(p.Id))
                    continue;
                PerformanceReview review;
                if (!map.TryGetValue(p.Id, out review))
                {
                    p.PerformanceLight = PerformanceLights.Gray;
                    p.PerformanceScore = null;
                    // نمونه/فراسازمانی دیگر از ارزیابی خوانده نمی‌شود؛ رجیستری سالانه مسئول است.
                    p.PerformancePeriodFa = null;
                    p.PerformanceYear = 0;
                    p.PerformanceSeason = 0;
                    continue;
                }
                p.PerformanceLight = review.LightCode ?? PerformanceLights.Gray;
                p.PerformanceScore = review.MainScore;
                p.PerformanceTrack = review.Track;
                p.PerformancePeriodFa = review.PeriodFa + " (" + EvaluationScoring.SeasonFa(review.Season) + ")";
                p.PerformanceYear = review.Year;
                p.PerformanceSeason = review.Season;
            }
        }

        List<WorkerProjectRow> LoadProjects(string reviewId)
        {
            var list = new List<WorkerProjectRow>();
            if (string.IsNullOrEmpty(reviewId))
                return list;
            using (var r = _db.Query(
                "SELECT * FROM employee_worker_projects WHERE review_id=@id ORDER BY sort_order, title",
                Sql.P("@id", reviewId)))
            {
                while (r.Read())
                {
                    list.Add(new WorkerProjectRow
                    {
                        Id = Sql.Str(r["id"]),
                        ReviewId = Sql.Str(r["review_id"]),
                        Title = Sql.Str(r["title"]),
                        Level = Sql.Int(r["level"]),
                        Hours = Sql.Dbl(r["hours"]),
                        ProgressPercent = Sql.Dbl(r["progress_percent"]),
                        ChecklistCount = Sql.Int(r["checklist_count"]),
                        IncidentsDirect = Sql.Int(r["incidents_direct"]),
                        IncidentsIndirect = Sql.Int(r["incidents_indirect"]),
                        SevereIncident = Sql.Int(r["severe"]) == 1,
                        SortOrder = Sql.Int(r["sort_order"])
                    });
                }
            }
            return list;
        }

        void SaveProjects(PerformanceReview review)
        {
            _db.Execute("DELETE FROM employee_worker_projects WHERE review_id=@id", Sql.P("@id", review.Id));
            if (review.Track != PerformanceTracks.Worker || review.Projects == null)
                return;
            var order = 0;
            foreach (var p in review.Projects)
            {
                if (p == null || string.IsNullOrWhiteSpace(p.Title))
                    continue;
                if (string.IsNullOrEmpty(p.Id))
                    p.Id = Sql.NewId();
                p.ReviewId = review.Id;
                p.SortOrder = order++;
                _db.Execute(@"INSERT INTO employee_worker_projects
                  (id, review_id, title, level, hours, progress_percent, checklist_count,
                   incidents_direct, incidents_indirect, severe, sort_order)
                  VALUES (@id,@rid,@t,@lv,@h,@pr,@ck,@idc,@iin,@sv,@so)",
                    Sql.P("@id", p.Id), Sql.P("@rid", review.Id), Sql.P("@t", p.Title.Trim()),
                    Sql.P("@lv", Math.Max(1, Math.Min(10, p.Level))),
                    Sql.P("@h", Math.Max(0, p.Hours)),
                    Sql.P("@pr", Math.Max(0, Math.Min(100, p.ProgressPercent))),
                    Sql.P("@ck", Math.Max(0, p.ChecklistCount)),
                    Sql.P("@idc", Math.Max(0, p.IncidentsDirect)),
                    Sql.P("@iin", Math.Max(0, p.IncidentsIndirect)),
                    Sql.P("@sv", p.SevereIncident ? 1 : 0),
                    Sql.P("@so", p.SortOrder));
            }
        }

        void SyncLegacySummary(PerformanceReview review)
        {
            if (review.Status != PerformanceStatuses.Approved || review.MainScore == null)
                return;
            var now = Sql.Now();
            _db.Execute("DELETE FROM employee_evaluations WHERE employee_id=@id", Sql.P("@id", review.EmployeeId));
            var trackFa = PerformanceTracks.Fa(review.Track);
            var strengths = "مسیر " + trackFa + " — نمره " + review.MainScore.Value.ToString("0.#", CultureInfo.InvariantCulture)
                + " — " + PerformanceLights.Fa(review.LightCode);
            if (review.Exemplary)
                strengths += " — واجد عنوان نمونه";
            _db.Execute(@"INSERT INTO employee_evaluations
              (id, employee_id, year, score, evaluator, evaluation_date, strengths, weaknesses, created_at)
              VALUES (@id,@eid,@y,@sc,@ev,@ed,@st,@wk,@now)",
                Sql.P("@id", Sql.NewId()), Sql.P("@eid", review.EmployeeId), Sql.P("@y", review.Year),
                Sql.P("@sc", review.MainScore.Value),
                Sql.P("@ev", review.EvaluatorName),
                Sql.P("@ed", PersianDate.Today()),
                Sql.P("@st", strengths),
                Sql.P("@wk", review.Notes),
                Sql.P("@now", now));
        }

        static System.Data.SQLite.SQLiteParameter[] Params(PerformanceReview review, long now)
        {
            return new[]
            {
                Sql.P("@id", review.Id),
                Sql.P("@eid", review.EmployeeId),
                Sql.P("@y", review.Year),
                Sql.P("@s", review.Season),
                Sql.P("@t", review.Track),
                Sql.P("@st", review.Status),
                Sql.P("@en", review.EvaluatorName),
                Sql.P("@eu", review.EvaluatorUserId),
                Sql.P("@notes", review.Notes),
                Sql.P("@ci", review.CheckIn),
                Sql.P("@co", review.CheckOut),
                Sql.P("@ph", review.PresenceHours),
                Sql.P("@dh", review.DutyHours),
                Sql.P("@wc", review.WorksheetCount),
                Sql.P("@wq", review.WorksheetQuota),
                Sql.P("@cf", review.ComplaintsFiled),
                Sql.P("@cv", review.ComplaintsValid),
                Sql.P("@ca", review.ComplaintsAnswered),
                Sql.P("@rq", EvaluationScoring.ClampScale(review.ResponseQuality)),
                Sql.P("@sp", EvaluationScoring.ClampScale(review.SocialParticipation)),
                Sql.P("@ee", EvaluationScoring.ClampScale(review.ExtraEffort)),
                Sql.P("@eh", EvaluationScoring.ClampScale(review.ExtraHumanCapital)),
                Sql.P("@eo", EvaluationScoring.ClampScale(review.ExtraOrgRelations)),
                Sql.P("@ec", EvaluationScoring.ClampScale(review.ExtraClub)),
                Sql.P("@ev", review.ExtraEvidence),
                Sql.P("@xp", Math.Max(0, review.ExpectedProjects)),
                Sql.P("@xv", Math.Max(0, review.ExpectedVolume)),
                Sql.P("@xc", Math.Max(0, review.ExpectedChecklists)),
                Sql.P("@ms", review.MainScore),
                Sql.P("@xs", review.ExtraScore),
                Sql.P("@lc", review.LightCode),
                Sql.P("@sf", review.SafetyRedFlag ? 1 : 0),
                Sql.P("@ex", review.Exemplary ? 1 : 0),
                Sql.P("@ob", review.ExtraOrgBadge ? 1 : 0),
                Sql.P("@aa", review.ApprovedAt),
                Sql.P("@created", review.CreatedAt),
                Sql.P("@now", now)
            };
        }

        static PerformanceReview Map(System.Data.SQLite.SQLiteDataReader r)
        {
            return new PerformanceReview
            {
                Id = Sql.Str(r["id"]),
                EmployeeId = Sql.Str(r["employee_id"]),
                Year = Sql.Int(r["year"]),
                Season = Sql.Int(r["season"]),
                Track = Sql.Str(r["track"]) ?? PerformanceTracks.Staff,
                Status = Sql.Str(r["status"]) ?? PerformanceStatuses.Draft,
                EvaluatorName = Sql.Str(r["evaluator_name"]),
                EvaluatorUserId = Sql.Str(r["evaluator_user_id"]),
                Notes = Sql.Str(r["notes"]),
                CheckIn = Sql.Str(r["check_in"]),
                CheckOut = Sql.Str(r["check_out"]),
                PresenceHours = Sql.DblN(r["presence_hours"]),
                DutyHours = Sql.DblN(r["duty_hours"]),
                WorksheetCount = Sql.Int(r["worksheet_count"]),
                WorksheetQuota = Sql.Int(r["worksheet_quota"]),
                ComplaintsFiled = Sql.Int(r["complaints_filed"]),
                ComplaintsValid = Sql.Int(r["complaints_valid"]),
                ComplaintsAnswered = Sql.Int(r["complaints_answered"]),
                ResponseQuality = Sql.Int(r["response_quality"], 5),
                SocialParticipation = Sql.Int(r["social_participation"], 3),
                ExtraEffort = Sql.Int(r["extra_effort"], 3),
                ExtraHumanCapital = Sql.Int(r["extra_human_capital"], 3),
                ExtraOrgRelations = Sql.Int(r["extra_org_relations"], 3),
                ExtraClub = Sql.Int(r["extra_club"], 3),
                ExtraEvidence = Sql.Str(r["extra_evidence"]),
                ExpectedProjects = Sql.Int(r["expected_projects"]),
                ExpectedVolume = Sql.Dbl(r["expected_volume"]),
                ExpectedChecklists = Sql.Int(r["expected_checklists"]),
                MainScore = Sql.DblN(r["main_score"]),
                ExtraScore = Sql.DblN(r["extra_score"]),
                LightCode = Sql.Str(r["light_code"]) ?? PerformanceLights.Gray,
                SafetyRedFlag = Sql.Int(r["safety_red_flag"]) == 1,
                Exemplary = Sql.Int(r["exemplary"]) == 1,
                ExtraOrgBadge = Sql.Int(r["extra_org_badge"]) == 1,
                ApprovedAt = Sql.LongN(r["approved_at"]),
                CreatedAt = Sql.Long(r["created_at"]),
                UpdatedAt = Sql.Long(r["updated_at"])
            };
        }
    }
}
