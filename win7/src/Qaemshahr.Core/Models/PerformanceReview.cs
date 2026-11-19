using System;
using System.Collections.Generic;
using System.Globalization;

namespace Qaemshahr.Core.Models
{
    public static class PerformanceTracks
    {
        public const string Staff = "staff";
        public const string Worker = "worker";

        public static string Fa(string track)
        {
            if (track == Worker)
                return "کارمند صف (اجرایی)";
            return "کارمند (ستادی)";
        }
    }

    public static class PerformanceStatuses
    {
        public const string Draft = "draft";
        public const string Approved = "approved";

        public static string Fa(string status)
        {
            if (status == Approved)
                return "تأییدشده";
            return "پیش‌نویس";
        }
    }

    public static class PerformanceLights
    {
        public const string Gray = "gray";
        public const string Red = "red";
        public const string Orange = "orange";
        public const string Yellow = "yellow";
        public const string Green = "green";

        public static string FromScore(double? score, bool approved, bool safetyRedFlag)
        {
            if (!approved || score == null)
                return Gray;
            var s = score.Value;
            if (safetyRedFlag && s >= 65)
                return Orange;
            if (s < 50)
                return Red;
            if (s < 65)
                return Orange;
            if (s < 80)
                return Yellow;
            return Green;
        }

        public static string Fa(string light)
        {
            switch (light)
            {
                case Red: return "نیازمند اقدام";
                case Orange: return "ضعیف تا متوسط";
                case Yellow: return "قابل قبول";
                case Green: return "شایسته تقدیر";
                default: return "ارزیابی نشده";
            }
        }

        public static void Rgb(string light, out byte r, out byte g, out byte b)
        {
            switch (light)
            {
                case Red:
                    r = 0xC6; g = 0x28; b = 0x28;
                    return;
                case Orange:
                    r = 0xEF; g = 0x6C; b = 0x00;
                    return;
                case Yellow:
                    r = 0xF9; g = 0xA8; b = 0x25;
                    return;
                case Green:
                    r = 0x2E; g = 0x7D; b = 0x32;
                    return;
                default:
                    r = 0x90; g = 0xA4; b = 0xAE;
                    return;
            }
        }
    }

    public sealed class WorkerProjectRow
    {
        public string Id { get; set; }
        public string ReviewId { get; set; }
        public string Title { get; set; }
        public int Level { get; set; }
        public double Hours { get; set; }
        public double ProgressPercent { get; set; }
        public int ChecklistCount { get; set; }
        public int IncidentsDirect { get; set; }
        public int IncidentsIndirect { get; set; }
        public bool SevereIncident { get; set; }
        public int SortOrder { get; set; }

        public double WeightedVolume
        {
            get
            {
                var level = Math.Max(1, Math.Min(10, Level));
                var hours = Math.Max(0, Hours);
                var progress = Math.Max(0, Math.Min(100, ProgressPercent)) / 100.0;
                return (level / 10.0) * hours * progress;
            }
        }

        public string DisplayLine
        {
            get
            {
                return string.Format(CultureInfo.InvariantCulture,
                    "{0}  ·  سطح {1}  ·  {2:0.#}س  ·  پیشرفت {3:0}%  ·  چک‌لیست {4}",
                    string.IsNullOrWhiteSpace(Title) ? "بدون عنوان" : Title.Trim(),
                    Level, Hours, ProgressPercent, ChecklistCount);
            }
        }
    }

    public sealed class PerformanceReview
    {
        public string Id { get; set; }
        public string EmployeeId { get; set; }
        public int Year { get; set; }
        public int Season { get; set; }
        public string Track { get; set; }
        public string Status { get; set; }
        public string EvaluatorName { get; set; }
        public string EvaluatorUserId { get; set; }
        public string Notes { get; set; }

        public string CheckIn { get; set; }
        public string CheckOut { get; set; }
        public double? PresenceHours { get; set; }
        public double? DutyHours { get; set; }

        public int WorksheetCount { get; set; }
        public int WorksheetQuota { get; set; }

        public int ComplaintsFiled { get; set; }
        public int ComplaintsValid { get; set; }
        public int ComplaintsAnswered { get; set; }
        public int ResponseQuality { get; set; }
        public int SocialParticipation { get; set; }

        public int ExtraEffort { get; set; }
        public int ExtraHumanCapital { get; set; }
        public int ExtraOrgRelations { get; set; }
        public int ExtraClub { get; set; }
        public string ExtraEvidence { get; set; }

        public int ExpectedProjects { get; set; }
        public double ExpectedVolume { get; set; }
        public int ExpectedChecklists { get; set; }

        public double? MainScore { get; set; }
        public double? ExtraScore { get; set; }
        public string LightCode { get; set; }
        public bool SafetyRedFlag { get; set; }
        public bool Exemplary { get; set; }
        public bool ExtraOrgBadge { get; set; }

        public long? ApprovedAt { get; set; }
        public long CreatedAt { get; set; }
        public long UpdatedAt { get; set; }

        public List<WorkerProjectRow> Projects { get; set; }

        public PerformanceReview()
        {
            Track = PerformanceTracks.Staff;
            Status = PerformanceStatuses.Draft;
            ResponseQuality = 5;
            SocialParticipation = 3;
            ExtraEffort = 3;
            ExtraHumanCapital = 3;
            ExtraOrgRelations = 3;
            ExtraClub = 3;
            LightCode = PerformanceLights.Gray;
            Projects = new List<WorkerProjectRow>();
        }

        public string PeriodFa
        {
            get { return "سال " + Year + " — فصل " + Season; }
        }
    }

    public sealed class PerformanceScoreBreakdown
    {
        public double? Attendance { get; set; }
        public double? Worksheets { get; set; }
        public double? Complaints { get; set; }
        public double? Social { get; set; }
        public double? Volume { get; set; }
        public double? Coverage { get; set; }
        public double? Checklists { get; set; }
        public double? Safety { get; set; }
        public double? MainScore { get; set; }
        public double? ExtraScore { get; set; }
        public bool SafetyRedFlag { get; set; }
        public bool Exemplary { get; set; }
        public bool ExtraOrgBadge { get; set; }
        public string LightCode { get; set; }
        public string Message { get; set; }
        public bool IsComplete { get; set; }
    }
}
