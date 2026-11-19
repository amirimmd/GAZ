using System;
using System.Collections.Generic;
using System.IO;
using iTextSharp.text;
using iTextSharp.text.pdf;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;
using ITextFont = iTextSharp.text.Font;
using ITextImage = iTextSharp.text.Image;

namespace Qaemshahr.App.Services
{
    public static class PdfReport
    {
        static readonly BaseColor Ink = new BaseColor(0, 0, 0);
        static readonly BaseColor Paper = new BaseColor(255, 255, 255);
        static readonly BaseColor Brand = new BaseColor(15, 76, 92);
        static readonly BaseColor Zebra = new BaseColor(244, 247, 248);
        static readonly BaseColor Line = new BaseColor(176, 190, 197);
        static readonly BaseColor Muted = new BaseColor(91, 107, 112);

        public static void Write(string path, IList<Employee> rows, IList<ReportColumn> columns,
            ReportExportOptions options, byte[] logoPng)
        {
            Write(path, rows, columns, options, logoPng, null);
        }

        public static void Write(string path, IList<Employee> rows, IList<ReportColumn> columns,
            ReportExportOptions options, byte[] logoPng, DocumentRepository documents)
        {
            if (options == null)
                options = ReportExportOptions.CreateDefault();
            if (rows == null)
                rows = new List<Employee>();
            var cols = ExcelService.SelectedForExport(columns, options);
            var colCount = Math.Max(1, cols.Count);
            var title = string.IsNullOrWhiteSpace(options.Title) ? "گزارش کارکنان" : options.Title.Trim();

            var bf = BaseFont.CreateFont(ReportAssets.FontRegular(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
            var bfBold = BaseFont.CreateFont(ReportAssets.FontBold(), BaseFont.IDENTITY_H, BaseFont.EMBEDDED);

            var cellSize = colCount <= 8 ? 9f : colCount <= 16 ? 8f : colCount <= 24 ? 7f : 6.5f;
            var pad = colCount > 20 ? 2.4f : colCount > 12 ? 3.2f : 4.5f;
            float[] widths = MeasureColumnWidths(cols, rows, bf, bfBold, cellSize, pad);
            var needed = Sum(widths);
            if (needed > 2400f && cellSize > 6f)
            {
                cellSize = 6f;
                pad = 2.2f;
                widths = MeasureColumnWidths(cols, rows, bf, bfBold, cellSize, pad);
                needed = Sum(widths);
            }

            var margin = needed > 1600f ? 14f : 20f;
            var page = FitPage(options.Orientation, needed, margin, colCount);
            var contentW = page.Width - margin * 2f;
            ScaleToFill(widths, contentW);

            var cellFont = new ITextFont(bf, cellSize, ITextFont.NORMAL, Ink);
            var headerFont = new ITextFont(bfBold, Math.Max(cellSize, cellSize + 0.6f), ITextFont.NORMAL, Paper);
            var orgFont = new ITextFont(bfBold, 11f, ITextFont.NORMAL, Brand);
            var titleFont = new ITextFont(bfBold, 14f, ITextFont.NORMAL, Ink);
            var smallFont = new ITextFont(bf, 8f, ITextFont.NORMAL, Muted);
            var tinyFont = new ITextFont(bf, 7f, ITextFont.NORMAL, Muted);
            var waterFont = new ITextFont(bfBold, 42f, ITextFont.NORMAL, new BaseColor(120, 144, 156));
            var rowMin = cellSize + pad * 2f + 3f;

            var bottomMargin = options.ShowSignature ? 118f : 48f;
            var photoCache = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
            using (var fs = new FileStream(path, FileMode.Create, FileAccess.Write, FileShare.None, 1024 * 64))
            {
                var doc = new Document(page, margin, margin, 78, bottomMargin);
                var writer = PdfWriter.GetInstance(doc, fs);
                writer.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                writer.SetFullCompression();
                writer.CompressionLevel = PdfStream.BEST_SPEED;
                writer.PageEvent = new PageChrome
                {
                    Logo = options.ShowLogo ? logoPng : null,
                    WaterLogo = string.Equals(options.WatermarkMode, "logo", StringComparison.OrdinalIgnoreCase) ? logoPng : null,
                    WaterText = string.Equals(options.WatermarkMode, "text", StringComparison.OrdinalIgnoreCase) ? options.Watermark : null,
                    Title = title,
                    HeaderText = options.HeaderText,
                    FooterText = string.IsNullOrWhiteSpace(options.FooterText) ? AppConstants.OrganizationNameFa : options.FooterText,
                    ShowPages = options.ShowPageNumbers,
                    Stamp = options.ResolveReportStamp(),
                    ShowSignature = options.ShowSignature,
                    SignatureTitle = options.SignatureTitle,
                    OrgFont = orgFont,
                    TitleFont = titleFont,
                    SmallFont = smallFont,
                    TinyFont = tinyFont,
                    WaterFont = waterFont
                };
                doc.Open();

                var table = new PdfPTable(colCount);
                table.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                table.SetTotalWidth(widths);
                table.LockedWidth = true;
                table.HeaderRows = 1;
                table.SplitLate = true;
                table.SplitRows = false;
                table.HorizontalAlignment = Element.ALIGN_CENTER;
                table.SetWidths(widths);

                var docViews = new List<DocView>();
                foreach (var c in cols)
                    table.AddCell(Cell(c.TitleFa, headerFont, Brand, pad, true, false, rowMin));

                for (var r = 0; r < rows.Count; r++)
                {
                    var bg = r % 2 == 1 ? Zebra : Paper;
                    foreach (var c in cols)
                    {
                        if (c.Key == "photo")
                            table.AddCell(PhotoCell(rows[r], cellFont, bg, photoCache));
                        else if (DocumentKinds.IsDocColumn(c.Key))
                            table.AddCell(DocCell(rows[r], c.Key, cellFont, bg, path, documents, docViews));
                        else
                            table.AddCell(Cell(ExcelService.CellValue(rows[r], c.Key), cellFont, bg, pad, false, false, rowMin, c.Key));
                    }
                    if ((r + 1) % 80 == 0)
                        writer.Flush();
                }

                doc.Add(table);

                var summary = new PdfPTable(1);
                summary.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                summary.WidthPercentage = 100;
                summary.SpacingBefore = 10;
                var landscape = page.Width > page.Height;
                var sum = PersianDate.ReportText("تعداد رکورد: " + rows.Count + " — ستون‌ها: " + colCount + (landscape ? " — افقی" : ""));
                var sumCell = Cell(sum, smallFont, Paper, 4, false, true, 0);
                sumCell.Border = Rectangle.NO_BORDER;
                summary.AddCell(sumCell);
                doc.Add(summary);

                WriteDocPages(doc, writer, page, margin, docViews, titleFont, smallFont);

                doc.Close();
            }
        }

        static float[] MeasureColumnWidths(IList<ReportColumn> cols, IList<Employee> rows,
            BaseFont regular, BaseFont bold, float fontSize, float pad)
        {
            var widths = new float[cols.Count];
            for (var i = 0; i < cols.Count; i++)
            {
                var key = cols[i].Key;
                if (key == "photo")
                {
                    widths[i] = 44f;
                    continue;
                }
                if (DocumentKinds.IsDocColumn(key))
                {
                    widths[i] = 78f;
                    continue;
                }
                var headerFull = TextWidth(bold, fontSize + 0.6f, cols[i].TitleFa, true);
                var word = LongestTokenWidth(bold, fontSize + 0.6f, cols[i].TitleFa);
                var full = headerFull;
                var longLatin = IsLongContentField(key);
                if (rows != null && rows.Count > 0)
                {
                    // فیلدهای بلند لاتین: همهٔ ردیف‌ها؛ بقیه نمونه‌گیری
                    var sample = longLatin
                        ? SampleRowIndices(rows.Count, rows.Count)
                        : SampleRowIndices(rows.Count, 96);
                    for (var s = 0; s < sample.Length; s++)
                    {
                        var r = sample[s];
                        var val = DisplayCell(key, ExcelService.CellValue(rows[r], key));
                        var line = TextWidth(regular, fontSize, val, false);
                        if (line > full)
                            full = line;
                        var token = LongestTokenWidth(regular, fontSize, val, false);
                        if (token > word)
                            word = token;
                    }
                }
                var unbreakable = IsUnbreakableField(key);
                var padX = (pad + 1f) * 2f;
                if (longLatin)
                {
                    // عرض دقیق بر اساس بلندترین محتوا + حاشیهٔ سلول تو در تو
                    var content = Math.Max(word, full);
                    widths[i] = Math.Max(52f, content + padX + 22f);
                    continue;
                }
                if (unbreakable)
                {
                    widths[i] = Math.Max(36f, Math.Max(word, full) + padX + 16f);
                    continue;
                }
                var minToken = word + padX + 12f;
                var cap = WrapCap(key);
                var preferred = cap <= 0f ? full : Math.Min(full, cap);
                widths[i] = Math.Max(36f, Math.Max(minToken, preferred + padX + 8f));
            }
            return widths;
        }

        static bool IsLongContentField(string key)
        {
            switch (key)
            {
                case "email":
                case "linkedin":
                case "instagram":
                    return true;
                default:
                    return false;
            }
        }

        static float LongestTokenWidth(BaseFont font, float size, string text)
        {
            return LongestTokenWidth(font, size, text, true);
        }

        static float LongestTokenWidth(BaseFont font, float size, string text, bool digitsFa)
        {
            var t = digitsFa
                ? PersianDate.ReportText(text ?? string.Empty)
                : (text ?? string.Empty);
            t = t.Replace('\n', ' ').Replace('\r', ' ');
            if (t.Length == 0)
                return 0f;
            float max = 0f;
            var start = 0;
            for (var i = 0; i <= t.Length; i++)
            {
                if (i < t.Length && !char.IsWhiteSpace(t[i]))
                    continue;
                if (i > start)
                {
                    var w = font.GetWidthPoint(t.Substring(start, i - start), size);
                    if (w > max)
                        max = w;
                }
                start = i + 1;
            }
            return max;
        }

        static float WrapCap(string key)
        {
            switch (key)
            {
                case "address":
                case "personalDescription":
                    return 110f;
                case "fullName":
                case "position":
                case "previousPosition":
                case "desiredPosition":
                case "university":
                case "major":
                    return 94f;
                default:
                    return 80f;
            }
        }

        static bool IsUnbreakableField(string key)
        {
            switch (key)
            {
                case "birthDate":
                case "employmentDate":
                case "email":
                case "nationalId":
                case "employeeNumber":
                case "subscriptionNumber":
                case "phone":
                case "secondaryPhone":
                case "emergencyPhone":
                case "postalCode":
                case "insuranceNumber":
                case "telegram":
                case "whatsapp":
                case "instagram":
                case "linkedin":
                case "positionBase":
                case "personalBase":
                case "childrenCount":
                case "bloodGroup":
                case "checkIn":
                case "checkOut":
                case "hours":
                case "date":
                    return true;
                default:
                    return false;
            }
        }

        static bool HasBreakableSpace(string text)
        {
            if (string.IsNullOrEmpty(text))
                return false;
            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\u200B')
                    return true;
            }
            return false;
        }

        static bool NeedsLtrIsolate(string text)
        {
            if (string.IsNullOrEmpty(text) || HasBreakableSpace(text))
                return false;
            for (var i = 0; i < text.Length; i++)
            {
                var c = text[i];
                if (c == '@' || c == '.' || c == '/' || c == ':' || c == '-' || c == '_'
                    || c == '+' || c == '#' || c == '%')
                    return true;
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
                    return true;
                if (c >= '\u06F0' && c <= '\u06F9')
                    return true;
                if (c >= '\u0660' && c <= '\u0669')
                    return true;
            }
            return false;
        }

        static string DisplayCell(string key, string raw)
        {
            var t = (raw ?? string.Empty).Replace('\n', ' ').Replace('\r', ' ').Trim();
            if (IsLatinKeepField(key))
                return t;
            return PersianDate.ReportText(t);
        }

        static bool IsLatinKeepField(string key)
        {
            switch (key)
            {
                case "email":
                case "telegram":
                case "whatsapp":
                case "instagram":
                case "linkedin":
                    return true;
                default:
                    return false;
            }
        }

        static float TextWidth(BaseFont font, float size, string text)
        {
            return TextWidth(font, size, text, true);
        }

        static float TextWidth(BaseFont font, float size, string text, bool digitsFa)
        {
            var t = digitsFa
                ? PersianDate.ReportText(text ?? string.Empty)
                : (text ?? string.Empty);
            if (t.Length == 0)
                return 0f;
            t = t.Replace('\n', ' ').Replace('\r', ' ');
            return font.GetWidthPoint(t, size);
        }

        static float Sum(float[] values)
        {
            var s = 0f;
            for (var i = 0; i < values.Length; i++)
                s += values[i];
            return s;
        }

        static int[] SampleRowIndices(int count, int maxSamples)
        {
            if (count <= 0)
                return new int[0];
            if (count <= maxSamples)
            {
                var all = new int[count];
                for (var i = 0; i < count; i++)
                    all[i] = i;
                return all;
            }
            var set = new SortedSet<int> { 0, count - 1 };
            for (var i = 0; i < maxSamples - 2; i++)
            {
                var idx = (int)((long)(i + 1) * (count - 1) / (maxSamples - 1));
                set.Add(idx);
            }
            var arr = new int[set.Count];
            set.CopyTo(arr);
            return arr;
        }

        static void ScaleToFill(float[] widths, float contentW)
        {
            var total = Sum(widths);
            if (total <= 0f || contentW <= total)
                return;
            var k = contentW / total;
            for (var i = 0; i < widths.Length; i++)
                widths[i] *= k;
        }

        static Rectangle FitPage(string orientation, float neededTable, float margin, int colCount)
        {
            var pageW = neededTable + margin * 2f;
            var a4 = PageSize.A4;
            var a3 = PageSize.A3;
            var wantPortrait = string.Equals(orientation, "portrait", StringComparison.OrdinalIgnoreCase);
            var wantLandscape = string.Equals(orientation, "landscape", StringComparison.OrdinalIgnoreCase);
            if (!wantPortrait && !wantLandscape)
            {
                wantLandscape = colCount > 4 || pageW > a4.Width + 8f;
                wantPortrait = !wantLandscape;
            }

            if (wantPortrait)
            {
                var w = Math.Max(a4.Width, pageW);
                var h = a4.Height;
                if (w > a3.Width)
                    h = a3.Height;
                return new Rectangle(w, h);
            }

            var height = a4.Width;
            var width = Math.Max(a4.Height, pageW);
            if (width > a3.Height)
                height = a3.Width;
            return new Rectangle(width, height);
        }

        static readonly SpaceOnlySplitCharacter SpaceSplit = new SpaceOnlySplitCharacter();
        static readonly UrlAwareSplitCharacter UrlSplit = new UrlAwareSplitCharacter();

        static PdfPCell Cell(string text, ITextFont font, BaseColor bg, float pad, bool header)
        {
            return Cell(text, font, bg, pad, header, false, 0f, null);
        }

        static PdfPCell Cell(string text, ITextFont font, BaseColor bg, float pad, bool header, bool noWrap, float minHeight)
        {
            return Cell(text, font, bg, pad, header, noWrap, minHeight, null);
        }

        static PdfPCell Cell(string text, ITextFont font, BaseColor bg, float pad, bool header, bool noWrap, float minHeight, string key)
        {
            var safe = (text ?? string.Empty).Replace('\n', ' ').Replace('\r', ' ').Trim();
            var rendered = key != null ? DisplayCell(key, safe) : PersianDate.ReportText(safe);
            var longLatin = IsLongContentField(key);
            var unbreakable = !longLatin && (noWrap || IsUnbreakableField(key) || !HasBreakableSpace(rendered));
            var latin = IsLatinKeepField(key);
            var isolate = (unbreakable || longLatin) && (latin || NeedsLtrIsolate(rendered));
            if (isolate && !latin)
                rendered = PersianDate.LtrIsolate(rendered);
            var chunk = new Chunk(rendered, font);
            chunk.SetSplitCharacter(longLatin ? (ISplitCharacter)UrlSplit : SpaceSplit);
            var phrase = new Phrase(chunk);
            phrase.Leading = font.Size * 1.25f;

            PdfPCell cell;
            if (isolate)
            {
                var inner = new PdfPCell(phrase);
                inner.Border = Rectangle.NO_BORDER;
                inner.HorizontalAlignment = Element.ALIGN_CENTER;
                inner.VerticalAlignment = Element.ALIGN_MIDDLE;
                inner.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
                inner.NoWrap = unbreakable;
                inner.Padding = 0;
                inner.UseAscender = true;
                inner.UseDescender = true;
                inner.BackgroundColor = bg;
                if (longLatin)
                    inner.SetLeading(0f, 1.2f);
                var nest = new PdfPTable(1);
                nest.WidthPercentage = 100f;
                nest.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
                nest.SplitLate = false;
                nest.SplitRows = longLatin;
                nest.AddCell(inner);
                cell = new PdfPCell();
                cell.AddElement(nest);
                cell.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
                cell.NoWrap = false;
            }
            else
            {
                cell = new PdfPCell(phrase);
                cell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                cell.NoWrap = unbreakable;
                cell.SetLeading(0f, 1.22f);
            }
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.BackgroundColor = bg;
            cell.PaddingTop = pad;
            cell.PaddingBottom = pad;
            cell.PaddingLeft = pad + 1f;
            cell.PaddingRight = pad + 1f;
            cell.BorderColor = Line;
            cell.BorderWidth = header ? 0.8f : 0.5f;
            cell.UseAscender = true;
            cell.UseDescender = true;
            if (minHeight > 0f)
                cell.MinimumHeight = minHeight;
            return cell;
        }

        sealed class SpaceOnlySplitCharacter : ISplitCharacter
        {
            public bool IsSplitCharacter(int start, int current, int end, char[] cc, PdfChunk[] ck)
            {
                char c;
                if (ck == null || ck.Length == 0)
                    c = cc[current];
                else
                    c = (char)ck[Math.Min(current, ck.Length - 1)].GetUnicodeEquivalent(cc[current]);
                return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\u200B';
            }
        }

        /// <summary>شکستن نرم لینک/ایمیل روی . / @ _ - تا ستون بر اساس محتوا جا بگیرد و بریده نشود.</summary>
        sealed class UrlAwareSplitCharacter : ISplitCharacter
        {
            public bool IsSplitCharacter(int start, int current, int end, char[] cc, PdfChunk[] ck)
            {
                char c;
                if (ck == null || ck.Length == 0)
                    c = cc[current];
                else
                    c = (char)ck[Math.Min(current, ck.Length - 1)].GetUnicodeEquivalent(cc[current]);
                return c == ' ' || c == '\t' || c == '\n' || c == '\r' || c == '\u200B'
                    || c == '.' || c == '/' || c == '@' || c == '_' || c == '-' || c == ':' || c == '?';
            }
        }

        static PdfPCell PhotoCell(Employee person, ITextFont dashFont, BaseColor bg,
            Dictionary<string, byte[]> cache)
        {
            var path = person == null ? null : person.PhotoPath;
            byte[] bytes = null;
            if (!string.IsNullOrWhiteSpace(path) && cache != null)
            {
                if (!cache.TryGetValue(path, out bytes))
                {
                    var raw = EmployeePhotoStore.Read(path);
                    bytes = ReportImageUtil.ThumbnailJpeg(raw, 68, 92, 80L);
                    cache[path] = bytes;
                }
            }
            else
                bytes = EmployeePhotoStore.Read(path);

            if (bytes == null || bytes.Length == 0)
            {
                var empty = Cell("—", dashFont, bg, 4, false);
                empty.FixedHeight = 52f;
                return empty;
            }
            var img = ITextImage.GetInstance(bytes);
            img.ScaleToFit(34f, 46f);
            var cell = new PdfPCell(img, false);
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.BackgroundColor = bg;
            cell.Padding = 3f;
            cell.FixedHeight = 52f;
            cell.BorderColor = Line;
            cell.BorderWidth = 0.5f;
            return cell;
        }

        sealed class DocView
        {
            public string Name;
            public string Path;
            public string Caption;
        }

        static PdfPCell DocCell(Employee person, string key, ITextFont dashFont, BaseColor bg,
            string reportPath, DocumentRepository repo, List<DocView> views)
        {
            var rel = ReportDocPack.ExportFirst(person, key, repo, reportPath);
            if (string.IsNullOrEmpty(rel))
            {
                var empty = Cell("—", dashFont, bg, 4, false);
                empty.MinimumHeight = 22f;
                return empty;
            }
            var abs = ReportDocPack.AbsoluteFromRelative(reportPath, rel);
            var dest = "doc" + ((views == null ? 0 : views.Count) + 1);
            if (views != null)
            {
                var kind = DocumentKinds.KindFromColumn(key) ?? "مدرک";
                var who = person == null ? "" : (person.FullName ?? "").Trim();
                views.Add(new DocView
                {
                    Name = dest,
                    Path = abs,
                    Caption = string.IsNullOrEmpty(who) ? kind : kind + " — " + who
                });
            }
            var linkFont = new ITextFont(dashFont.BaseFont, dashFont.Size, ITextFont.UNDERLINE, Brand);
            var chunk = new Chunk("مشاهده", linkFont);
            chunk.SetLocalGoto(dest);
            var inner = new PdfPCell(new Phrase(chunk));
            inner.Border = Rectangle.NO_BORDER;
            inner.HorizontalAlignment = Element.ALIGN_CENTER;
            inner.VerticalAlignment = Element.ALIGN_MIDDLE;
            inner.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
            inner.Padding = 0;
            inner.BackgroundColor = bg;
            inner.UseAscender = true;
            inner.UseDescender = true;
            var nest = new PdfPTable(1);
            nest.WidthPercentage = 100f;
            nest.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
            nest.AddCell(inner);
            var cell = new PdfPCell();
            cell.AddElement(nest);
            cell.RunDirection = PdfWriter.RUN_DIRECTION_LTR;
            cell.HorizontalAlignment = Element.ALIGN_CENTER;
            cell.VerticalAlignment = Element.ALIGN_MIDDLE;
            cell.BackgroundColor = bg;
            cell.Padding = 3f;
            cell.MinimumHeight = 22f;
            cell.BorderColor = Line;
            cell.BorderWidth = 0.5f;
            cell.CellEvent = new NamedGotoCellEvent(dest);
            return cell;
        }

        static void WriteDocPages(Document doc, PdfWriter writer, Rectangle page, float margin,
            List<DocView> views, ITextFont titleFont, ITextFont smallFont)
        {
            if (doc == null || views == null || views.Count == 0)
                return;
            for (var i = 0; i < views.Count; i++)
            {
                var view = views[i];
                doc.NewPage();
                writer.DirectContent.LocalDestination(view.Name, new PdfDestination(PdfDestination.FIT));
                var caption = PersianDate.ReportText(view.Caption ?? "مدرک");
                var titleTable = new PdfPTable(1);
                titleTable.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                titleTable.WidthPercentage = 100f;
                titleTable.SpacingAfter = 10f;
                var titleCell = new PdfPCell(new Phrase(caption, titleFont));
                titleCell.Border = Rectangle.NO_BORDER;
                titleCell.HorizontalAlignment = Element.ALIGN_CENTER;
                titleCell.VerticalAlignment = Element.ALIGN_MIDDLE;
                titleCell.RunDirection = PdfWriter.RUN_DIRECTION_RTL;
                titleCell.PaddingBottom = 4f;
                titleTable.AddCell(titleCell);
                doc.Add(titleTable);
                if (string.IsNullOrEmpty(view.Path) || !File.Exists(view.Path))
                {
                    var missing = new Paragraph(PersianDate.ReportText("فایل مدرک پیدا نشد."), smallFont);
                    missing.Alignment = Element.ALIGN_CENTER;
                    doc.Add(missing);
                    continue;
                }
                if (ReportDocPack.IsImagePath(view.Path))
                {
                    try
                    {
                        var maxW = Math.Max(40f, page.Width - margin * 2f);
                        var maxH = Math.Max(40f, page.Height - 78f - 48f - 56f);
                        // مقیاس پیکسلی قبل از جاسازی تا حافظه منفجر نشود؛ ظاهر روی صفحه همان ScaleToFit است
                        var edge = Math.Max(480, (int)Math.Ceiling(Math.Max(maxW, maxH) * 1.6f));
                        var scaled = ReportImageUtil.LoadScaledFile(view.Path, edge, 78L);
                        var img = scaled != null && scaled.Length > 0
                            ? ITextImage.GetInstance(scaled)
                            : ITextImage.GetInstance(view.Path);
                        img.ScaleToFit(maxW, maxH);
                        img.Alignment = Element.ALIGN_CENTER;
                        doc.Add(img);
                    }
                    catch
                    {
                        var fail = new Paragraph(PersianDate.ReportText("نمایش تصویر ممکن نشد."), smallFont);
                        fail.Alignment = Element.ALIGN_CENTER;
                        doc.Add(fail);
                    }
                }
                else
                {
                    var note = new Paragraph(
                        PersianDate.ReportText("این مدرک تصویر نیست. فایل در پوشه مدارک کنار گزارش ذخیره شده است."),
                        smallFont);
                    note.Alignment = Element.ALIGN_CENTER;
                    doc.Add(note);
                }

                if ((i + 1) % 15 == 0)
                {
                    try { writer.Flush(); } catch { }
                    GC.Collect(1, GCCollectionMode.Optimized);
                }
            }
        }

        sealed class NamedGotoCellEvent : IPdfPCellEvent
        {
            readonly string _name;
            public NamedGotoCellEvent(string name) { _name = name; }

            public void CellLayout(PdfPCell cell, Rectangle position, PdfContentByte[] canvases)
            {
                if (string.IsNullOrEmpty(_name) || canvases == null || canvases.Length == 0 || position == null)
                    return;
                try
                {
                    var writer = canvases[0].PdfWriter;
                    writer.DirectContent.LocalGoto(_name, position.Left, position.Bottom, position.Right, position.Top);
                }
                catch
                {
                }
            }
        }

        sealed class PageChrome : PdfPageEventHelper
        {
            public byte[] Logo;
            public byte[] WaterLogo;
            public string WaterText;
            public string Title;
            public string HeaderText;
            public string FooterText;
            public bool ShowPages;
            public string Stamp;
            public bool ShowSignature;
            public string SignatureTitle;
            public ITextFont OrgFont;
            public ITextFont TitleFont;
            public ITextFont SmallFont;
            public ITextFont TinyFont;
            public ITextFont WaterFont;

            ITextImage _logoImg;
            ITextImage _waterImg;
            bool _logoTried;
            bool _waterTried;

            public override void OnEndPage(PdfWriter writer, Document document)
            {
                var page = document.PageSize;
                var under = writer.DirectContentUnder;
                var over = writer.DirectContent;

                if (WaterLogo != null && WaterLogo.Length > 0)
                {
                    try
                    {
                        if (!_waterTried)
                        {
                            _waterTried = true;
                            _waterImg = ITextImage.GetInstance(WaterLogo);
                            _waterImg.ScaleToFit(280, 280);
                        }
                        if (_waterImg != null)
                        {
                            _waterImg.SetAbsolutePosition((page.Width - _waterImg.ScaledWidth) / 2f, (page.Height - _waterImg.ScaledHeight) / 2f);
                            var gs = new PdfGState { FillOpacity = 0.08f, StrokeOpacity = 0.08f };
                            under.SaveState();
                            under.SetGState(gs);
                            under.AddImage(_waterImg);
                            under.RestoreState();
                        }
                    }
                    catch
                    {
                    }
                }
                else if (!string.IsNullOrWhiteSpace(WaterText))
                {
                    under.SaveState();
                    var gs = new PdfGState { FillOpacity = 0.12f };
                    under.SetGState(gs);
                    ColumnText.ShowTextAligned(under, Element.ALIGN_CENTER, new Phrase(PersianDate.ReportText(WaterText.Trim()), WaterFont),
                        page.Width / 2f, page.Height / 2f, 28, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                    under.RestoreState();
                }

                var top = page.Height - 18;
                if (Logo != null && Logo.Length > 0)
                {
                    try
                    {
                        if (!_logoTried)
                        {
                            _logoTried = true;
                            _logoImg = ITextImage.GetInstance(Logo);
                            _logoImg.ScaleToFit(46, 46);
                        }
                        if (_logoImg != null)
                        {
                            _logoImg.SetAbsolutePosition(page.Width - document.RightMargin - 46, top - 46);
                            over.AddImage(_logoImg);
                        }
                    }
                    catch
                    {
                    }
                }

                ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER, new Phrase(AppConstants.OrganizationNameFa, OrgFont),
                    page.Width / 2f, top - 14, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER, new Phrase(PersianDate.ReportText(Title), TitleFont),
                    page.Width / 2f, top - 32, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                if (!string.IsNullOrWhiteSpace(HeaderText))
                {
                    ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER, new Phrase(PersianDate.ReportText(HeaderText.Trim()), SmallFont),
                        page.Width / 2f, top - 46, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                }
                ColumnText.ShowTextAligned(over, Element.ALIGN_LEFT, new Phrase(Stamp ?? PersianDate.ReportDateOnly(null), SmallFont),
                    document.LeftMargin, top - 14, 0, PdfWriter.RUN_DIRECTION_LTR, 0);

                over.SetColorStroke(Brand);
                over.SetLineWidth(1.4f);
                over.MoveTo(document.LeftMargin, top - 58);
                over.LineTo(page.Width - document.RightMargin, top - 58);
                over.Stroke();

                // محل امضا درست بالای خط فوتر، با فاصله مناسب از محتوا
                if (ShowSignature)
                {
                    var sigTitle = string.IsNullOrWhiteSpace(SignatureTitle) ? "امضا" : SignatureTitle.Trim();
                    var footerLineY = document.BottomMargin - 8f;
                    var sigCenterX = document.LeftMargin + 90f;
                    ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER,
                        new Phrase(PersianDate.ReportText("........................"), SmallFont),
                        sigCenterX, footerLineY + 42f, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                    ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER,
                        new Phrase(PersianDate.ReportText(sigTitle), TitleFont),
                        sigCenterX, footerLineY + 24f, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                }

                var bottom = document.BottomMargin - 28;
                over.SetColorStroke(Line);
                over.SetLineWidth(0.6f);
                over.MoveTo(document.LeftMargin, document.BottomMargin - 8);
                over.LineTo(page.Width - document.RightMargin, document.BottomMargin - 8);
                over.Stroke();

                ColumnText.ShowTextAligned(over, Element.ALIGN_CENTER, new Phrase(PersianDate.ReportText(FooterText), SmallFont),
                    page.Width / 2f, bottom + 12, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                if (ShowPages)
                {
                    var pages = PersianDate.ReportText("صفحه " + writer.PageNumber);
                    ColumnText.ShowTextAligned(over, Element.ALIGN_RIGHT, new Phrase(pages, SmallFont),
                        page.Width - document.RightMargin, bottom + 12, 0, PdfWriter.RUN_DIRECTION_RTL, ColumnText.AR_LIG);
                }
            }
        }
    }
}
