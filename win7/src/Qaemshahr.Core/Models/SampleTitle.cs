using System;
using System.Collections.Generic;

namespace Qaemshahr.Core.Models
{
    public static class SampleTitleKinds
    {
        public const string StaffSample = "staff_sample";
        public const string WorkerSample = "worker_sample";

        public static string Normalize(string kind)
        {
            if (string.IsNullOrWhiteSpace(kind))
                return StaffSample;
            switch (kind.Trim())
            {
                case WorkerSample:
                case "worker":
                case "کارگر نمونه":
                case "کارگر":
                    return WorkerSample;
                default:
                    return StaffSample;
            }
        }

        public static string Fa(string kind)
        {
            return Normalize(kind) == WorkerSample ? "کارگر نمونه" : "کارمند نمونه";
        }

        public static bool IsSampleKind(string kind)
        {
            var k = (kind ?? "").Trim();
            return string.Equals(k, StaffSample, StringComparison.Ordinal)
                || string.Equals(k, WorkerSample, StringComparison.Ordinal)
                || string.Equals(k, "کارمند نمونه", StringComparison.Ordinal)
                || string.Equals(k, "کارگر نمونه", StringComparison.Ordinal);
        }
    }

    public sealed class SampleIntroduction
    {
        public string Id { get; set; }
        public string SampleTitleId { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int Year { get; set; }
        public string SampleKind { get; set; }
        public string Organization { get; set; }
        public string Note { get; set; }
        public long CreatedAt { get; set; }
        public string CreatedBy { get; set; }

        public string SampleKindFa
        {
            get { return SampleTitleKinds.Fa(SampleKind); }
        }

        public string SummaryFa
        {
            get
            {
                var org = string.IsNullOrWhiteSpace(Organization) ? "سازمان نامشخص" : Organization.Trim();
                return "معرفی به " + org;
            }
        }
    }

    public sealed class SampleReport
    {
        public string Id { get; set; }
        public string SampleTitleId { get; set; }
        public string Body { get; set; }
        public long CreatedAt { get; set; }
        public string CreatedBy { get; set; }

        public string CreatedAtFa
        {
            get { return PersianDate.DigitsFa(PersianDate.FromEpochMsDateTime(CreatedAt)); }
        }
    }

    public sealed class SampleTitle
    {
        public string Id { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string NationalId { get; set; }
        public string Position { get; set; }
        public string PhotoPath { get; set; }
        public string Gender { get; set; }
        public string PersonType { get; set; }
        public int Year { get; set; }
        public string Kind { get; set; }
        public string Note { get; set; }
        public long CreatedAt { get; set; }
        public long UpdatedAt { get; set; }
        public string CreatedBy { get; set; }
        public List<SampleIntroduction> Introductions { get; set; }
        public List<SampleReport> Reports { get; set; }

        public string KindFa
        {
            get { return SampleTitleKinds.Fa(Kind); }
        }

        public bool HasIntroduction
        {
            get { return Introductions != null && Introductions.Count > 0; }
        }

        public int ReportCount
        {
            get { return Reports == null ? 0 : Reports.Count; }
        }

        public SampleTitle()
        {
            Introductions = new List<SampleIntroduction>();
            Reports = new List<SampleReport>();
        }
    }
}
