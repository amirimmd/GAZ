using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Interop;
using System.Windows.Media.Imaging;
using System.Windows.Threading;

namespace Qaemshahr.App.Services
{
    internal static class NativeWindowIcon
    {
        const int WmSetIcon = 0x0080;
        const int IconSmall = 0;
        const int IconBig = 1;
        const uint ImageIcon = 1;
        const uint LrLoadFromFile = 0x0010;

        static readonly Uri PackUri = new Uri("pack://application:,,,/Assets/app.ico", UriKind.Absolute);
        static string _tempIco;
        static bool _attached;

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        static extern IntPtr SendMessage(IntPtr hWnd, int msg, IntPtr wParam, IntPtr lParam);

        [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
        static extern IntPtr LoadImage(IntPtr hInst, string lpszName, uint uType, int cx, int cy, uint fuLoad);

        public static void Attach()
        {
            if (_attached)
                return;
            _attached = true;
            EventManager.RegisterClassHandler(typeof(Window), FrameworkElement.LoadedEvent,
                new RoutedEventHandler(OnLoaded), true);
        }

        static void OnLoaded(object sender, RoutedEventArgs e)
        {
            var window = sender as Window;
            if (window == null || !ReferenceEquals(e.OriginalSource, window))
                return;
            Apply(window);
        }

        public static void Apply(Window window)
        {
            try
            {
                window.Icon = BitmapFrame.Create(PackUri);
            }
            catch
            {
            }

            window.Dispatcher.BeginInvoke(new Action(() => SetWin32Icons(window)), DispatcherPriority.Loaded);
        }

        static void SetWin32Icons(Window window)
        {
            try
            {
                var hwnd = new WindowInteropHelper(window).Handle;
                if (hwnd == IntPtr.Zero)
                    return;
                var path = EnsureTempIcon();
                if (path == null)
                    return;
                var small = LoadImage(IntPtr.Zero, path, ImageIcon, 16, 16, LrLoadFromFile);
                var big = LoadImage(IntPtr.Zero, path, ImageIcon, 32, 32, LrLoadFromFile);
                if (small != IntPtr.Zero)
                    SendMessage(hwnd, WmSetIcon, (IntPtr)IconSmall, small);
                if (big != IntPtr.Zero)
                    SendMessage(hwnd, WmSetIcon, (IntPtr)IconBig, big);
            }
            catch
            {
            }
        }

        static string EnsureTempIcon()
        {
            if (_tempIco != null && File.Exists(_tempIco))
                return _tempIco;
            var streamInfo = Application.GetResourceStream(PackUri);
            if (streamInfo == null)
                return null;
            _tempIco = Path.Combine(Path.GetTempPath(), "qaemshahr-app.ico");
            using (var input = streamInfo.Stream)
            using (var output = File.Create(_tempIco))
                input.CopyTo(output);
            return _tempIco;
        }
    }
}
