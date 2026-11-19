using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using Qaemshahr.Core;

namespace Qaemshahr.Data
{
    public static class EmployeePhotoStore
    {
        public const int TargetWidth = 360;
        public const int TargetHeight = 480;
        const long JpegQuality = 88L;
        const int ExifOrientation = 0x0112;

        public static string RelativeFor(string employeeId)
        {
            return AppConstants.PhotosDir + "/" + employeeId + ".jpg";
        }

        public static string RelativeForGroup(string groupId)
        {
            return AppConstants.PhotosDir + "/groups/" + groupId + ".jpg";
        }

        public static string FullPath(string relative)
        {
            if (string.IsNullOrWhiteSpace(relative))
                return null;
            var clean = relative.Replace('/', Path.DirectorySeparatorChar).TrimStart('\\', '/');
            return Path.Combine(AppPaths.DataRoot, clean);
        }

        public static bool Exists(string relative)
        {
            var full = FullPath(relative);
            return !string.IsNullOrEmpty(full) && File.Exists(full);
        }

        public static byte[] Read(string relative)
        {
            var full = FullPath(relative);
            if (full == null || !File.Exists(full))
                return null;
            return File.ReadAllBytes(full);
        }

        public static string SaveJpeg(string employeeId, byte[] jpeg)
        {
            if (string.IsNullOrWhiteSpace(employeeId) || jpeg == null || jpeg.Length == 0)
                return null;
            return SaveRelativeJpeg(RelativeFor(employeeId), jpeg);
        }

        public static string SaveGroupJpeg(string groupId, byte[] jpeg)
        {
            if (string.IsNullOrWhiteSpace(groupId) || jpeg == null || jpeg.Length == 0)
                return null;
            return SaveRelativeJpeg(RelativeForGroup(groupId), jpeg);
        }

        static string SaveRelativeJpeg(string relative, byte[] jpeg)
        {
            if (string.IsNullOrWhiteSpace(relative) || jpeg == null || jpeg.Length == 0)
                return null;
            AppPaths.EnsureDataDirectories();
            var full = FullPath(relative);
            Directory.CreateDirectory(Path.GetDirectoryName(full));
            File.WriteAllBytes(full, jpeg);
            return relative;
        }

        public static byte[] FitFromFile(string sourcePath)
        {
            if (string.IsNullOrWhiteSpace(sourcePath) || !File.Exists(sourcePath))
                throw new InvalidOperationException("فایل عکس پیدا نشد.");
            var raw = File.ReadAllBytes(sourcePath);
            return FitFromBytes(raw);
        }

        public static byte[] FitFromBytes(byte[] raw)
        {
            if (raw == null || raw.Length == 0)
                throw new InvalidOperationException("عکس خالی است.");
            using (var input = new MemoryStream(raw))
            using (var src = Image.FromStream(input, true, true))
            using (var oriented = ApplyExif(src))
            using (var fitted = CropFit(oriented, TargetWidth, TargetHeight))
                return EncodeJpeg(fitted, JpegQuality);
        }

        public static void Delete(string relative)
        {
            try
            {
                var full = FullPath(relative);
                if (full != null && File.Exists(full))
                    File.Delete(full);
            }
            catch
            {
            }
        }

        static Bitmap ApplyExif(Image src)
        {
            var bmp = new Bitmap(src);
            try
            {
                if (Array.IndexOf(src.PropertyIdList, ExifOrientation) < 0)
                    return bmp;
                var prop = src.GetPropertyItem(ExifOrientation);
                if (prop == null || prop.Value == null || prop.Value.Length == 0)
                    return bmp;
                switch (prop.Value[0])
                {
                    case 2: bmp.RotateFlip(RotateFlipType.RotateNoneFlipX); break;
                    case 3: bmp.RotateFlip(RotateFlipType.Rotate180FlipNone); break;
                    case 4: bmp.RotateFlip(RotateFlipType.RotateNoneFlipY); break;
                    case 5: bmp.RotateFlip(RotateFlipType.Rotate90FlipX); break;
                    case 6: bmp.RotateFlip(RotateFlipType.Rotate90FlipNone); break;
                    case 7: bmp.RotateFlip(RotateFlipType.Rotate270FlipX); break;
                    case 8: bmp.RotateFlip(RotateFlipType.Rotate270FlipNone); break;
                }
            }
            catch
            {
            }
            return bmp;
        }

        static Bitmap CropFit(Image src, int width, int height)
        {
            var destRatio = width / (float)height;
            var srcRatio = src.Width / (float)src.Height;
            int cropW = src.Width, cropH = src.Height, cropX = 0, cropY = 0;
            if (srcRatio > destRatio)
            {
                cropW = (int)Math.Round(src.Height * destRatio);
                cropX = (src.Width - cropW) / 2;
            }
            else
            {
                cropH = (int)Math.Round(src.Width / destRatio);
                cropY = (src.Height - cropH) / 2;
            }
            var dest = new Bitmap(width, height, PixelFormat.Format24bppRgb);
            dest.SetResolution(96, 96);
            using (var g = Graphics.FromImage(dest))
            {
                g.Clear(Color.White);
                g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                g.SmoothingMode = SmoothingMode.HighQuality;
                g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                g.CompositingQuality = CompositingQuality.HighQuality;
                g.DrawImage(src, new Rectangle(0, 0, width, height),
                    new Rectangle(cropX, cropY, Math.Max(1, cropW), Math.Max(1, cropH)), GraphicsUnit.Pixel);
            }
            return dest;
        }

        static byte[] EncodeJpeg(Bitmap bmp, long quality)
        {
            var codec = JpegCodec();
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

        static ImageCodecInfo JpegCodec()
        {
            foreach (var c in ImageCodecInfo.GetImageEncoders())
            {
                if (c.FormatID == ImageFormat.Jpeg.Guid)
                    return c;
            }
            return null;
        }
    }
}
