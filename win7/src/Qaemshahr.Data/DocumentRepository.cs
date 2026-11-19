using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public sealed class DocumentRepository
    {
        readonly AppDatabase _db;

        public DocumentRepository(AppDatabase db)
        {
            _db = db;
        }

        public List<EmployeeDocument> List(string employeeId = null)
        {
            var sql = @"SELECT d.*, e.first_name, e.last_name, e.national_id FROM employee_documents d
                        INNER JOIN employees e ON e.id = d.employee_id
                        WHERE d.deleted_at IS NULL";
            if (!string.IsNullOrEmpty(employeeId))
                sql += " AND d.employee_id=@eid";
            sql += " ORDER BY e.last_name, e.first_name, d.category, d.uploaded_at DESC";
            var list = new List<EmployeeDocument>();
            using (var r = string.IsNullOrEmpty(employeeId)
                ? _db.Query(sql)
                : _db.Query(sql, Sql.P("@eid", employeeId)))
            {
                while (r.Read())
                {
                    list.Add(new EmployeeDocument
                    {
                        Id = Sql.Str(r["id"]),
                        EmployeeId = Sql.Str(r["employee_id"]),
                        EmployeeName = (Sql.Str(r["first_name"]) + " " + Sql.Str(r["last_name"])).Trim(),
                        NationalId = Sql.Str(r["national_id"]),
                        Title = Sql.Str(r["title"]),
                        Category = DocumentKinds.Normalize(Sql.Str(r["category"])),
                        Description = Sql.Str(r["description"]),
                        FileName = Sql.Str(r["file_name"]),
                        MimeType = Sql.Str(r["mime_type"]),
                        FileSize = Sql.Long(r["file_size"]),
                        StoragePath = Sql.Str(r["storage_path"]),
                        ContentHash = Sql.Str(r["content_hash"]),
                        UploadedAt = Sql.Long(r["uploaded_at"]),
                        UploadedBy = Sql.Str(r["uploaded_by"])
                    });
                }
            }
            return list;
        }

        public string Store(string employeeId, string title, string category, string filePath, string uploadedBy)
        {
            return Store(employeeId, title, category, filePath, uploadedBy, null);
        }

        public string Store(string employeeId, string title, string category, string filePath, string uploadedBy,
            string preferredFileName)
        {
            if (string.IsNullOrEmpty(employeeId) || !File.Exists(filePath))
                return "فایل یافت نشد";
            var bytes = File.ReadAllBytes(filePath);
            var ext = Path.GetExtension(filePath) ?? "";
            if (string.IsNullOrWhiteSpace(ext))
                ext = Path.GetExtension(preferredFileName ?? "") ?? "";
            title = NormalizeTitle(title, preferredFileName, filePath);
            var fileName = BuildDisplayFileName(title, ext, preferredFileName);
            var id = Sql.NewId();
            var safe = Regex.Replace(fileName, @"[^\w\.\-]+", "_");
            if (string.IsNullOrWhiteSpace(safe) || safe == "_" || safe == ".")
                safe = "document" + ext;
            var relative = Path.Combine(employeeId, id + "_" + safe + ".enc");
            var dest = Path.Combine(AppPaths.DocumentsDirectory, relative);
            Directory.CreateDirectory(Path.GetDirectoryName(dest));
            var encrypted = AesGcmService.Encrypt(KeyStore.DocumentKey, bytes, Encoding.UTF8.GetBytes(employeeId));
            File.WriteAllBytes(dest, encrypted);
            var hash = Sha256Util.Hex(encrypted);
            var now = Sql.Now();
            category = DocumentKinds.Normalize(category);
            _db.Execute(@"INSERT INTO employee_documents (id, employee_id, title, category, file_name, mime_type, file_size, storage_path, content_hash, uploaded_by, uploaded_at)
                          VALUES (@id,@eid,@t,@c,@fn,@mt,@sz,@sp,@h,@u,@now)",
                Sql.P("@id", id), Sql.P("@eid", employeeId), Sql.P("@t", title), Sql.P("@c", category),
                Sql.P("@fn", fileName), Sql.P("@mt", GuessMime(fileName)), Sql.P("@sz", bytes.LongLength),
                Sql.P("@sp", relative.Replace('\\', '/')), Sql.P("@h", hash), Sql.P("@u", uploadedBy), Sql.P("@now", now));
            return null;
        }

        static string NormalizeTitle(string title, string preferredFileName, string filePath)
        {
            var t = (title ?? "").Trim();
            if (string.IsNullOrWhiteSpace(t) && !string.IsNullOrWhiteSpace(preferredFileName))
                t = Path.GetFileNameWithoutExtension(preferredFileName.Trim());
            if (string.IsNullOrWhiteSpace(t))
                t = Path.GetFileNameWithoutExtension(filePath) ?? "document";
            // عنوان بدون پسوند ذخیره می‌شود
            if (!string.IsNullOrEmpty(Path.GetExtension(t)))
                t = Path.GetFileNameWithoutExtension(t);
            return t.Trim();
        }

        static string BuildDisplayFileName(string title, string ext, string preferredFileName)
        {
            if (!string.IsNullOrWhiteSpace(preferredFileName))
            {
                var preferred = preferredFileName.Trim();
                if (string.IsNullOrEmpty(Path.GetExtension(preferred)) && !string.IsNullOrEmpty(ext))
                    preferred = preferred + ext;
                return SanitizeFileName(preferred);
            }
            var baseName = string.IsNullOrWhiteSpace(title) ? "document" : title.Trim();
            if (!string.IsNullOrEmpty(Path.GetExtension(baseName)))
                return SanitizeFileName(baseName);
            return SanitizeFileName(baseName + (ext ?? ""));
        }

        static string SanitizeFileName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                return "document";
            var invalid = Path.GetInvalidFileNameChars();
            var chars = name.Trim().ToCharArray();
            for (var i = 0; i < chars.Length; i++)
            {
                if (chars[i] < 32 || Array.IndexOf(invalid, chars[i]) >= 0)
                    chars[i] = '_';
            }
            var t = new string(chars).Trim('.', ' ', '_');
            return t.Length == 0 ? "document" : t;
        }

        public string OpenToTemp(EmployeeDocument doc)
        {
            var full = Path.Combine(AppPaths.DocumentsDirectory, doc.StoragePath.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(full))
                throw new FileNotFoundException("فایل سند یافت نشد");
            var encrypted = File.ReadAllBytes(full);
            if (!string.Equals(Sha256Util.Hex(encrypted), doc.ContentHash, StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("یکپارچگی سند نقض شده است");
            var plain = AesGcmService.Decrypt(KeyStore.DocumentKey, encrypted, Encoding.UTF8.GetBytes(doc.EmployeeId));
            var openName = SanitizeFileName(
                !string.IsNullOrWhiteSpace(doc.Title)
                    ? doc.Title.Trim() + (Path.GetExtension(doc.FileName) ?? "")
                    : (doc.FileName ?? "document"));
            var tmp = Path.Combine(Path.GetTempPath(), "qaemshahr_" + Guid.NewGuid().ToString("N") + "_" + openName);
            File.WriteAllBytes(tmp, plain);
            return tmp;
        }

        public byte[] ReadPlain(EmployeeDocument doc)
        {
            var full = Path.Combine(AppPaths.DocumentsDirectory, doc.StoragePath.Replace('/', Path.DirectorySeparatorChar));
            if (!File.Exists(full))
                return null;
            var encrypted = File.ReadAllBytes(full);
            if (!string.Equals(Sha256Util.Hex(encrypted), doc.ContentHash, StringComparison.OrdinalIgnoreCase))
                return null;
            return AesGcmService.Decrypt(KeyStore.DocumentKey, encrypted, Encoding.UTF8.GetBytes(doc.EmployeeId));
        }

        public byte[] ReadIfImage(EmployeeDocument doc)
        {
            if (!DocumentKinds.IsImage(doc))
                return null;
            try
            {
                return ReadPlain(doc);
            }
            catch
            {
                return null;
            }
        }

        public static void AttachTo(IList<Employee> people, DocumentRepository repo)
        {
            AttachTo(people, repo, false);
        }

        public static void AttachTo(IList<Employee> people, DocumentRepository repo, bool loadPreviews)
        {
            if (people == null || repo == null)
                return;
            var all = repo.List();
            var map = new Dictionary<string, List<EmployeeDocument>>();
            foreach (var d in all)
            {
                List<EmployeeDocument> bag;
                if (!map.TryGetValue(d.EmployeeId, out bag))
                {
                    bag = new List<EmployeeDocument>();
                    map[d.EmployeeId] = bag;
                }
                if (loadPreviews && DocumentKinds.IsImage(d))
                    d.PreviewBytes = repo.ReadIfImage(d);
                bag.Add(d);
            }
            foreach (var p in people)
            {
                List<EmployeeDocument> bag;
                p.Documents = map.TryGetValue(p.Id ?? string.Empty, out bag) ? bag : new List<EmployeeDocument>();
            }
        }

        public void SoftDelete(string id)
        {
            _db.Execute("UPDATE employee_documents SET deleted_at=@n WHERE id=@id", Sql.P("@n", Sql.Now()), Sql.P("@id", id));
        }

        /// <summary>
        /// خروجی ZIP: هر کارمند یک پوشه، داخل آن زیرپوشه دسته سند با نام‌گذاری درست.
        /// </summary>
        public string ExportZip(IList<EmployeeDocument> docs, string zipPath, out int fileCount, out int employeeCount)
        {
            fileCount = 0;
            employeeCount = 0;
            if (docs == null || docs.Count == 0)
                return "سندی برای خروجی نیست";
            if (string.IsNullOrWhiteSpace(zipPath))
                return "مسیر فایل ZIP نامعتبر است";

            var root = Path.Combine(Path.GetTempPath(), "qaemshahr_docs_" + Guid.NewGuid().ToString("N"));
            try
            {
                Directory.CreateDirectory(root);
                var byEmp = new Dictionary<string, List<EmployeeDocument>>(StringComparer.Ordinal);
                foreach (var d in docs)
                {
                    if (d == null || string.IsNullOrEmpty(d.EmployeeId))
                        continue;
                    List<EmployeeDocument> bag;
                    if (!byEmp.TryGetValue(d.EmployeeId, out bag))
                    {
                        bag = new List<EmployeeDocument>();
                        byEmp[d.EmployeeId] = bag;
                    }
                    bag.Add(d);
                }
                employeeCount = byEmp.Count;
                foreach (var kv in byEmp)
                {
                    var first = kv.Value[0];
                    var folderName = BuildEmployeeFolderName(first.EmployeeName, first.NationalId);
                    var empDir = Path.Combine(root, folderName);
                    Directory.CreateDirectory(empDir);
                    foreach (var doc in kv.Value)
                    {
                        var plain = ReadPlain(doc);
                        if (plain == null || plain.Length == 0)
                            continue;
                        var cat = DocumentKinds.Normalize(doc.Category);
                        var catDir = Path.Combine(empDir, SanitizePathSegment(cat));
                        Directory.CreateDirectory(catDir);
                        var fileName = BuildExportFileName(doc);
                        var dest = UniquePath(Path.Combine(catDir, fileName));
                        File.WriteAllBytes(dest, plain);
                        fileCount++;
                    }
                }
                if (fileCount == 0)
                    return "هیچ فایلی قابل استخراج نبود";
                if (File.Exists(zipPath))
                    File.Delete(zipPath);
                System.IO.Compression.ZipFile.CreateFromDirectory(root, zipPath);
                return null;
            }
            catch (Exception ex)
            {
                return "خروجی ZIP ناموفق بود: " + ex.Message;
            }
            finally
            {
                try
                {
                    if (Directory.Exists(root))
                        Directory.Delete(root, true);
                }
                catch { }
            }
        }

        static string BuildEmployeeFolderName(string name, string nationalId)
        {
            var n = SanitizePathSegment(string.IsNullOrWhiteSpace(name) ? "بدون‌نام" : name.Trim());
            var id = SanitizePathSegment(string.IsNullOrWhiteSpace(nationalId) ? "" : nationalId.Trim());
            if (id.Length == 0)
                return n;
            return n + "_" + id;
        }

        static string BuildExportFileName(EmployeeDocument doc)
        {
            var ext = Path.GetExtension(doc.FileName ?? "") ?? "";
            var baseName = !string.IsNullOrWhiteSpace(doc.Title)
                ? doc.Title.Trim()
                : Path.GetFileNameWithoutExtension(doc.FileName ?? "document");
            if (string.IsNullOrWhiteSpace(baseName))
                baseName = "document";
            if (string.IsNullOrEmpty(ext))
                ext = Path.GetExtension(doc.FileName ?? "") ?? "";
            return SanitizeFileName(baseName + ext);
        }

        static string SanitizePathSegment(string name)
        {
            return SanitizeFileName(name).Replace('.', '_');
        }

        static string UniquePath(string path)
        {
            if (!File.Exists(path))
                return path;
            var dir = Path.GetDirectoryName(path) ?? "";
            var name = Path.GetFileNameWithoutExtension(path);
            var ext = Path.GetExtension(path);
            for (var i = 2; i < 1000; i++)
            {
                var candidate = Path.Combine(dir, name + "_" + i + ext);
                if (!File.Exists(candidate))
                    return candidate;
            }
            return Path.Combine(dir, name + "_" + Guid.NewGuid().ToString("N").Substring(0, 6) + ext);
        }

        static string GuessMime(string name)
        {
            var ext = (Path.GetExtension(name) ?? string.Empty).ToLowerInvariant();
            switch (ext)
            {
                case ".pdf": return "application/pdf";
                case ".jpg":
                case ".jpeg": return "image/jpeg";
                case ".png": return "image/png";
                case ".xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                case ".xls": return "application/vnd.ms-excel";
                case ".doc":
                case ".docx": return "application/msword";
                default: return "application/octet-stream";
            }
        }
    }
}
