using System.IO;
using System.Windows.Media.Imaging;
using Qaemshahr.Data;

namespace Qaemshahr.App.Services
{
    internal static class PhotoImages
    {
        public static BitmapImage FromJpeg(byte[] jpeg, int decodeWidth = 0)
        {
            if (jpeg == null || jpeg.Length == 0)
                return null;
            var bmp = new BitmapImage();
            bmp.BeginInit();
            bmp.CacheOption = BitmapCacheOption.OnLoad;
            if (decodeWidth > 0)
                bmp.DecodePixelWidth = decodeWidth;
            bmp.StreamSource = new MemoryStream(jpeg);
            bmp.EndInit();
            bmp.Freeze();
            return bmp;
        }

        public static BitmapImage FromEmployee(string photoPath, int decodeWidth = 120)
        {
            return FromJpeg(EmployeePhotoStore.Read(photoPath), decodeWidth);
        }
    }
}
