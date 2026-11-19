using System;
using System.IO;
using System.Threading;
using System.Windows;
using Qaemshahr.App.Services;
using Qaemshahr.App.Views;
using Qaemshahr.Core;
using Qaemshahr.Data;

namespace Qaemshahr.App
{
    public partial class App : Application
    {
        Mutex _mutex;
        AppDatabase _db;

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);
            UiInput.RegisterGlobalAutoDirection();
            NativeWindowIcon.Attach();
            DispatcherUnhandledException += (s, args) =>
            {
                AppLog.Error("UI exception", args.Exception);
                MessageBox.Show(args.Exception.Message, AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Error);
                args.Handled = true;
            };

            bool created;
            _mutex = new Mutex(true, AppPaths.InstanceMutexName, out created);
            if (!created)
            {
                MessageBox.Show("برنامه هم‌اکنون در حال اجرا است.", AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Information);
                Shutdown();
                return;
            }

            try
            {
                AppPaths.EnsureDataDirectories();
                if (AppPaths.IsPortable)
                    AppLog.Info("Portable mode — data under " + AppPaths.DataRoot);
                else
                    MaybeImportFlutterData();
                _db = AppDatabase.OpenOrCreate();
                SessionContext.Bind(_db);
            }
            catch (SchemaTooNewException ex)
            {
                MessageBox.Show(ex.Message, AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Warning);
                Shutdown();
                return;
            }
            catch (Exception ex)
            {
                AppLog.Error("Startup failed", ex);
                MessageBox.Show("راه‌اندازی ناموفق شد:\n" + ex.Message, AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Error);
                Shutdown();
                return;
            }

            var login = new LoginWindow();
            var ok = login.ShowDialog();
            if (ok != true || SessionContext.Current == null)
            {
                Shutdown();
                return;
            }

            if (SessionContext.Current.User.MustChangePassword)
            {
                var change = new ChangePasswordWindow { Owner = null };
                if (change.ShowDialog() != true)
                {
                    SessionContext.Auth.Logout(SessionContext.Current.SessionId);
                    Shutdown();
                    return;
                }
            }

            var shell = new ShellWindow();
            MainWindow = shell;
            ShutdownMode = ShutdownMode.OnMainWindowClose;
            shell.Show();
        }

        static void MaybeImportFlutterData()
        {
            if (File.Exists(AppPaths.DatabaseFile))
                return;
            var legacy = FlutterImporter.FindLegacyDatabase();
            if (legacy == null)
                return;
            var result = MessageBox.Show(
                "نسخهٔ قبلی قائم‌شهر روی این سیستم پیدا شد.\nآیا داده به برنامهٔ جدید منتقل شود؟\n\n" + legacy,
                "ورود داده از نسخهٔ قبلی",
                MessageBoxButton.YesNo,
                MessageBoxImage.Question);
            if (result == MessageBoxResult.Yes)
            {
                try
                {
                    FlutterImporter.ImportFrom(legacy);
                }
                catch (Exception ex)
                {
                    AppLog.Error("Flutter import failed", ex);
                    MessageBox.Show("انتقال داده ناموفق بود. پایگاه تازه ساخته می‌شود.\n" + ex.Message,
                        AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Warning);
                }
            }
        }

        protected override void OnExit(ExitEventArgs e)
        {
            try
            {
                SessionContext.Unbind(true);
            }
            catch
            {
            }
            if (_mutex != null)
            {
                try { _mutex.ReleaseMutex(); } catch { }
                _mutex.Dispose();
            }
            base.OnExit(e);
        }
    }
}
