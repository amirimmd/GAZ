using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public static class ReportDocPack
    {
        public const string DocsFolder = "مدارک";

        /// <summary>پیش‌خروجی موازی مدارک قبل از ساخت PDF/اکسل تا رمزگشایی تکراری نشود.</summary>
        public static void Prefetch(IList<Employee> people, IList<ReportColumn> columns,
            DocumentRepository repo, string reportPath)
        {
            if (people == null || people.Count == 0 || repo == null || string.IsNullOrWhiteSpace(reportPath))
                return;
            var keys = new List<string>();
            if (columns != null)
            {
                foreach (var c in columns)
                {
                    if (c != null && DocumentKinds.IsDocColumn(c.Key) && !keys.Contains(c.Key))
                        keys.Add(c.Key);
                }
            }
            if (keys.Count == 0)
                return;

            var reportDir = Path.GetDirectoryName(reportPath) ?? "";
            Directory.CreateDirectory(Path.Combine(reportDir, DocsFolder));
            foreach (var key in keys)
                Directory.CreateDirectory(Path.Combine(reportDir, DocsFolder, KindFolder(DocumentKinds.KindFromColumn(key))));

            Parallel.ForEach(people, new ParallelOptions { MaxDegreeOfParallelism = Math.Max(2, Environment.ProcessorCount / 2) },
                person =>
                {
                    if (person == null)
                        return;
                    foreach (var key in keys)
                    {
                        try { ExportFirst(person, key, repo, reportPath); }
                        catch { }
                    }
                });
        }

        public static string WrapReportPath(string chosenPath, bool withDocs)
        {
            if (!withDocs || string.IsNullOrWhiteSpace(chosenPath))
                return chosenPath;
            var ext = Path.GetExtension(chosenPath);
            if (string.IsNullOrWhiteSpace(ext))
                ext = ".xlsx";
            var name = SafeFile(Path.GetFileNameWithoutExtension(chosenPath), "report");
            var parent = Path.GetDirectoryName(chosenPath) ?? "";
            var dir = Path.Combine(parent, name);
            Directory.CreateDirectory(dir);
            Directory.CreateDirectory(Path.Combine(dir, DocsFolder));
            return Path.Combine(dir, name + ext);
        }

        public static string KindFolder(string kind)
        {
            if (kind == DocumentKinds.Birth)
                return "شناسنامه";
            if (kind == DocumentKinds.National)
                return "کارت ملی";
            return "سایر اسناد";
        }

        public static string ExportFirst(Employee person, string columnKey, DocumentRepository repo, string reportPath)
        {
            if (person == null || repo == null || string.IsNullOrWhiteSpace(reportPath))
                return null;
            var kind = DocumentKinds.KindFromColumn(columnKey);
            var files = DocumentKinds.Of(person, kind);
            if (files.Count == 0)
                return null;

            var reportDir = Path.GetDirectoryName(reportPath) ?? "";
            var sub = KindFolder(kind);
            var destDir = Path.Combine(reportDir, DocsFolder, sub);
            Directory.CreateDirectory(destDir);

            string firstRel = null;
            var nid = AsciiId(person.NationalId, person.Id);
            for (var i = 0; i < files.Count; i++)
            {
                var doc = files[i];
                var ext = SafeExt(doc.FileName, doc.MimeType);
                var fileName = (i + 1).ToString("00") + "_" + nid + ext;
                var dest = Path.Combine(destDir, fileName);
                var rel = DocsFolder + "/" + sub + "/" + fileName;
                if (File.Exists(dest) && new FileInfo(dest).Length > 0)
                {
                    if (firstRel == null)
                        firstRel = rel;
                    continue;
                }
                byte[] bytes;
                try
                {
                    bytes = repo.ReadPlain(doc);
                }
                catch
                {
                    bytes = null;
                }
                if (bytes == null || bytes.Length == 0)
                    continue;
                File.WriteAllBytes(dest, bytes);
                if (firstRel == null)
                    firstRel = rel;
            }
            return firstRel;
        }

        public static string AbsoluteFromRelative(string reportPath, string relative)
        {
            if (string.IsNullOrWhiteSpace(reportPath) || string.IsNullOrWhiteSpace(relative))
                return null;
            var dir = Path.GetDirectoryName(reportPath) ?? "";
            return Path.GetFullPath(Path.Combine(dir, relative.Replace('/', Path.DirectorySeparatorChar)));
        }

        public static bool IsImagePath(string path)
        {
            var ext = (Path.GetExtension(path) ?? "").ToLowerInvariant();
            return ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".bmp" || ext == ".gif" || ext == ".tif" || ext == ".tiff";
        }

        static string AsciiId(string nationalId, string fallback)
        {
            var s = PersianDate.DigitsEn(nationalId ?? "");
            var sb = new System.Text.StringBuilder();
            foreach (var ch in s)
            {
                if ((ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
                    sb.Append(ch);
            }
            if (sb.Length > 0)
                return sb.ToString();
            s = fallback ?? "";
            foreach (var ch in s)
            {
                if ((ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z'))
                    sb.Append(ch);
            }
            return sb.Length == 0 ? "id" : sb.ToString();
        }

        static string SafeFile(string name, string fallback)
        {
            if (string.IsNullOrWhiteSpace(name))
                return fallback;
            var invalid = Path.GetInvalidFileNameChars();
            var chars = name.Trim().ToCharArray();
            for (var i = 0; i < chars.Length; i++)
            {
                if (chars[i] < 32 || Array.IndexOf(invalid, chars[i]) >= 0)
                    chars[i] = '_';
            }
            var t = new string(chars).Trim('.', ' ', '_');
            return t.Length == 0 ? fallback : t;
        }

        static string SafeExt(string fileName, string mime)
        {
            var ext = Path.GetExtension(fileName ?? "").ToLowerInvariant();
            if (ext == ".jpg" || ext == ".jpeg" || ext == ".png" || ext == ".bmp" || ext == ".gif"
                || ext == ".tif" || ext == ".tiff" || ext == ".pdf" || ext == ".webp")
                return ext == ".jpeg" ? ".jpg" : ext;
            if (!string.IsNullOrEmpty(mime))
            {
                if (mime.IndexOf("jpeg", StringComparison.OrdinalIgnoreCase) >= 0 || mime.IndexOf("jpg", StringComparison.OrdinalIgnoreCase) >= 0)
                    return ".jpg";
                if (mime.IndexOf("png", StringComparison.OrdinalIgnoreCase) >= 0)
                    return ".png";
                if (mime.IndexOf("pdf", StringComparison.OrdinalIgnoreCase) >= 0)
                    return ".pdf";
                if (mime.IndexOf("gif", StringComparison.OrdinalIgnoreCase) >= 0)
                    return ".gif";
                if (mime.IndexOf("bmp", StringComparison.OrdinalIgnoreCase) >= 0)
                    return ".bmp";
            }
            return ".bin";
        }
    }
}
