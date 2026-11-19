using System;

namespace Qaemshahr.Core.Models
{
    public sealed class ReportExportOptions
    {
        public string Title { get; set; }
        public string HeaderText { get; set; }
        public string FooterText { get; set; }
        public string Watermark { get; set; }
        public string WatermarkMode { get; set; }
        public bool ShowLogo { get; set; }
        public bool ShowPageNumbers { get; set; }
        public bool ShowPhotos { get; set; }
        public bool ShowDocuments { get; set; }
        public string Orientation { get; set; }
        public string GeneratedBy { get; set; }

        /// <summary>تاریخ شمسی گزارش (yyyy/MM/dd). خالی = امروز.</summary>
        public string ReportDate { get; set; }

        /// <summary>محل امضا در انتهای خروجی.</summary>
        public bool ShowSignature { get; set; }

        /// <summary>عنوان دستی زیر محل امضا.</summary>
        public string SignatureTitle { get; set; }

        public static ReportExportOptions CreateDefault()
        {
            return new ReportExportOptions
            {
                Title = "گزارش کارکنان",
                HeaderText = AppConstants.OrganizationNameFa,
                FooterText = AppConstants.AppNameFa,
                Watermark = AppConstants.AppNameFa,
                WatermarkMode = "none",
                ShowLogo = true,
                ShowPageNumbers = true,
                ShowPhotos = false,
                ShowDocuments = false,
                Orientation = "auto",
                GeneratedBy = AppConstants.AppNameFa,
                ReportDate = "",
                ShowSignature = false,
                SignatureTitle = "مدیر منابع انسانی"
            };
        }

        /// <summary>تاریخ گزارش برای سربرگ (یک‌بار، بدون تکرار در پاورقی).</summary>
        public string ResolveReportStamp()
        {
            var raw = string.IsNullOrWhiteSpace(ReportDate) ? PersianDate.Today() : ReportDate.Trim();
            var n = PersianDate.Normalize(raw);
            if (string.IsNullOrEmpty(n))
                n = PersianDate.Today();
            return PersianDate.LtrIsolate(PersianDate.DigitsFa(n));
        }
    }

    public sealed class ReportLayout
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public ReportExportOptions Options { get; set; }
        public string[] ColumnKeys { get; set; }
        public ReportEmployeeFilter Filters { get; set; }
    }

    public sealed class ReportLayoutPayload
    {
        public ReportExportOptions Options { get; set; }
        public string[] ColumnKeys { get; set; }
        public ReportEmployeeFilter Filters { get; set; }
    }
}
