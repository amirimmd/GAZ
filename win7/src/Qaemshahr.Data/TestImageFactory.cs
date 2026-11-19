using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.Drawing.Text;
using System.IO;

namespace Qaemshahr.Data
{
    /// <summary>تولید JPEG ساختگی با ابعاد استاندارد اداری برای تست.</summary>
    public static class TestImageFactory
    {
        public static byte[] Portrait3x4(string fullName, bool female, int seed)
        {
            // نسبت ۳×۴ رسمی برنامه: 360×480
            var w = EmployeePhotoStore.TargetWidth;
            var h = EmployeePhotoStore.TargetHeight;
            var rng = new Random(seed);
            using (var bmp = new Bitmap(w, h, PixelFormat.Format24bppRgb))
            using (var g = Graphics.FromImage(bmp))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                var bg = female
                    ? Color.FromArgb(243, 232, 239)
                    : Color.FromArgb(228, 238, 245);
                g.Clear(bg);

                var accent = female
                    ? Color.FromArgb(142, 69, 109)
                    : Color.FromArgb(11, 74, 111);
                using (var brush = new SolidBrush(accent))
                {
                    // سر
                    g.FillEllipse(brush, w / 2 - 70, 70, 140, 140);
                    // شانه / لباس
                    if (female)
                        g.FillPolygon(brush, new[]
                        {
                            new Point(w / 2 - 110, h - 40),
                            new Point(w / 2 + 110, h - 40),
                            new Point(w / 2 + 70, 250),
                            new Point(w / 2 - 70, 250)
                        });
                    else
                        g.FillRectangle(brush, w / 2 - 95, 250, 190, h - 250);
                }

                using (var white = new SolidBrush(Color.White))
                using (var font = new Font("Tahoma", 16, FontStyle.Bold, GraphicsUnit.Pixel))
                {
                    var label = Trunc(fullName, 18);
                    var size = g.MeasureString(label, font);
                    g.FillRectangle(new SolidBrush(Color.FromArgb(180, 0, 0, 0)),
                        8, h - 46, w - 16, 34);
                    g.DrawString(label, font, white, (w - size.Width) / 2f, h - 40);
                }

                // نویز جزئی برای واقعی‌تر بودن
                for (var i = 0; i < 40; i++)
                {
                    var c = Color.FromArgb(25, rng.Next(256), rng.Next(256), rng.Next(256));
                    using (var p = new Pen(c))
                        g.DrawEllipse(p, rng.Next(0, w), rng.Next(0, h), 2, 2);
                }

                return EncodeJpeg(bmp, 90L);
            }
        }

        public static byte[] BirthCertificate(string fullName, string nationalId, string father, string birthDate, int seed)
        {
            // صفحه شناسنامه تقریبی A5 عمودی
            const int w = 1000, h = 1400;
            using (var bmp = new Bitmap(w, h, PixelFormat.Format24bppRgb))
            using (var g = Graphics.FromImage(bmp))
            {
                g.Clear(Color.FromArgb(252, 248, 236));
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                using (var border = new Pen(Color.FromArgb(120, 90, 40), 4))
                    g.DrawRectangle(border, 24, 24, w - 48, h - 48);
                using (var titleFont = new Font("Tahoma", 36, FontStyle.Bold, GraphicsUnit.Pixel))
                using (var body = new Font("Tahoma", 22, FontStyle.Regular, GraphicsUnit.Pixel))
                using (var brush = new SolidBrush(Color.FromArgb(60, 40, 20)))
                {
                    DrawRtl(g, "شناسنامه جمهوری اسلامی ایران", titleFont, brush, w / 2f, 80, true);
                    DrawRtl(g, "نام و نام خانوادگی: " + fullName, body, brush, w - 80, 220, false);
                    DrawRtl(g, "نام پدر: " + (father ?? "—"), body, brush, w - 80, 290, false);
                    DrawRtl(g, "کد ملی: " + nationalId, body, brush, w - 80, 360, false);
                    DrawRtl(g, "تاریخ تولد: " + birthDate, body, brush, w - 80, 430, false);
                    DrawRtl(g, "محل صدور: قائم‌شهر — مازندران", body, brush, w - 80, 500, false);
                    DrawRtl(g, "نمونه تستی — فاقد اعتبار حقوقی", body, brush, w - 80, h - 120, false);
                }
                Stamp(g, w - 220, h - 320, seed);
                return EncodeJpeg(bmp, 85L);
            }
        }

        public static byte[] NationalCard(string fullName, string nationalId, string birthDate, bool female, int seed)
        {
            // کارت ملی تقریبی نسبت کارت بانکی ~1.586
            const int w = 1012, h = 638;
            using (var bmp = new Bitmap(w, h, PixelFormat.Format24bppRgb))
            using (var g = Graphics.FromImage(bmp))
            {
                g.Clear(Color.FromArgb(230, 242, 255));
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                using (var header = new LinearGradientBrush(
                    new Rectangle(0, 0, w, 90),
                    Color.FromArgb(11, 74, 111),
                    Color.FromArgb(26, 106, 150),
                    0f))
                    g.FillRectangle(header, 0, 0, w, 90);
                using (var white = new SolidBrush(Color.White))
                using (var title = new Font("Tahoma", 28, FontStyle.Bold, GraphicsUnit.Pixel))
                    DrawRtl(g, "کارت ملی هوشمند", title, white, w / 2f, 28, true);

                // جای عکس ۳×۴ کوچک روی کارت
                using (var photo = new Bitmap(new MemoryStream(Portrait3x4(fullName, female, seed))))
                    g.DrawImage(photo, 40, 120, 150, 200);
                using (var box = new Pen(Color.FromArgb(11, 74, 111), 2))
                    g.DrawRectangle(box, 40, 120, 150, 200);

                using (var body = new Font("Tahoma", 22, FontStyle.Regular, GraphicsUnit.Pixel))
                using (var brush = new SolidBrush(Color.FromArgb(20, 40, 60)))
                {
                    DrawRtl(g, fullName, body, brush, w - 40, 140, false);
                    DrawRtl(g, "کد ملی: " + nationalId, body, brush, w - 40, 200, false);
                    DrawRtl(g, "تولد: " + birthDate, body, brush, w - 40, 260, false);
                    DrawRtl(g, "جنسیت: " + (female ? "خانم" : "آقا"), body, brush, w - 40, 320, false);
                }
                Stamp(g, w - 180, h - 140, seed + 7);
                return EncodeJpeg(bmp, 88L);
            }
        }

        public static byte[] MilitaryCard(string fullName, string nationalId, string status, int seed)
        {
            const int w = 1200, h = 850;
            using (var bmp = new Bitmap(w, h, PixelFormat.Format24bppRgb))
            using (var g = Graphics.FromImage(bmp))
            {
                g.Clear(Color.FromArgb(245, 250, 245));
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                using (var border = new Pen(Color.FromArgb(0, 90, 50), 5))
                    g.DrawRectangle(border, 20, 20, w - 40, h - 40);
                using (var title = new Font("Tahoma", 34, FontStyle.Bold, GraphicsUnit.Pixel))
                using (var body = new Font("Tahoma", 24, FontStyle.Regular, GraphicsUnit.Pixel))
                using (var brush = new SolidBrush(Color.FromArgb(0, 60, 35)))
                {
                    var heading = string.Equals(status, "مشمول نیست", StringComparison.Ordinal)
                        ? "گواهی وضعیت نظام وظیفه"
                        : "کارت پایان خدمت دوره ضرورت";
                    DrawRtl(g, heading, title, brush, w / 2f, 70, true);
                    DrawRtl(g, "نام: " + fullName, body, brush, w - 80, 200, false);
                    DrawRtl(g, "کد ملی: " + nationalId, body, brush, w - 80, 280, false);
                    DrawRtl(g, "وضعیت: " + (status ?? "پایان خدمت"), body, brush, w - 80, 360, false);
                    DrawRtl(g, "محل خدمت: یگان نمونه — مازندران", body, brush, w - 80, 440, false);
                    DrawRtl(g, "سند تستی سامانه منابع انسانی قائم‌شهر", body, brush, w - 80, h - 100, false);
                }
                Stamp(g, 120, h - 220, seed + 13);
                return EncodeJpeg(bmp, 85L);
            }
        }

        public static byte[] GroupCover(string title, int seed)
        {
            const int w = 720, h = 420;
            var rng = new Random(seed);
            var palettes = new[]
            {
                new[] { Color.FromArgb(11, 74, 111), Color.FromArgb(26, 106, 150), Color.FromArgb(196, 30, 58) },
                new[] { Color.FromArgb(27, 94, 32), Color.FromArgb(56, 142, 60), Color.FromArgb(255, 193, 7) },
                new[] { Color.FromArgb(74, 20, 140), Color.FromArgb(123, 31, 162), Color.FromArgb(0, 151, 167) },
                new[] { Color.FromArgb(191, 54, 12), Color.FromArgb(230, 81, 0), Color.FromArgb(11, 74, 111) },
                new[] { Color.FromArgb(1, 87, 155), Color.FromArgb(2, 136, 209), Color.FromArgb(0, 105, 92) },
                new[] { Color.FromArgb(62, 39, 35), Color.FromArgb(109, 76, 65), Color.FromArgb(255, 171, 64) }
            };
            var pal = palettes[Math.Abs(seed) % palettes.Length];
            using (var bmp = new Bitmap(w, h, PixelFormat.Format24bppRgb))
            using (var g = Graphics.FromImage(bmp))
            {
                g.SmoothingMode = SmoothingMode.AntiAlias;
                g.TextRenderingHint = TextRenderingHint.ClearTypeGridFit;
                using (var brush = new LinearGradientBrush(
                    new Rectangle(0, 0, w, h), pal[0], pal[1], 35f + rng.Next(40)))
                    g.FillRectangle(brush, 0, 0, w, h);

                using (var accent = new SolidBrush(Color.FromArgb(70, pal[2])))
                {
                    g.FillEllipse(accent, -80, -60, 280, 280);
                    g.FillEllipse(accent, w - 220, h - 200, 320, 260);
                }
                using (var soft = new SolidBrush(Color.FromArgb(40, Color.White)))
                {
                    g.FillEllipse(soft, w / 2 - 40, 30, 180, 120);
                    g.FillRectangle(soft, 40, h - 90, w - 80, 50);
                }

                // آیکون گروهی ساده (۳ نفر)
                using (var white = new SolidBrush(Color.FromArgb(230, Color.White)))
                {
                    g.FillEllipse(white, 56, 48, 36, 36);
                    g.FillEllipse(white, 96, 40, 44, 44);
                    g.FillEllipse(white, 144, 48, 36, 36);
                    g.FillEllipse(white, 48, 88, 52, 36);
                    g.FillEllipse(white, 90, 86, 60, 40);
                    g.FillEllipse(white, 140, 88, 52, 36);
                }

                using (var white = new SolidBrush(Color.White))
                using (var font = new Font("Tahoma", 30, FontStyle.Bold, GraphicsUnit.Pixel))
                using (var sub = new Font("Tahoma", 16, FontStyle.Regular, GraphicsUnit.Pixel))
                {
                    DrawRtl(g, Trunc(title, 26), font, white, w / 2f, h / 2f - 10, true);
                    DrawRtl(g, "گروه سازمانی", sub, white, w / 2f, h / 2f + 36, true);
                }
                return EncodeJpeg(bmp, 90L);
            }
        }

        static void Stamp(Graphics g, int x, int y, int seed)
        {
            var rng = new Random(seed);
            using (var pen = new Pen(Color.FromArgb(140, 160, 40, 40), 3))
            using (var font = new Font("Tahoma", 14, FontStyle.Bold, GraphicsUnit.Pixel))
            using (var brush = new SolidBrush(Color.FromArgb(140, 160, 40, 40)))
            {
                g.DrawEllipse(pen, x, y, 110, 110);
                g.DrawString("مهر تست", font, brush, x + 18, y + 42);
                g.DrawString((1400 + rng.Next(0, 6)).ToString(), font, brush, x + 30, y + 62);
            }
        }

        static void DrawRtl(Graphics g, string text, Font font, Brush brush, float x, float y, bool center)
        {
            var sf = new StringFormat(StringFormatFlags.DirectionRightToLeft)
            {
                Alignment = center ? StringAlignment.Center : StringAlignment.Near,
                LineAlignment = StringAlignment.Near
            };
            if (center)
                g.DrawString(text ?? "", font, brush, x, y, sf);
            else
                g.DrawString(text ?? "", font, brush, new RectangleF(40, y, x - 40, 60), sf);
        }

        static string Trunc(string s, int max)
        {
            s = (s ?? "").Trim();
            if (s.Length <= max)
                return s;
            return s.Substring(0, max - 1) + "…";
        }

        static byte[] EncodeJpeg(Bitmap bmp, long quality)
        {
            ImageCodecInfo codec = null;
            foreach (var c in ImageCodecInfo.GetImageEncoders())
            {
                if (c.FormatID == ImageFormat.Jpeg.Guid)
                {
                    codec = c;
                    break;
                }
            }
            using (var ms = new MemoryStream())
            {
                if (codec == null)
                {
                    bmp.Save(ms, ImageFormat.Jpeg);
                }
                else
                {
                    using (var ep = new EncoderParameters(1))
                    {
                        ep.Param[0] = new EncoderParameter(Encoder.Quality, quality);
                        bmp.Save(ms, codec, ep);
                    }
                }
                return ms.ToArray();
            }
        }
    }
}
