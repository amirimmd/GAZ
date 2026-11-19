using System.Collections.Generic;
using Qaemshahr.Core;

namespace Qaemshahr.Core.Models
{
    public sealed class Employee
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FatherName { get; set; }
        public string NationalId { get; set; }
        /// <summary>شماره شناسنامه.</summary>
        public string IdBookletNumber { get; set; }
        public string BirthDate { get; set; }
        public string BirthPlace { get; set; }
        /// <summary>شهر محل خدمت.</summary>
        public string ServiceCity { get; set; }
        /// <summary>وضعیت ایثارگری.</summary>
        public string VeteranStatus { get; set; }
        /// <summary>شماره شبا ۱ (IR...).</summary>
        public string Iban1 { get; set; }
        /// <summary>شماره شبا ۲ (IR...).</summary>
        public string Iban2 { get; set; }
        public string Gender { get; set; }
        public string MaritalStatus { get; set; }
        public int ChildrenCount { get; set; }
        public string BloodGroup { get; set; }
        public string MilitaryStatus { get; set; }
        public string PersonalDescription { get; set; }
        public string PhotoPath { get; set; }
        public string EmployeeNumber { get; set; }
        public string SubscriptionNumber { get; set; }
        public string DepartmentId { get; set; }
        public string UnitId { get; set; }
        public string CurrentPosition { get; set; }
        public string PreviousPosition { get; set; }
        public string DesiredPosition { get; set; }
        public string EmploymentType { get; set; }
        public string EmploymentDate { get; set; }
        public string SupervisorId { get; set; }
        public string EmploymentStatus { get; set; }
        /// <summary>کارمند یا کارگر (staff / worker).</summary>
        public string PersonType { get; set; }
        /// <summary>تاریخ بازنشستگی شمسی؛ پس از آن نیرو غیرفعال می‌شود.</summary>
        public string RetirementDate { get; set; }
        /// <summary>دلیل غیرفعال بودن (برای غیر از بازنشستگی الزامی است).</summary>
        public string InactiveReason { get; set; }
        /// <summary>فقط برای ارکان ثالث — گروه شغلی.</summary>
        public string JobGroup { get; set; }
        /// <summary>پایه شماره سمت (سقف پایه شخصی).</summary>
        public double? PositionBase { get; set; }
        /// <summary>پایه شخصی؛ نباید از پایه سمت بیشتر شود.</summary>
        public double? PersonalBase { get; set; }

        public string PrimaryPhone { get; set; }
        public string SecondaryPhone { get; set; }
        public string EmergencyPhone { get; set; }
        public string Email { get; set; }
        public string HomeAddress { get; set; }
        public string PostalCode { get; set; }
        public string Telegram { get; set; }
        public string Whatsapp { get; set; }
        public string Instagram { get; set; }
        public string Linkedin { get; set; }

        public string EducationLevel { get; set; }
        public string Major { get; set; }
        public string University { get; set; }
        public string SkillName { get; set; }
        public string SkillLevel { get; set; }
        public string InsuranceNumber { get; set; }
        public string InsuranceType { get; set; }
        public string EvaluationScore { get; set; }
        public string Evaluator { get; set; }
        public string Strengths { get; set; }
        public string Weaknesses { get; set; }
        public List<EmployeeDocument> Documents { get; set; }

        /// <summary>آخرین ارزیابی تأییدشده برای چراغ کارت.</summary>
        public string PerformanceLight { get; set; }
        public double? PerformanceScore { get; set; }
        public string PerformanceTrack { get; set; }
        public bool ExtraOrgBadge { get; set; }
        /// <summary>سازمان‌هایی که در سال جاری به‌عنوان نمونه به آن‌ها معرفی شده.</summary>
        public List<string> IntroducedOrganizations { get; set; }
        public bool PerformanceExemplary { get; set; }
        /// <summary>نوع عنوان نمونه از رجیستری سالانه (staff_sample / worker_sample).</summary>
        public string SampleKind { get; set; }
        public int SampleYear { get; set; }
        /// <summary>سوابق عنوان نمونه/فراسازمانی در سال‌های مختلف برای جزئیات کارت.</summary>
        public List<string> SampleHistory { get; set; }
        public string PerformancePeriodFa { get; set; }
        public int PerformanceYear { get; set; }
        public int PerformanceSeason { get; set; }
        public long CreatedAt { get; set; }

        public string FullName
        {
            get { return (FirstName + " " + LastName).Trim(); }
        }

        public string Initials
        {
            get
            {
                var a = string.IsNullOrEmpty(FirstName) ? "" : FirstName.Substring(0, 1);
                var b = string.IsNullOrEmpty(LastName) ? "" : LastName.Substring(0, 1);
                return (a + b).Trim();
            }
        }

        public string StatusFa
        {
            get { return EmploymentStatus == "inactive" ? "غیرفعال" : "فعال"; }
        }

        public bool IsRetired
        {
            get { return PersianDate.IsOnOrBeforeToday(RetirementDate); }
        }

        public string InactiveReasonFa
        {
            get
            {
                if (EmploymentStatus != "inactive")
                    return null;
                if (!string.IsNullOrWhiteSpace(InactiveReason))
                    return InactiveReason.Trim();
                return IsRetired ? HrLookups.InactiveReasonRetirement : null;
            }
        }

        public string PersonTypeFa
        {
            get { return HrLookups.PersonTypeFa(PersonType); }
        }

        public string Haystack
        {
            get
            {
                return string.Join(" ", new[]
                {
                    FullName, NationalId, EmployeeNumber, CurrentPosition,
                    PrimaryPhone, Email, FatherName, BirthPlace, IdBookletNumber, ServiceCity,
                    VeteranStatus, Iban1, Iban2, Telegram, PersonTypeFa
                }).ToLowerInvariant();
            }
        }
    }

    public sealed class EmployeeGroup
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string PurposeType { get; set; }
        public string Status { get; set; }
        public string PhotoPath { get; set; }
        public long? StartsAt { get; set; }
        public long? EndsAt { get; set; }
        public string CreatedBy { get; set; }
        public int MemberCount { get; set; }
        public List<string> MemberIds { get; set; }

        public EmployeeGroup()
        {
            MemberIds = new List<string>();
            PurposeType = "other";
            Status = "active";
        }

        public string PurposeFa
        {
            get
            {
                switch (PurposeType)
                {
                    case "mission": return "مأموریت";
                    case "training": return "آموزش";
                    case "committee": return "کمیته";
                    case "project": return "پروژه";
                    case "other": return "سایر";
                    default:
                        return string.IsNullOrWhiteSpace(PurposeType) ? "سایر" : PurposeType.Trim();
                }
            }
        }

        public string StatusFa
        {
            get { return Status == "archived" ? "بایگانی" : "فعال"; }
        }

        public string StartsFa
        {
            get { return PersianDate.FromEpochMs(StartsAt); }
        }

        public string EndsFa
        {
            get { return PersianDate.FromEpochMs(EndsAt); }
        }
    }

    public sealed class GroupActivity
    {
        public string Id { get; set; }
        public string GroupId { get; set; }
        public string Title { get; set; }
        public string Note { get; set; }
        public string ActivityDate { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedByName { get; set; }
        public long CreatedAt { get; set; }

        public string ActivityDateFa
        {
            get
            {
                if (!string.IsNullOrWhiteSpace(ActivityDate))
                    return PersianDate.DigitsFa(PersianDate.Normalize(ActivityDate) ?? ActivityDate.Trim());
                return PersianDate.FromEpochMs(CreatedAt);
            }
        }

        public string CreatedAtFa
        {
            get { return PersianDate.FromEpochMsDateTime(CreatedAt); }
        }

        public string SummaryLine
        {
            get
            {
                var t = string.IsNullOrWhiteSpace(Title) ? "فعالیت" : Title.Trim();
                var who = string.IsNullOrWhiteSpace(CreatedByName) ? "" : " — " + CreatedByName.Trim();
                return ActivityDateFa + " · " + t + who;
            }
        }
    }

    public sealed class EmployeeDocument
    {
        public string Id { get; set; }
        public string EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string NationalId { get; set; }
        public string Title { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string FileName { get; set; }
        public string MimeType { get; set; }
        public long FileSize { get; set; }
        public string StoragePath { get; set; }
        public string ContentHash { get; set; }
        public long UploadedAt { get; set; }
        public string UploadedBy { get; set; }
        public byte[] PreviewBytes { get; set; }

        public string DisplayName
        {
            get
            {
                if (!string.IsNullOrWhiteSpace(Title))
                    return Title.Trim();
                return string.IsNullOrWhiteSpace(FileName) ? string.Empty : FileName;
            }
        }
    }

    public sealed class UserSummary
    {
        public string Id { get; set; }
        public string Username { get; set; }
        public string DisplayName { get; set; }
        public bool IsActive { get; set; }
        public string RoleCode { get; set; }
        public string RoleNameFa { get; set; }
        public bool MustChangePassword { get; set; }
    }

    public sealed class AuditRow
    {
        public string Id { get; set; }
        public string ActorUsername { get; set; }
        public string Action { get; set; }
        public string EntityType { get; set; }
        public string EntityId { get; set; }
        public string Details { get; set; }
        public long CreatedAt { get; set; }

        public string CreatedFa
        {
            get { return PersianDate.FromEpochMs(CreatedAt); }
        }

        public string CreatedTimeFa
        {
            get { return PersianDate.FromEpochMsTime(CreatedAt); }
        }

        public string CreatedDateTimeFa
        {
            get { return PersianDate.DigitsFa(PersianDate.FromEpochMsDateTime(CreatedAt)); }
        }

        public string ActionFa
        {
            get { return AuditLabels.ActionFa(Action); }
        }

        public string EntityTypeFa
        {
            get { return AuditLabels.EntityFa(EntityType); }
        }

        public string DetailsFa
        {
            get { return AuditLabels.DetailsFa(Details, EntityId); }
        }
    }

    public sealed class ReportColumn
    {
        public string Key { get; set; }
        public string TitleFa { get; set; }
        public string Group { get; set; }
        public bool Selected { get; set; }
    }
}
