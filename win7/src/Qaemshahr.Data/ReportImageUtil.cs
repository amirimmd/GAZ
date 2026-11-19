using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

namespace Qaemshahr.Data
{
    /// <summary>کاهش حجم تصویر برای جاسازی در PDF/اکسل بدون تغییر ظاهر مقیاس‌شده.</summary>
    public static class ReportImageUtil
    {
        public static byte[] ThumbnailJpeg(byte[] source, int maxW, int maxH, long quality = 82L)
        {
            if (source == null || source.Length == 0 || maxW < 8 || maxH < 8)
                return source;
            try
            {
                using (var input = new MemoryStream(source))
                using (var src = Image.FromStream(input, false, false))
                {
                    int w;
                    int h;
                    Fit(src.Width, src.Height, maxW, maxH, out w, out h);
                    if (w >= src.Width && h >= src.Height && source.Length < 120 * 1024)
                        return source;
                    using (var dest = new Bitmap(w, h, PixelFormat.Format24bppRgb))
                    {
                        dest.SetResolution(96, 96);
                        using (var g = Graphics.FromImage(dest))
                        {
                            g.Clear(Color.White);
                            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            g.SmoothingMode = SmoothingMode.HighQuality;
                            g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                            g.DrawImage(src, 0, 0, w, h);
                        }
                        return EncodeJpeg(dest, quality);
                    }
                }
            }
            catch
            {
                return source;
            }
        }

        public static byte[] LoadScaledFile(string path, int maxEdge, long quality = 80L)
        {
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path) || maxEdge < 32)
                return null;
            try
            {
                using (var src = Image.FromFile(path))
                {
                    int w;
                    int h;
                    Fit(src.Width, src.Height, maxEdge, maxEdge, out w, out h);
                    using (var dest = new Bitmap(Math.Max(1, w), Math.Max(1, h), PixelFormat.Format24bppRgb))
                    {
                        dest.SetResolution(96, 96);
                        using (var g = Graphics.FromImage(dest))
                        {
                            g.Clear(Color.White);
                            g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                            g.DrawImage(src, 0, 0, w, h);
                        }
                        return EncodeJpeg(dest, quality);
                    }
                }
            }
            catch
            {
                try { return File.ReadAllBytes(path); }
                catch { return null; }
            }
        }

        static void Fit(int srcW, int srcH, int maxW, int maxH, out int w, out int h)
        {
            if (srcW < 1) srcW = 1;
            if (srcH < 1) srcH = 1;
            var sx = maxW / (double)srcW;
            var sy = maxH / (double)srcH;
            var s = Math.Min(1.0, Math.Min(sx, sy));
            w = Math.Max(1, (int)Math.Round(srcW * s));
            h = Math.Max(1, (int)Math.Round(srcH * s));
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
