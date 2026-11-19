using System;
using System.Collections.Generic;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Core
{
    /// <summary>
    /// امتیازدهی عادلانه ارزیابی عملکرد.
    /// چراغ فقط برای برگه تأییدشده؛ داده ناقص صفر محسوب نمی‌شود؛ مسیر ستادی و اجرایی جداست.
    /// </summary>
    public static class EvaluationScoring
    {
        public const double ExtraOrgBadgeThreshold = 80.0;
        public const double ExemplaryThreshold = 80.0;

        public static int CurrentSeason()
        {
            var month = new System.Globalization.PersianCalendar().GetMonth(DateTime.Now);
            return ((month - 1) / 3) + 1;
        }

        public static string SeasonFa(int season)
        {
            switch (season)
            {
                case 1: return "بهار";
                case 2: return "تابستان";
                case 3: return "پاییز";
                case 4: return "زمستان";
                default: return "فصل " + season;
            }
        }

        /// <summary>محاسبه مدت حضور از ورود/خروج (ساعت). شیفت شب پشتیبانی می‌شود.</summary>
        public static double? PresenceFromTimes(string checkIn, string checkOut)
        {
            TimeSpan a, b;
            if (!TryParseTime(checkIn, out a) || !TryParseTime(checkOut, out b))
                return null;
            var minutes = b.TotalMinutes - a.TotalMinutes;
            if (minutes < 0)
                minutes += 24 * 60;
            return Math.Round(minutes / 60.0, 2);
        }

        public static bool TryParseTime(string text, out TimeSpan time)
        {
            time = TimeSpan.Zero;
            if (string.IsNullOrWhiteSpace(text))
                return false;
            var t = text.Trim().Replace('.', ':');
            var parts = t.Split(':');
            if (parts.Length < 2)
                return false;
            int h, m;
            if (!int.TryParse(parts[0], out h) || !int.TryParse(parts[1], out m))
                return false;
            if (h < 0 || h > 23 || m < 0 || m > 59)
                return false;
            time = new TimeSpan(h, m, 0);
            return true;
        }

        public static int ClampScale(int value, int min = 1, int max = 5)
        {
            if (value < min) return min;
            if (value > max) return max;
            return value;
        }

        public static double ScaleToHundred(int value1to5)
        {
            return (ClampScale(value1to5) - 1) / 4.0 * 100.0;
        }

        public static PerformanceScoreBreakdown Compute(PerformanceReview review)
        {
            var result = new PerformanceScoreBreakdown
            {
                LightCode = PerformanceLights.Gray,
                IsComplete = false
            };
            if (review == null)
            {
                result.Message = "برگه ارزیابی خالی است.";
                return result;
            }

            if (review.Track == PerformanceTracks.Worker)
                ScoreWorker(review, result);
            else
                ScoreStaff(review, result);

            result.ExtraScore = ScoreExtraOrg(review);
            result.ExtraOrgBadge = result.ExtraScore != null && result.ExtraScore.Value >= ExtraOrgBadgeThreshold
                && !string.IsNullOrWhiteSpace(review.ExtraEvidence);

            var approved = review.Status == PerformanceStatuses.Approved;
            result.LightCode = PerformanceLights.FromScore(result.MainScore, approved, result.SafetyRedFlag);
            result.Exemplary = approved
                && result.MainScore != null
                && result.MainScore.Value >= ExemplaryThreshold
                && !result.SafetyRedFlag
                && result.LightCode == PerformanceLights.Green;

            if (!approved)
                result.Message = (result.Message ?? "") + " پس از تأیید نهایی، نشان وضعیت روی کارت پرسنل دیده می‌شود.";

            return result;
        }

        public static void Apply(PerformanceReview review)
        {
            var b = Compute(review);
            review.MainScore = b.MainScore;
            review.ExtraScore = b.ExtraScore;
            review.LightCode = b.LightCode;
            review.SafetyRedFlag = b.SafetyRedFlag;
            review.Exemplary = b.Exemplary;
            review.ExtraOrgBadge = b.ExtraOrgBadge;
        }

        static void ScoreStaff(PerformanceReview review, PerformanceScoreBreakdown result)
        {
            var attendance = ScoreAttendance(review.PresenceHours, review.DutyHours);
            var worksheets = ScoreQuota(review.WorksheetCount, review.WorksheetQuota);
            var complaints = ScoreComplaints(review);
            var social = ScaleToHundred(review.SocialParticipation);

            result.Attendance = attendance;
            result.Worksheets = worksheets;
            result.Complaints = complaints;
            result.Social = social;

            if (attendance == null)
            {
                result.Message = "برای مسیر ستادی، مدت حضور و ساعت موظف دوره لازم است.";
                return;
            }
            if (worksheets == null)
            {
                result.Message = "سهمیه کاربرگ‌های مورد انتظار واحد را وارد کنید.";
                return;
            }

            // حضور ۳۰ + کاربرگ ۳۰ + شکایات ۲۵ + مشارکت ۱۵
            result.MainScore = Round(
                attendance.Value * 0.30
                + worksheets.Value * 0.30
                + complaints * 0.25
                + social * 0.15);
            result.IsComplete = true;
            result.Message = "نمره ستادی محاسبه شد.";
        }

        static void ScoreWorker(PerformanceReview review, PerformanceScoreBreakdown result)
        {
            var projects = review.Projects ?? new List<WorkerProjectRow>();
            double volume = 0;
            int checklists = 0;
            int present = 0;
            int direct = 0;
            int indirect = 0;
            var severe = false;
            foreach (var p in projects)
            {
                if (p == null)
                    continue;
                present++;
                volume += p.WeightedVolume;
                checklists += Math.Max(0, p.ChecklistCount);
                direct += Math.Max(0, p.IncidentsDirect);
                indirect += Math.Max(0, p.IncidentsIndirect);
                if (p.SevereIncident)
                    severe = true;
            }

            result.SafetyRedFlag = severe;
            result.Volume = ScoreQuotaDouble(volume, review.ExpectedVolume);
            result.Coverage = ScoreQuota(present, review.ExpectedProjects);
            result.Checklists = ScoreQuota(checklists, review.ExpectedChecklists);
            result.Safety = ScoreSafety(direct, indirect, severe);

            if (result.Volume == null)
            {
                result.Message = "حجم کار مورد انتظار دوره (سطح×ساعت×پیشرفت) را وارد کنید تا مقایسه عادلانه باشد.";
                return;
            }
            if (result.Coverage == null)
            {
                result.Message = "تعداد پروژه‌های ارجاع‌شده به این فرد را وارد کنید.";
                return;
            }
            if (result.Checklists == null)
            {
                result.Message = "سهمیه چک‌لیست مورد انتظار را وارد کنید.";
                return;
            }

            // حجم ۴۰ + پوشش ۱۵ + چک‌لیست ۱۵ + ایمنی ۳۰
            var main = result.Volume.Value * 0.40
                + result.Coverage.Value * 0.15
                + result.Checklists.Value * 0.15
                + result.Safety.Value * 0.30;
            if (severe)
                main = Math.Min(main, 64.9);
            result.MainScore = Round(main);
            result.IsComplete = true;
            result.Message = severe
                ? "خط قرمز ایمنی: در این دوره واجد عنوان کارمند صف نمونه نیست."
                : "نمره اجرایی محاسبه شد.";
        }

        static double? ScoreAttendance(double? presence, double? duty)
        {
            if (presence == null || duty == null || duty.Value <= 0)
                return null;
            var ratio = presence.Value / duty.Value;
            if (ratio < 0) ratio = 0;
            if (ratio > 1) ratio = 1; // سقف ۱۰۰ — اضافه‌کاری نمونه نمی‌سازد
            return Round(ratio * 100.0);
        }

        static double? ScoreQuota(int actual, int quota)
        {
            if (quota <= 0)
                return null;
            var ratio = actual / (double)quota;
            if (ratio < 0) ratio = 0;
            if (ratio > 1) ratio = 1;
            return Round(ratio * 100.0);
        }

        static double? ScoreQuotaDouble(double actual, double quota)
        {
            if (quota <= 0)
                return null;
            var ratio = actual / quota;
            if (ratio < 0) ratio = 0;
            if (ratio > 1) ratio = 1;
            return Round(ratio * 100.0);
        }

        static double ScoreComplaints(PerformanceReview review)
        {
            // بدون شکایت وارد = نمره کامل پاسخ‌دهی (نه داده خالی)
            var filed = Math.Max(0, review.ComplaintsFiled);
            var valid = Math.Max(0, review.ComplaintsValid);
            var answered = Math.Max(0, review.ComplaintsAnswered);
            if (valid > filed)
                valid = filed;
            if (answered > filed)
                answered = filed;

            double responseScore;
            if (filed == 0)
                responseScore = 100.0;
            else
                responseScore = (answered / (double)filed) * 100.0;

            var quality = ScaleToHundred(review.ResponseQuality);
            // ۷۰٪ پاسخ به‌موقع + ۳۰٪ کیفیت
            var baseScore = responseScore * 0.70 + quality * 0.30;

            // فقط شکایت وارد جریمه دارد (حداکثر ۲۰ نمره)
            if (valid > 0)
            {
                var penalty = Math.Min(20.0, valid * 5.0);
                baseScore = Math.Max(0, baseScore - penalty);
            }
            return Round(baseScore);
        }

        static double ScoreSafety(int direct, int indirect, bool severe)
        {
            if (severe)
                return 0;
            var score = 100.0;
            score -= Math.Max(0, direct) * 20.0;
            score -= Math.Max(0, indirect) * 10.0;
            if (score < 0) score = 0;
            return Round(score);
        }

        static double? ScoreExtraOrg(PerformanceReview review)
        {
            // بدون شواهد، نشان فراسازمانی و نمره کامل لحاظ نمی‌شود برای badge؛ نمره خام محاسبه می‌شود
            var a = ScaleToHundred(review.ExtraEffort);
            var b = ScaleToHundred(review.ExtraHumanCapital);
            var c = ScaleToHundred(review.ExtraOrgRelations);
            var d = ScaleToHundred(review.ExtraClub);
            return Round((a + b + c + d) / 4.0);
        }

        static double Round(double v)
        {
            return Math.Round(v, 1, MidpointRounding.AwayFromZero);
        }
    }
}
