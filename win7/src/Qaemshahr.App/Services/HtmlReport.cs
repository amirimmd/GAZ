using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Services
{
    public static class HtmlReport
    {
        public static string Write(string title, IList<Employee> rows, IList<ReportColumn> columns)
        {
            var cols = new List<ReportColumn>();
            foreach (var c in columns)
                if (c.Selected) cols.Add(c);
            if (cols.Count == 0)
                cols = ExcelService.Catalog().FindAll(c => c.Selected);

            var sb = new StringBuilder();
            sb.Append("<!DOCTYPE html><html lang='fa'><head><meta charset='utf-8'><title>");
            sb.Append(Web(title));
            sb.Append("</title><style>body{font-family:Tahoma,sans-serif;direction:rtl;padding:24px}h1{color:#0B3D4A}table{border-collapse:collapse;width:100%;font-size:12px}th,td{border:1px solid #c5d0d4;padding:6px 8px;text-align:center}th{background:#0B3D4A;color:#fff} .meta{color:#5B6B70;font-size:12px;margin-bottom:16px}</style></head><body>");
            sb.Append("<h1>").Append(Web(title)).Append("</h1>");
            sb.Append("<div class='meta'>").Append(Web(AppConstants.OrganizationNameFa)).Append(" — ")
                .Append(Web(PersianDate.DigitsFa(PersianDate.Today()))).Append(" — نسخه ").Append(Web(PersianDate.DigitsFa(AppConstants.AppVersion))).Append("</div>");
            sb.Append("<table><thead><tr>");
            foreach (var c in cols)
                sb.Append("<th>").Append(Web(c.TitleFa)).Append("</th>");
            sb.Append("</tr></thead><tbody>");
            foreach (var e in rows)
            {
                sb.Append("<tr>");
                foreach (var c in cols)
                    sb.Append("<td>").Append(Web(ExcelService.CellValue(e, c.Key))).Append("</td>");
                sb.Append("</tr>");
            }
            sb.Append("</tbody></table></body></html>");
            var path = Path.Combine(Path.GetTempPath(), "qaemshahr_report_" + System.Guid.NewGuid().ToString("N") + ".html");
            File.WriteAllText(path, sb.ToString(), new UTF8Encoding(true));
            return path;
        }

        public static void Open(string path)
        {
            Process.Start(new ProcessStartInfo { FileName = path, UseShellExecute = true });
        }

        static string Web(string s)
        {
            if (string.IsNullOrEmpty(s))
                return string.Empty;
            return s.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;");
        }
    }
}
