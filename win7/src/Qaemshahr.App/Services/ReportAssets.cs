using System;
using System.IO;
using System.Windows;

namespace Qaemshahr.App.Services
{
    internal static class ReportAssets
    {
        static string _regular;
        static string _bold;
        static byte[] _logo;

        public static byte[] LogoPng()
        {
            if (_logo != null)
                return _logo;
            _logo = Bytes("pack://application:,,,/Assets/organization_logo.png");
            return _logo;
        }

        public static string FontRegular()
        {
            if (_regular == null)
                _regular = ExtractFont("Vazirmatn-Regular.ttf");
            return _regular;
        }

        public static string FontBold()
        {
            if (_bold == null)
                _bold = ExtractFont("Vazirmatn-Bold.ttf");
            return _bold;
        }

        static string ExtractFont(string fileName)
        {
            var path = Path.Combine(Path.GetTempPath(), "qaemshahr-" + fileName);
            var bytes = Bytes("pack://application:,,,/Assets/Fonts/" + fileName);
            if (bytes == null || bytes.Length == 0)
                throw new InvalidOperationException("فونت گزارش پیدا نشد: " + fileName);
            File.WriteAllBytes(path, bytes);
            return path;
        }

        static byte[] Bytes(string packUri)
        {
            var info = Application.GetResourceStream(new Uri(packUri, UriKind.Absolute));
            if (info == null)
                return null;
            using (var input = info.Stream)
            using (var output = new MemoryStream())
            {
                input.CopyTo(output);
                return output.ToArray();
            }
        }
    }
}
