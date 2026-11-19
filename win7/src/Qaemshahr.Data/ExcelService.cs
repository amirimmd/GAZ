using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using ClosedXML.Excel;
using ClosedXML.Excel.Drawings;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.Data
{
    public static class ExcelService
    {
        public static readonly string[] TemplateHeaders = BulkImportCatalog.HeadersForSections(
            new[] { BulkImportCatalog.Identity, BulkImportCatalog.Org, BulkImportCatalog.Contact, BulkImportCatalog.Education });

        public static void WriteTemplate(string path)
        {
            WriteTemplate(path, new[]
            {
                BulkImportCatalog.Identity, BulkImportCatalog.Org, BulkImportCatalog.Contact, BulkImportCatalog.Education
            });
        }

        public static void WriteTemplate(string path, IEnumerable<string> sectionKeys)
        {
            WriteTemplateForFields(path, BulkImportCatalog.FieldsForSections(sectionKeys));
        }

        public static void WriteTemplateForFields(string path, IEnumerable<BulkImportCatalog.Field> fields)
        {
            var list = fields == null ? null : new System.Collections.Generic.List<BulkImportCatalog.Field>(fields);
            if (list == null || list.Count == 0)
                list = BulkImportCatalog.FieldsForKeys(BulkImportCatalog.DefaultSelectedFieldKeys());
            var headers = new string[list.Count];
            for (var i = 0; i < list.Count; i++)
                headers[i] = list[i].TitleFa;
            using (var wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add("پرسنل");
                ws.RightToLeft = true;
                ws.Cell(1, 1).Value =
                    "ردیف راهنما را پاک کنید. تاریخ‌ها شمسی‌اند (مثل 1370/01/15). فقط ستون‌های فیلدهای انتخاب‌شده در قالب آمده‌اند.";
                ws.Range(1, 1, 1, headers.Length).Merge();
                for (var i = 0; i < headers.Length; i++)
                    ws.Cell(2, i + 1).Value = headers[i];
                ws.Row(2).Style.Font.Bold = true;
                ws.Cell(3, 1).Value = "علی";
                ws.Cell(3, 2).Value = "محمدی";
                var nidCol = System.Array.IndexOf(headers, "کد ملی");
                if (nidCol >= 0)
                    ws.Cell(3, nidCol + 1).Value = "0079974114";
                ws.Columns().AdjustToContents();
                wb.SaveAs(path);
            }
        }

        public static void ExportEmployees(string path, IList<Employee> rows, IList<ReportColumn> columns)
        {
            ExportEmployees(path, rows, columns, ReportExportOptions.CreateDefault(), null);
        }

        public static void ExportEmployees(string path, IList<Employee> rows, IList<ReportColumn> columns,
            ReportExportOptions options, byte[] logoPng)
        {
            ExportEmployees(path, rows, columns, options, logoPng, null);
        }

        public static void ExportEmployees(string path, IList<Employee> rows, IList<ReportColumn> columns,
            ReportExportOptions options, byte[] logoPng, DocumentRepository documents)
        {
            if (options == null)
                options = ReportExportOptions.CreateDefault();
            using (var wb = new XLWorkbook())
            {
                var ws = wb.Worksheets.Add("گزارش");
                ws.RightToLeft = true;
                ws.Style.Font.FontName = "Tahoma";
                ws.Style.Font.FontSize = 11;
                var cols = SelectedForExport(columns, options);
                var span = Math.Max(1, cols.Count);
                var brand = XLColor.FromArgb(0x0B, 0x4A, 0x6F);
                var titleBg = XLColor.FromArgb(0x1A, 0x6A, 0x96);
                var metaBg = XLColor.FromArgb(0xE8, 0xF0, 0xF5);
                var accent = XLColor.FromArgb(0xC4, 0x1E, 0x3A);
                var zebra = XLColor.FromArgb(0xF7, 0xFA, 0xFC);
                var ink = XLColor.FromArgb(0x1A, 0x24, 0x2B);
                var muted = XLColor.FromArgb(0x5C, 0x6B, 0x74);
                var line = XLColor.FromArgb(0xD5, 0xDE, 0xE4);
                var white = XLColor.White;
                var title = string.IsNullOrWhiteSpace(options.Title) ? "گزارش کارکنان" : options.Title.Trim();
                var showLogo = options.ShowLogo && logoPng != null && logoPng.Length > 0;
                var textStart = showLogo && span > 1 ? 2 : 1;
                var logoFrom = 0;
                var logoTo = 0;

                wb.Properties.Author = AppConstants.AppNameFa;
                wb.Properties.Title = title;
                wb.Properties.Company = AppConstants.OrganizationNameFa;
                ws.TabColor = brand;

                var row = 1;
                if (showLogo && span <= 1)
                {
                    ws.Row(1).Height = 18;
                    ws.Cell(1, 1).Style.Fill.BackgroundColor = white;
                    logoFrom = 1;
                    logoTo = 1;
                    row = 2;
                }

                MergeStyled(ws, row, textStart, span, AppConstants.OrganizationNameFa, brand, white, true, 16, 26);
                row++;
                MergeStyled(ws, row, textStart, span, title, titleBg, white, true, 13, 22);
                row++;
                MergeStyled(ws, row, textStart, span, options.ResolveReportStamp(),
                    metaBg, ink, false, 10, 18);
                row++;
                if (!string.IsNullOrWhiteSpace(options.HeaderText))
                {
                    MergeStyled(ws, row, textStart, span, options.HeaderText.Trim(), metaBg, muted, false, 10, 18);
                    row++;
                }
                if (string.Equals(options.WatermarkMode, "text", StringComparison.OrdinalIgnoreCase)
                    && !string.IsNullOrWhiteSpace(options.Watermark))
                {
                    MergeStyled(ws, row, textStart, span, options.Watermark.Trim(), metaBg, muted, false, 10, 16);
                    row++;
                }

                if (showLogo && span > 1)
                {
                    logoFrom = 1;
                    logoTo = row - 1;
                    var well = ws.Range(logoFrom, 1, logoTo, 1);
                    well.Merge();
                    well.Style.Fill.BackgroundColor = white;
                    well.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    well.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                }

                MergeStyled(ws, row, 1, span, "", accent, white, false, 8, 5);
                row++;

                var headerRow = row;
                for (var i = 0; i < cols.Count; i++)
                {
                    var cell = ws.Cell(headerRow, i + 1);
                    cell.Value = cols[i].TitleFa;
                    cell.Style.Font.Bold = true;
                    cell.Style.Font.FontName = "Tahoma";
                    cell.Style.Font.FontSize = 10;
                    cell.Style.Font.FontColor = white;
                    cell.Style.Fill.BackgroundColor = brand;
                    cell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                    cell.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                    cell.Style.Alignment.WrapText = false;
                    cell.Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    cell.Style.Border.OutsideBorderColor = line;
                    cell.Style.Border.BottomBorder = XLBorderStyleValues.Medium;
                    cell.Style.Border.BottomBorderColor = accent;
                }
                ws.Row(headerRow).Height = 24;
                row++;

                // عرض/ارتفاع سلول عکس را قبل از درج تصویر ثابت کن تا MoveAndSize بعداً شکل را خراب نکند.
                const int photoPad = 3;
                const int photoMaxW = 45; // نسبت ۳×۴ پرتره (عرض×ارتفاع)
                const int photoMaxH = 60;
                var photoColWidth = PixelsToExcelWidth(photoMaxW + photoPad * 2);
                var photoRowHeightPts = (photoMaxH + photoPad * 2) * 72.0 / 96.0;
                var hasPhotoCol = false;
                for (var c = 0; c < cols.Count; c++)
                {
                    if (cols[c].Key != "photo")
                        continue;
                    hasPhotoCol = true;
                    ws.Column(c + 1).Width = photoColWidth;
                }

                var firstData = row;
                var hasDocCols = cols.Exists(c => DocumentKinds.IsDocColumn(c.Key));
                if (hasDocCols)
                    Directory.CreateDirectory(Path.Combine(Path.GetDirectoryName(path) ?? "", ReportDocPack.DocsFolder));

                var photoThumbCache = new Dictionary<string, byte[]>(StringComparer.OrdinalIgnoreCase);
                for (var r = 0; r < rows.Count; r++)
                {
                    var odd = r % 2 == 1;
                    var hasPicCol = false;
                    for (var c = 0; c < cols.Count; c++)
                    {
                        var cell = ws.Cell(row, c + 1);
                        var key = cols[c].Key;
                        var wrap = key == "address" || key == "personalDescription";
                        cell.Style.Font.FontName = "Tahoma";
                        cell.Style.Font.FontSize = 10;
                        cell.Style.Font.FontColor = ink;
                        cell.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        cell.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                        cell.Style.Alignment.WrapText = wrap;
                        cell.Style.Border.OutsideBorder = XLBorderStyleValues.Hair;
                        cell.Style.Border.OutsideBorderColor = line;
                        cell.Style.Fill.BackgroundColor = odd ? zebra : white;

                        if (DocumentKinds.IsDocColumn(key))
                        {
                            WriteDocViewCell(cell, rows[r], key, documents, path);
                            continue;
                        }
                        if (IsPictureColumn(key))
                        {
                            hasPicCol = true;
                            cell.Value = string.Empty;
                        }
                        else
                        {
                            cell.Value = CellValue(rows[r], key);
                            if (IsPlainTextColumn(key))
                                cell.Style.NumberFormat.Format = "@";
                        }
                    }
                    ws.Row(row).Height = hasPicCol ? photoRowHeightPts : 18;
                    for (var c = 0; c < cols.Count; c++)
                    {
                        var key = cols[c].Key;
                        if (!IsPictureColumn(key))
                            continue;
                        var bytes = PictureBytesCached(rows[r], key, photoThumbCache, photoMaxW * 2, photoMaxH * 2);
                        if (bytes == null || bytes.Length == 0)
                        {
                            ws.Cell(row, c + 1).Value = PictureFallback(rows[r], key);
                            continue;
                        }
                        if (!PlaceCellPhoto(ws, row, c + 1, bytes, photoMaxW, photoMaxH, photoPad))
                            ws.Cell(row, c + 1).Value = PictureFallback(rows[r], key);
                    }
                    row++;
                }
                var lastData = Math.Max(headerRow, row - 1);

                row++;
                var countText = "تعداد رکورد: " + PersianDate.DigitsFa(rows.Count.ToString());
                if (!string.IsNullOrWhiteSpace(options.FooterText))
                    countText += "   |   " + options.FooterText.Trim();
                MergeStyled(ws, row, 1, span, countText, metaBg, brand, true, 10, 20);

                if (options.ShowSignature)
                {
                    row += 3;
                    var sigStart = Math.Max(1, span - 1);
                    var sigTitle = string.IsNullOrWhiteSpace(options.SignatureTitle)
                        ? "امضا"
                        : options.SignatureTitle.Trim();
                    MergeStyled(ws, row, sigStart, span,
                        "........................", white, muted, false, 10, 18);
                    row++;
                    MergeStyled(ws, row, sigStart, span,
                        sigTitle, white, brand, true, 11, 22);
                }

                for (var c = 0; c < cols.Count; c++)
                {
                    var key = cols[c].Key;
                    if (key == "photo")
                    {
                        // از قبل ثابت شده؛ دوباره تغییر نده تا عکس‌ها جابه‌جا/کج نشوند.
                        if (!hasPhotoCol)
                            ws.Column(c + 1).Width = photoColWidth;
                    }
                    else if (DocumentKinds.IsDocColumn(key))
                        ws.Column(c + 1).Width = 14;
                    else
                        ws.Column(c + 1).Width = HeuristicExcelWidth(key);
                }
                if (logoFrom > 0)
                    PlaceHeaderLogo(ws, logoPng, logoFrom, logoTo, white);

                ws.SheetView.FreezeRows(headerRow);
                if (cols.Count > 0 && lastData >= headerRow)
                    ws.Range(headerRow, 1, lastData, span).SetAutoFilter();

                ws.PageSetup.PaperSize = cols.Count > 14 ? XLPaperSize.A3Paper : XLPaperSize.A4Paper;
                ws.PageSetup.PageOrientation = cols.Count > 5
                    ? XLPageOrientation.Landscape
                    : XLPageOrientation.Portrait;
                ws.PageSetup.CenterHorizontally = true;
                ws.PageSetup.Margins.Top = 0.5;
                ws.PageSetup.Margins.Bottom = 0.5;
                ws.PageSetup.Margins.Left = 0.45;
                ws.PageSetup.Margins.Right = 0.45;
                ws.PageSetup.Margins.Header = 0.25;
                ws.PageSetup.Margins.Footer = 0.25;
                ws.PageSetup.Header.Center.AddText(title);
                ws.PageSetup.Footer.Center.AddText(AppConstants.OrganizationNameFa);
                ws.PageSetup.SetRowsToRepeatAtTop(headerRow, headerRow);
                ws.PageSetup.PrintAreas.Clear();
                ws.PageSetup.PrintAreas.Add(1, 1, row, span);

                wb.SaveAs(path);
            }
        }

        static void MergeStyled(IXLWorksheet ws, int row, int span, string text, XLColor bg, XLColor fg,
            bool bold, int fontSize, double height)
        {
            MergeStyled(ws, row, 1, Math.Max(1, span), text, bg, fg, bold, fontSize, height);
        }

        static void MergeStyled(IXLWorksheet ws, int row, int startCol, int endCol, string text, XLColor bg, XLColor fg,
            bool bold, int fontSize, double height)
        {
            if (startCol < 1)
                startCol = 1;
            if (endCol < startCol)
                endCol = startCol;
            ws.Cell(row, startCol).Value = text ?? string.Empty;
            var range = ws.Range(row, startCol, row, endCol);
            if (endCol > startCol)
                range.Merge();
            range.Style.Font.Bold = bold;
            range.Style.Font.FontSize = fontSize;
            range.Style.Font.FontName = "Tahoma";
            range.Style.Font.FontColor = fg;
            range.Style.Fill.BackgroundColor = bg;
            range.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            range.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
            range.Style.Alignment.WrapText = false;
            ws.Row(row).Height = height;
        }

        static bool IsPlainTextColumn(string key)
        {
            switch (key)
            {
                case "nationalId":
                case "employeeNumber":
                case "subscriptionNumber":
                case "phone":
                case "secondaryPhone":
                case "emergencyPhone":
                case "postalCode":
                case "insuranceNumber":
                    return true;
                default:
                    return false;
            }
        }

        static void PlaceHeaderLogo(IXLWorksheet ws, byte[] logoPng, int fromRow, int toRow, XLColor wellColor)
        {
            if (ws == null || logoPng == null || logoPng.Length == 0 || fromRow < 1)
                return;
            if (toRow < fromRow)
                toRow = fromRow;

            int srcW;
            int srcH;
            if (!TryImageSize(logoPng, out srcW, out srcH))
            {
                srcW = 64;
                srcH = 64;
            }

            const int maxW = 72;
            const int maxH = 58;
            const int pad = 8;
            int fitW;
            int fitH;
            FitContain(srcW, srcH, maxW, maxH, out fitW, out fitH);

            var needColPx = fitW + pad * 2;
            var needRowPx = fitH + pad * 2;
            var needColWidth = PixelsToExcelWidth(needColPx);
            ws.Column(1).Width = Math.Max(ws.Column(1).Width, needColWidth);

            var colPx = ExcelWidthToPixels(ws.Column(1).Width);
            var rowPx = 0.0;
            for (var r = fromRow; r <= toRow; r++)
                rowPx += ws.Row(r).Height * 96.0 / 72.0;
            if (rowPx < needRowPx)
            {
                var extraPts = (needRowPx - rowPx) * 72.0 / 96.0;
                var n = toRow - fromRow + 1;
                var add = extraPts / n;
                for (var r = fromRow; r <= toRow; r++)
                    ws.Row(r).Height += add;
                rowPx = needRowPx;
            }

            var well = ws.Range(fromRow, 1, toRow, 1);
            well.Style.Fill.BackgroundColor = wellColor;
            well.Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            well.Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

            var offX = (int)Math.Max(0, Math.Round((colPx - fitW) / 2.0));
            var offY = (int)Math.Max(0, Math.Round((rowPx - fitH) / 2.0));
            using (var ms = new MemoryStream(logoPng))
            {
                var pic = ws.AddPicture(ms).MoveTo(ws.Cell(fromRow, 1), offX, offY);
                pic.WithSize(fitW, fitH);
                pic.Placement = XLPicturePlacement.Move;
            }
        }

        static bool TryImageSize(byte[] bytes, out int width, out int height)
        {
            width = 0;
            height = 0;
            if (bytes == null || bytes.Length < 24)
                return false;
            try
            {
                using (var ms = new MemoryStream(bytes))
                using (var img = Image.FromStream(ms, false, false))
                {
                    width = img.Width;
                    height = img.Height;
                    return width > 0 && height > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        static void FitContain(int srcW, int srcH, int maxW, int maxH, out int fitW, out int fitH)
        {
            if (srcW < 1) srcW = 1;
            if (srcH < 1) srcH = 1;
            var scale = Math.Min(maxW / (double)srcW, maxH / (double)srcH);
            fitW = Math.Max(8, (int)Math.Round(srcW * scale));
            fitH = Math.Max(8, (int)Math.Round(srcH * scale));
            if (fitW > maxW) fitW = maxW;
            if (fitH > maxH) fitH = maxH;
        }

        /// <summary>
        /// عکس پرسنلی را وسط سلول می‌چیند، نسبت را حفظ می‌کند و با Placement=Move قفل می‌کند
        /// تا تغییر عرض ستون‌های دیگر شکل را خراب نکند.
        /// </summary>
        static bool PlaceCellPhoto(IXLWorksheet ws, int row, int col, byte[] bytes,
            int maxW, int maxH, int pad)
        {
            if (ws == null || bytes == null || bytes.Length == 0 || row < 1 || col < 1)
                return false;
            try
            {
                int srcW;
                int srcH;
                if (!TryImageSize(bytes, out srcW, out srcH))
                {
                    srcW = maxW;
                    srcH = maxH;
                }

                int fitW;
                int fitH;
                FitContain(srcW, srcH, maxW, maxH, out fitW, out fitH);

                var colPx = ExcelWidthToPixels(ws.Column(col).Width);
                var rowPx = ws.Row(row).Height * 96.0 / 72.0;
                var needW = fitW + pad * 2;
                var needH = fitH + pad * 2;
                if (colPx < needW)
                {
                    ws.Column(col).Width = PixelsToExcelWidth((int)Math.Ceiling((double)needW));
                    colPx = ExcelWidthToPixels(ws.Column(col).Width);
                }
                if (rowPx < needH)
                {
                    ws.Row(row).Height = needH * 72.0 / 96.0;
                    rowPx = needH;
                }

                var offX = (int)Math.Max(0, Math.Round((colPx - fitW) / 2.0));
                var offY = (int)Math.Max(0, Math.Round((rowPx - fitH) / 2.0));
                using (var ms = new MemoryStream(bytes))
                {
                    var pic = ws.AddPicture(ms).MoveTo(ws.Cell(row, col), offX, offY);
                    pic.WithSize(fitW, fitH);
                    pic.Placement = XLPicturePlacement.Move;
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        static double PixelsToExcelWidth(int pixels)
        {
            return Math.Max(4.0, (pixels + 5) / 7.0);
        }

        static double ExcelWidthToPixels(double width)
        {
            return Math.Max(1, width * 7.0 - 5);
        }

        public static List<Tuple<Employee, List<string>>> ReadEmployees(string path)
        {
            var results = new List<Tuple<Employee, List<string>>>();
            using (var wb = new XLWorkbook(path))
            {
                var ws = wb.Worksheet(1);
                var headerRow = 1;
                var first = ws.Row(1).Cell(1).GetString();
                if (first.Contains("راهنما") || first.Contains("ردیف"))
                    headerRow = 2;
                var map = new Dictionary<int, string>();
                for (var c = 1; c <= 40; c++)
                {
                    var h = ws.Cell(headerRow, c).GetString().Trim();
                    if (string.IsNullOrEmpty(h))
                        break;
                    map[c] = NormalizeHeader(h);
                }
                var row = headerRow + 1;
                while (true)
                {
                    var empty = true;
                    for (var c = 1; c <= map.Count; c++)
                    {
                        if (!string.IsNullOrWhiteSpace(ws.Cell(row, c).GetString()))
                        { empty = false; break; }
                    }
                    if (empty)
                        break;
                    var e = new Employee { EmploymentStatus = "active" };
                    var errors = new List<string>();
                    foreach (var kv in map)
                    {
                        var val = ws.Cell(row, kv.Key).GetString().Trim();
                        Assign(e, kv.Value, val);
                    }
                    if (string.IsNullOrWhiteSpace(e.FirstName) && string.IsNullOrWhiteSpace(e.LastName) && string.IsNullOrWhiteSpace(e.NationalId))
                    {
                        row++;
                        continue;
                    }
                    if (string.IsNullOrWhiteSpace(e.FirstName) || string.IsNullOrWhiteSpace(e.LastName))
                        errors.Add("نام ناقص");
                    if (!IranianNationalId.IsValid(e.NationalId ?? ""))
                        errors.Add("کد ملی نامعتبر");
                    if (!string.IsNullOrWhiteSpace(e.BirthDate))
                    {
                        var birth = PersianDate.Normalize(e.BirthDate);
                        if (birth == null)
                            errors.Add("تاریخ تولد نامعتبر");
                        else
                            e.BirthDate = birth;
                    }
                    if (!string.IsNullOrWhiteSpace(e.EmploymentDate))
                    {
                        var hired = PersianDate.Normalize(e.EmploymentDate);
                        if (hired == null)
                            errors.Add("تاریخ استخدام نامعتبر");
                        else
                            e.EmploymentDate = hired;
                    }
                    results.Add(Tuple.Create(errors.Count == 0 ? e : (Employee)null, errors));
                    // حتی با خطا در لیست بماند تا کاربر ببیند
                    if (errors.Count > 0)
                        results[results.Count - 1] = Tuple.Create(e, errors);
                    row++;
                    if (row > 5000)
                        break;
                }
            }
            return results;
        }

        public static void SetField(Employee e, string key, string val)
        {
            if (e == null || string.IsNullOrEmpty(key))
                return;
            val = val == null ? string.Empty : val.Trim();
            if (val.Length == 0)
            {
                ClearField(e, key);
                return;
            }
            Assign(e, key, val);
        }

        static void ClearField(Employee e, string key)
        {
            switch (key)
            {
                case "firstName": e.FirstName = null; break;
                case "lastName": e.LastName = null; break;
                case "fatherName": e.FatherName = null; break;
                case "nationalId": e.NationalId = null; break;
                case "idBookletNumber": e.IdBookletNumber = null; break;
                case "birthDate": e.BirthDate = null; break;
                case "birthPlace": e.BirthPlace = null; break;
                case "serviceCity": e.ServiceCity = null; break;
                case "veteranStatus": e.VeteranStatus = null; break;
                case "iban1": e.Iban1 = null; break;
                case "iban2": e.Iban2 = null; break;
                case "gender": e.Gender = null; break;
                case "maritalStatus": e.MaritalStatus = null; break;
                case "childrenCount": e.ChildrenCount = 0; break;
                case "bloodGroup": e.BloodGroup = null; break;
                case "militaryStatus": e.MilitaryStatus = null; break;
                case "personalDescription": e.PersonalDescription = null; break;
                case "employeeNumber": e.EmployeeNumber = null; break;
                case "subscriptionNumber": e.SubscriptionNumber = null; break;
                case "currentPosition": e.CurrentPosition = null; break;
                case "previousPosition": e.PreviousPosition = null; break;
                case "desiredPosition": e.DesiredPosition = null; break;
                case "personType": e.PersonType = HrLookups.PersonStaff; break;
                case "employmentType": e.EmploymentType = null; break;
                case "jobGroup": e.JobGroup = null; break;
                case "positionBase": e.PositionBase = null; break;
                case "personalBase": e.PersonalBase = null; break;
                case "employmentDate": e.EmploymentDate = null; break;
                case "retirementDate": e.RetirementDate = null; break;
                case "employmentStatus": e.EmploymentStatus = "active"; break;
                case "inactiveReason": e.InactiveReason = null; break;
                case "primaryPhone": e.PrimaryPhone = null; break;
                case "secondaryPhone": e.SecondaryPhone = null; break;
                case "emergencyPhone": e.EmergencyPhone = null; break;
                case "email": e.Email = null; break;
                case "homeAddress": e.HomeAddress = null; break;
                case "postalCode": e.PostalCode = null; break;
                case "telegram": e.Telegram = null; break;
                case "whatsapp": e.Whatsapp = null; break;
                case "instagram": e.Instagram = null; break;
                case "linkedin": e.Linkedin = null; break;
                case "educationLevel": e.EducationLevel = null; break;
                case "major": e.Major = null; break;
                case "university": e.University = null; break;
                case "skillName": e.SkillName = null; break;
                case "skillLevel": e.SkillLevel = null; break;
                case "insuranceNumber": e.InsuranceNumber = null; break;
                case "insuranceType": e.InsuranceType = null; break;
            }
        }

        static void Assign(Employee e, string key, string val)
        {
            if (string.IsNullOrEmpty(val))
                return;
            switch (key)
            {
                case "firstName": e.FirstName = val; break;
                case "lastName": e.LastName = val; break;
                case "fatherName": e.FatherName = val; break;
                case "nationalId": e.NationalId = val; break;
                case "idBookletNumber": e.IdBookletNumber = val; break;
                case "birthDate": e.BirthDate = val; break;
                case "birthPlace": e.BirthPlace = val; break;
                case "serviceCity": e.ServiceCity = val; break;
                case "veteranStatus": e.VeteranStatus = val; break;
                case "iban1": e.Iban1 = IranianIban.Normalize(val); break;
                case "iban2": e.Iban2 = IranianIban.Normalize(val); break;
                case "gender": e.Gender = HrLookups.NormalizeGender(val) ?? val; break;
                case "maritalStatus": e.MaritalStatus = val; break;
                case "childrenCount":
                    int n; int.TryParse(val, out n); e.ChildrenCount = n; break;
                case "bloodGroup": e.BloodGroup = val; break;
                case "militaryStatus": e.MilitaryStatus = val; break;
                case "employeeNumber": e.EmployeeNumber = val; break;
                case "subscriptionNumber": e.SubscriptionNumber = val; break;
                case "currentPosition": e.CurrentPosition = val; break;
                case "previousPosition": e.PreviousPosition = val; break;
                case "desiredPosition": e.DesiredPosition = val; break;
                case "personType": e.PersonType = HrLookups.NormalizePersonType(
                    string.Equals(val, "کارگر", StringComparison.Ordinal) ? "worker"
                    : string.Equals(val, "کارمند", StringComparison.Ordinal) ? "staff" : val); break;
                case "employmentType": e.EmploymentType = val; break;
                case "jobGroup": e.JobGroup = val; break;
                case "positionBase":
                    {
                        double pb;
                        if (double.TryParse(val.Replace(',', '.'), System.Globalization.NumberStyles.Any,
                            System.Globalization.CultureInfo.InvariantCulture, out pb))
                            e.PositionBase = pb;
                        break;
                    }
                case "personalBase":
                    {
                        double psb;
                        if (double.TryParse(val.Replace(',', '.'), System.Globalization.NumberStyles.Any,
                            System.Globalization.CultureInfo.InvariantCulture, out psb))
                            e.PersonalBase = psb;
                        break;
                    }
                case "employmentDate": e.EmploymentDate = val; break;
                case "retirementDate": e.RetirementDate = val; break;
                case "employmentStatus": e.EmploymentStatus = val.Contains("غیر") ? "inactive" : "active"; break;
                case "inactiveReason": e.InactiveReason = val; break;
                case "primaryPhone": e.PrimaryPhone = val; break;
                case "secondaryPhone": e.SecondaryPhone = val; break;
                case "emergencyPhone": e.EmergencyPhone = val; break;
                case "email": e.Email = val; break;
                case "homeAddress": e.HomeAddress = val; break;
                case "postalCode": e.PostalCode = val; break;
                case "telegram": e.Telegram = val; break;
                case "whatsapp": e.Whatsapp = val; break;
                case "instagram": e.Instagram = val; break;
                case "linkedin": e.Linkedin = val; break;
                case "personalDescription": e.PersonalDescription = val; break;
                case "educationLevel": e.EducationLevel = val; break;
                case "major": e.Major = val; break;
                case "university": e.University = val; break;
                case "skillName": e.SkillName = val; break;
                case "skillLevel": e.SkillLevel = val; break;
                case "insuranceNumber": e.InsuranceNumber = val; break;
                case "insuranceType": e.InsuranceType = val; break;
            }
        }

        static string NormalizeHeader(string h)
        {
            switch (h)
            {
                case "نام": case "first_name": return "firstName";
                case "نام خانوادگی": case "last_name": return "lastName";
                case "نام پدر": return "fatherName";
                case "کد ملی": case "national_id": return "nationalId";
                case "شماره شناسنامه": return "idBookletNumber";
                case "تاریخ تولد": return "birthDate";
                case "محل تولد": return "birthPlace";
                case "شهر محل خدمت": return "serviceCity";
                case "وضعیت ایثارگری": case "ایثارگری": return "veteranStatus";
                case "جنسیت": return "gender";
                case "وضعیت تأهل": case "وضعیت تاهل": return "maritalStatus";
                case "تعداد فرزندان": return "childrenCount";
                case "گروه خونی": return "bloodGroup";
                case "وضعیت نظام وظیفه": return "militaryStatus";
                case "شماره پرسنلی": return "employeeNumber";
                case "شماره اشتراک": return "subscriptionNumber";
                case "سمت فعلی": return "currentPosition";
                case "سمت قبلی": return "previousPosition";
                case "سمت مورد علاقه":
                case "سمت موردعلاقه":
                case "سمت حین خدمت (فیزیکی)":
                case "سمت حین خدمت":
                    return "desiredPosition";
                case "نوع پرسنل": return "personType";
                case "نوع استخدام": return "employmentType";
                case "گروه شغلی": return "jobGroup";
                case "پایه شماره سمت": return "positionBase";
                case "پایه شخصی": return "personalBase";
                case "تاریخ استخدام": return "employmentDate";
                case "تاریخ بازنشستگی": return "retirementDate";
                case "وضعیت اشتغال": return "employmentStatus";
                case "دلیل غیرفعال‌سازی":
                case "دلیل غیرفعال سازی":
                    return "inactiveReason";
                case "تلفن اصلی": case "تلفن": return "primaryPhone";
                case "تلفن دوم": return "secondaryPhone";
                case "تلفن اضطراری": return "emergencyPhone";
                case "ایمیل": return "email";
                case "آدرس": return "homeAddress";
                case "کد پستی": return "postalCode";
                case "شماره شبا ۱": case "شماره شبا 1": case "شبا ۱": case "شبا 1": case "iban1": return "iban1";
                case "شماره شبا ۲": case "شماره شبا 2": case "شبا ۲": case "شبا 2": case "iban2": return "iban2";
                case "تلگرام": return "telegram";
                case "واتساپ": return "whatsapp";
                case "اینستاگرام": return "instagram";
                case "لینکدین": return "linkedin";
                case "توضیحات": return "personalDescription";
                case "مقطع تحصیلی": return "educationLevel";
                case "رشته": return "major";
                case "دانشگاه": return "university";
                case "مهارت": return "skillName";
                case "سطح مهارت": return "skillLevel";
                case "شماره بیمه": return "insuranceNumber";
                case "نوع بیمه": return "insuranceType";
                default: return h;
            }
        }

        public static string GetField(Employee e, string key)
        {
            if (e == null || string.IsNullOrEmpty(key))
                return string.Empty;
            switch (key)
            {
                case "firstName": return e.FirstName ?? "";
                case "lastName": return e.LastName ?? "";
                case "fatherName": return e.FatherName ?? "";
                case "nationalId": return e.NationalId ?? "";
                case "idBookletNumber": return e.IdBookletNumber ?? "";
                case "birthDate": return e.BirthDate ?? "";
                case "birthPlace": return e.BirthPlace ?? "";
                case "serviceCity": return e.ServiceCity ?? "";
                case "veteranStatus": return e.VeteranStatus ?? "";
                case "iban1": return IranianIban.FormatDisplay(e.Iban1);
                case "iban2": return IranianIban.FormatDisplay(e.Iban2);
                case "gender": return e.Gender ?? "";
                case "maritalStatus": return e.MaritalStatus ?? "";
                case "childrenCount": return e.ChildrenCount.ToString();
                case "bloodGroup": return e.BloodGroup ?? "";
                case "militaryStatus": return e.MilitaryStatus ?? "";
                case "personalDescription": return e.PersonalDescription ?? "";
                case "employeeNumber": return e.EmployeeNumber ?? "";
                case "subscriptionNumber": return e.SubscriptionNumber ?? "";
                case "currentPosition": return e.CurrentPosition ?? "";
                case "previousPosition": return e.PreviousPosition ?? "";
                case "desiredPosition": return e.DesiredPosition ?? "";
                case "personType": return HrLookups.PersonTypeFa(e.PersonType);
                case "employmentType": return e.EmploymentType ?? "";
                case "jobGroup": return e.JobGroup ?? "";
                case "positionBase": return e.PositionBase.HasValue ? e.PositionBase.Value.ToString(System.Globalization.CultureInfo.InvariantCulture) : "";
                case "personalBase": return e.PersonalBase.HasValue ? e.PersonalBase.Value.ToString(System.Globalization.CultureInfo.InvariantCulture) : "";
                case "employmentDate": return e.EmploymentDate ?? "";
                case "retirementDate": return e.RetirementDate ?? "";
                case "employmentStatus": return e.EmploymentStatus == "inactive" ? "غیرفعال" : "فعال";
                case "inactiveReason": return e.InactiveReason ?? "";
                case "primaryPhone": return e.PrimaryPhone ?? "";
                case "secondaryPhone": return e.SecondaryPhone ?? "";
                case "emergencyPhone": return e.EmergencyPhone ?? "";
                case "email": return e.Email ?? "";
                case "homeAddress": return e.HomeAddress ?? "";
                case "postalCode": return e.PostalCode ?? "";
                case "telegram": return e.Telegram ?? "";
                case "whatsapp": return e.Whatsapp ?? "";
                case "instagram": return e.Instagram ?? "";
                case "linkedin": return e.Linkedin ?? "";
                case "educationLevel": return e.EducationLevel ?? "";
                case "major": return e.Major ?? "";
                case "university": return e.University ?? "";
                case "skillName": return e.SkillName ?? "";
                case "skillLevel": return e.SkillLevel ?? "";
                case "insuranceNumber": return e.InsuranceNumber ?? "";
                case "insuranceType": return e.InsuranceType ?? "";
                default: return string.Empty;
            }
        }

        public static List<string> ValidateEmployee(Employee e)
        {
            var errors = new List<string>();
            if (e == null)
            {
                errors.Add("ردیف خالی");
                return errors;
            }
            if (string.IsNullOrWhiteSpace(e.FirstName) || string.IsNullOrWhiteSpace(e.LastName))
                errors.Add("نام ناقص");
            if (!IranianNationalId.IsValid(e.NationalId ?? ""))
                errors.Add("کد ملی نامعتبر");
            if (!string.IsNullOrWhiteSpace(e.BirthDate))
            {
                var birth = PersianDate.Normalize(e.BirthDate);
                if (birth == null)
                    errors.Add("تاریخ تولد نامعتبر");
                else
                    e.BirthDate = birth;
            }
            if (!string.IsNullOrWhiteSpace(e.EmploymentDate))
            {
                var hired = PersianDate.Normalize(e.EmploymentDate);
                if (hired == null)
                    errors.Add("تاریخ استخدام نامعتبر");
                else
                    e.EmploymentDate = hired;
            }
            e.EmploymentType = HrLookups.NormalizeEmploymentType(e.EmploymentType) ?? e.EmploymentType;
            var baseErr = HrLookups.ValidateOfficialBases(e.EmploymentType, e.PositionBase, e.PersonalBase);
            if (baseErr != null)
                errors.Add(baseErr);
            var jgErr = HrLookups.ValidateThirdPillarJobGroup(e.EmploymentType, e.JobGroup);
            if (jgErr != null)
                errors.Add(jgErr);
            return errors;
        }

        public static List<ReportColumn> Catalog()
        {
            return new List<ReportColumn>
            {
                C("firstName","نام","هویت", false), C("lastName","نام خانوادگی","هویت", false),
                C("fullName","نام کامل","هویت", true), C("photo","عکس ۴×۳","هویت", false), C("fatherName","نام پدر","هویت", false),
                C("nationalId","کد ملی","هویت", true), C("idBookletNumber","شماره شناسنامه","هویت", false),
                C("birthDate","تاریخ تولد","هویت", false),
                C("birthPlace","محل تولد","هویت", false), C("veteranStatus","وضعیت ایثارگری","هویت", false),
                C("gender","جنسیت","هویت", false),
                C("maritalStatus","تأهل","هویت", false), C("childrenCount","تعداد فرزند","هویت", false),
                C("bloodGroup","گروه خون","هویت", false), C("militaryStatus","نظام‌وظیفه","هویت", false),
                C("personalDescription","توضیحات","هویت", false),
                C("employeeNumber","شماره پرسنلی","سازمانی", true), C("subscriptionNumber","شماره اشتراک","سازمانی", false),
                C("serviceCity","شهر محل خدمت","سازمانی", false),
                C("position","سمت فعلی","سازمانی", true), C("previousPosition","سمت قبلی","سازمانی", false),
                C("desiredPosition","سمت حین خدمت (فیزیکی)","سازمانی", false),
                C("personType","نوع پرسنل","سازمانی", true),
                C("employmentType","نوع استخدام","سازمانی", false),
                C("jobGroup","گروه شغلی","سازمانی", false), C("positionBase","پایه شماره سمت","سازمانی", false),
                C("personalBase","پایه شخصی","سازمانی", false),
                C("employmentDate","تاریخ استخدام","سازمانی", false),
                C("retirementDate","تاریخ بازنشستگی","سازمانی", false),
                C("status","وضعیت اشتغال","سازمانی", true),
                C("inactiveReason","دلیل غیرفعال‌سازی","سازمانی", false),
                C("phone","تلفن اصلی","تماس", true), C("secondaryPhone","تلفن دوم","تماس", false),
                C("emergencyPhone","تلفن اضطراری","تماس", false), C("email","ایمیل","تماس", false),
                C("address","آدرس","تماس", false), C("postalCode","کد پستی","تماس", false),
                C("iban1","شماره شبا ۱","تماس", false), C("iban2","شماره شبا ۲","تماس", false),
                C("telegram","تلگرام","شبکه‌ها", false), C("whatsapp","واتساپ","شبکه‌ها", false),
                C("instagram","اینستاگرام","شبکه‌ها", false), C("linkedin","لینکدین","شبکه‌ها", false),
                C("educationLevel","مقطع تحصیلی","تحصیلات", false), C("major","رشته","تحصیلات", false),
                C("university","دانشگاه","تحصیلات", false),
                C("skillName","مهارت","تحصیلات", false), C("skillLevel","سطح مهارت","تحصیلات", false),
                C("insuranceNumber","شماره بیمه","تحصیلات", false), C("insuranceType","نوع بیمه","تحصیلات", false),
                C("docBirth","شناسنامه","اسناد", false), C("docNational","کارت ملی","اسناد", false),
                C("docOther","سایر اسناد","اسناد", false)
            };
        }

        public static string CellValue(Employee e, string key)
        {
            if (e == null)
                return string.Empty;
            switch (key)
            {
                case "firstName": return Nz(e.FirstName);
                case "lastName": return Nz(e.LastName);
                case "fullName": return Nz(e.FullName);
                case "fatherName": return Nz(e.FatherName);
                case "nationalId": return Nz(e.NationalId);
                case "idBookletNumber": return Nz(e.IdBookletNumber);
                case "birthDate": return PersianDate.DigitsFa(Nz(e.BirthDate));
                case "birthPlace": return Nz(e.BirthPlace);
                case "serviceCity": return Nz(e.ServiceCity);
                case "veteranStatus": return Nz(e.VeteranStatus);
                case "iban1": return IranianIban.FormatDisplay(e.Iban1);
                case "iban2": return IranianIban.FormatDisplay(e.Iban2);
                case "gender": return MapGender(e.Gender);
                case "maritalStatus": return MapMarital(e.MaritalStatus);
                case "childrenCount": return e.ChildrenCount.ToString();
                case "bloodGroup": return Nz(e.BloodGroup);
                case "militaryStatus": return HrLookups.MilitaryFa(e.MilitaryStatus);
                case "personalDescription": return Nz(e.PersonalDescription);
                case "employeeNumber": return Nz(e.EmployeeNumber);
                case "subscriptionNumber": return Nz(e.SubscriptionNumber);
                case "position": return Nz(e.CurrentPosition);
                case "previousPosition": return Nz(e.PreviousPosition);
                case "desiredPosition": return Nz(e.DesiredPosition);
                case "personType": return HrLookups.PersonTypeFa(e.PersonType);
                case "employmentType": return Nz(e.EmploymentType);
                case "jobGroup": return Nz(e.JobGroup);
                case "positionBase": return e.PositionBase.HasValue ? e.PositionBase.Value.ToString("0.##") : "";
                case "personalBase": return e.PersonalBase.HasValue ? e.PersonalBase.Value.ToString("0.##") : "";
                case "employmentDate": return PersianDate.DigitsFa(Nz(e.EmploymentDate));
                case "retirementDate": return PersianDate.DigitsFa(Nz(e.RetirementDate));
                case "status": return Nz(e.StatusFa);
                case "inactiveReason": return Nz(e.InactiveReasonFa);
                case "phone": return Nz(e.PrimaryPhone);
                case "secondaryPhone": return Nz(e.SecondaryPhone);
                case "emergencyPhone": return Nz(e.EmergencyPhone);
                case "email": return Nz(e.Email);
                case "address": return Nz(e.HomeAddress);
                case "postalCode": return Nz(e.PostalCode);
                case "telegram": return Nz(e.Telegram);
                case "whatsapp": return Nz(e.Whatsapp);
                case "instagram": return Nz(e.Instagram);
                case "linkedin": return Nz(e.Linkedin);
                case "educationLevel": return Nz(e.EducationLevel);
                case "major": return Nz(e.Major);
                case "university": return Nz(e.University);
                case "skillName": return Nz(e.SkillName);
                case "skillLevel": return Nz(e.SkillLevel);
                case "insuranceNumber": return Nz(e.InsuranceNumber);
                case "insuranceType": return Nz(e.InsuranceType);
                case "photo": return EmployeePhotoStore.Exists(e.PhotoPath) ? "دارد" : "";
                case "docBirth": return DocumentKinds.Summary(e, DocumentKinds.Birth);
                case "docNational": return DocumentKinds.Summary(e, DocumentKinds.National);
                case "docOther": return DocumentKinds.Summary(e, DocumentKinds.Other);
                default: return string.Empty;
            }
        }

        public static float ColumnFlex(string key)
        {
            switch (key)
            {
                case "nationalId":
                case "employeeNumber":
                case "gender":
                case "childrenCount":
                case "bloodGroup":
                case "status":
                case "postalCode":
                    return 0.7f;
                case "birthDate":
                case "employmentDate":
                case "phone":
                case "secondaryPhone":
                    return 0.9f;
                case "photo":
                    return 0.8f;
                case "docBirth":
                case "docNational":
                case "docOther":
                    return 1.2f;
                case "fullName":
                case "position":
                case "previousPosition":
                case "desiredPosition":
                case "email":
                    return 1.4f;
                case "address":
                case "personalDescription":
                    return 1.8f;
                default:
                    return 1f;
            }
        }

        static string Nz(string s)
        {
            return s ?? string.Empty;
        }

        static string MapGender(string g)
        {
            var n = HrLookups.NormalizeGender(g);
            if (n != null)
                return n;
            return Nz(g);
        }

        static string MapMarital(string m)
        {
            if (m == "single") return "مجرد";
            if (m == "married") return "متأهل";
            if (m == "divorced") return "مطلقه";
            if (m == "widowed") return "بیوه";
            return Nz(m);
        }

        public static List<ReportColumn> SelectedForExport(IList<ReportColumn> columns, ReportExportOptions options)
        {
            var list = Selected(columns);
            if (options != null && options.ShowPhotos && !list.Exists(c => c.Key == "photo"))
                list.Insert(0, new ReportColumn { Key = "photo", TitleFa = "عکس ۴×۳", Group = "هویت", Selected = true });
            if (options != null && options.ShowDocuments)
            {
                EnsureColumn(list, "docBirth", "شناسنامه", "اسناد");
                EnsureColumn(list, "docNational", "کارت ملی", "اسناد");
                EnsureColumn(list, "docOther", "سایر اسناد", "اسناد");
            }
            return list;
        }

        static void EnsureColumn(List<ReportColumn> list, string key, string title, string group)
        {
            if (list.Exists(c => c.Key == key))
                return;
            list.Add(new ReportColumn { Key = key, TitleFa = title, Group = group, Selected = true });
        }

        static bool IsPictureColumn(string key)
        {
            return key == "photo";
        }

        static void WriteDocViewCell(IXLCell cell, Employee person, string key, DocumentRepository repo, string reportPath)
        {
            var rel = ReportDocPack.ExportFirst(person, key, repo, reportPath);
            if (string.IsNullOrEmpty(rel))
            {
                cell.Value = "—";
                return;
            }
            var abs = ReportDocPack.AbsoluteFromRelative(reportPath, rel);
            cell.Value = "مشاهده";
            cell.Style.Font.Bold = true;
            cell.Style.Font.FontColor = XLColor.FromArgb(0x0B, 0x4A, 0x6F);
            cell.Style.Font.Underline = XLFontUnderlineValues.Single;
            cell.Style.Fill.BackgroundColor = XLColor.FromArgb(0xE8, 0xF0, 0xF5);
            if (string.IsNullOrEmpty(abs) || !File.Exists(abs))
                return;
            var relative = (rel ?? "").Replace('\\', '/');
            try
            {
                var hyper = new XLHyperlink(new Uri(relative, UriKind.Relative));
                hyper.IsExternal = true;
                hyper.Tooltip = abs;
                cell.SetHyperlink(hyper);
            }
            catch
            {
                try
                {
                    var hyper = new XLHyperlink(new Uri(abs));
                    hyper.IsExternal = true;
                    hyper.Tooltip = abs;
                    cell.SetHyperlink(hyper);
                }
                catch
                {
                }
            }
        }

        static byte[] PictureBytes(Employee e, string key)
        {
            if (key == "photo")
                return EmployeePhotoStore.Read(e == null ? null : e.PhotoPath);
            var kind = DocumentKinds.KindFromColumn(key);
            return kind == null ? null : DocumentKinds.Preview(e, kind);
        }

        static byte[] PictureBytesCached(Employee e, string key, Dictionary<string, byte[]> cache, int maxW, int maxH)
        {
            if (key != "photo")
                return PictureBytes(e, key);
            var path = e == null ? null : e.PhotoPath;
            if (string.IsNullOrWhiteSpace(path))
                return null;
            byte[] cached;
            if (cache != null && cache.TryGetValue(path, out cached))
                return cached;
            var raw = EmployeePhotoStore.Read(path);
            var thumb = ReportImageUtil.ThumbnailJpeg(raw, maxW, maxH, 80L);
            if (cache != null)
                cache[path] = thumb;
            return thumb;
        }

        static double HeuristicExcelWidth(string key)
        {
            switch (key)
            {
                case "address":
                case "personalDescription":
                    return 32;
                case "fullName":
                case "position":
                case "previousPosition":
                case "desiredPosition":
                case "university":
                case "major":
                    return 22;
                case "email":
                case "linkedin":
                    return 28;
                case "nationalId":
                case "birthDate":
                case "employmentDate":
                case "retirementDate":
                case "phone":
                case "secondaryPhone":
                case "emergencyPhone":
                case "employeeNumber":
                case "subscriptionNumber":
                case "postalCode":
                case "insuranceNumber":
                case "iban1":
                case "iban2":
                    return 16;
                case "telegram":
                case "whatsapp":
                case "instagram":
                    return 18;
                default:
                    return 14;
            }
        }

        static string PictureFallback(Employee e, string key)
        {
            if (key == "photo")
                return "—";
            var text = CellValue(e, key);
            return string.IsNullOrWhiteSpace(text) ? "—" : text;
        }

        static List<ReportColumn> Selected(IList<ReportColumn> columns)
        {
            var list = new List<ReportColumn>();
            if (columns == null)
                return Catalog().FindAll(c => c.Selected);
            foreach (var c in columns)
                if (c.Selected) list.Add(c);
            return list.Count == 0 ? Catalog().FindAll(c => c.Selected) : list;
        }

        static ReportColumn C(string key, string fa, string g, bool sel)
        {
            return new ReportColumn { Key = key, TitleFa = fa, Group = g, Selected = sel };
        }
    }
}
