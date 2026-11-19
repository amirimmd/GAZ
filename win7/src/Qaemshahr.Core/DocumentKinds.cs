using System.Collections.Generic;
using System.IO;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Core
{
    public static class DocumentKinds
    {
        public const string Birth = "شناسنامه";
        public const string National = "کارت ملی";
        public const string Other = "سایر";

        public static string Normalize(string category)
        {
            if (string.IsNullOrWhiteSpace(category))
                return Other;
            switch (category.Trim())
            {
                case Birth:
                case "birthCertificate":
                    return Birth;
                case National:
                case "nationalCard":
                    return National;
                default:
                    return Other;
            }
        }

        public static bool IsImage(EmployeeDocument doc)
        {
            if (doc == null)
                return false;
            var mime = doc.MimeType ?? string.Empty;
            if (mime.StartsWith("image/", System.StringComparison.OrdinalIgnoreCase))
                return true;
            var ext = (Path.GetExtension(doc.FileName ?? string.Empty) ?? string.Empty).ToLowerInvariant();
            return ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".bmp" || ext == ".gif" || ext == ".tif" || ext == ".tiff";
        }

        public static bool IsDocColumn(string key)
        {
            return key == "docBirth" || key == "docNational" || key == "docOther";
        }

        public static string KindFromColumn(string key)
        {
            if (key == "docBirth")
                return Birth;
            if (key == "docNational")
                return National;
            if (key == "docOther")
                return Other;
            return null;
        }

        public static List<EmployeeDocument> Of(Employee person, string kind)
        {
            var list = new List<EmployeeDocument>();
            if (person == null || person.Documents == null)
                return list;
            foreach (var d in person.Documents)
            {
                if (Normalize(d.Category) == kind)
                    list.Add(d);
            }
            return list;
        }

        public static EmployeeDocument First(Employee person, string kind)
        {
            var list = Of(person, kind);
            return list.Count == 0 ? null : list[0];
        }

        public static EmployeeDocument FirstImage(Employee person, string kind)
        {
            foreach (var d in Of(person, kind))
            {
                if (IsImage(d))
                    return d;
            }
            return null;
        }

        public static string Summary(Employee person, string kind)
        {
            var list = Of(person, kind);
            if (list.Count == 0)
                return string.Empty;
            if (list.Count == 1)
                return string.IsNullOrWhiteSpace(list[0].FileName) ? "دارد" : list[0].FileName;
            return list.Count + " فایل";
        }

        public static byte[] Preview(Employee person, string kind)
        {
            var img = FirstImage(person, kind);
            return img == null ? null : img.PreviewBytes;
        }
    }
}
