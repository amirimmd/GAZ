using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Views
{
    public partial class LoginWindow : Window
    {
        const string EyeOpen =
            "M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9Z";
        const string EyeOff =
            "M11.83,9L15,12.16C15,12.11 15,12.05 15,12A3,3 0 0,0 12,9C11.94,9 11.89,9 11.83,9M7.53,9.8L9.08,11.35C9.03,11.56 9,11.77 9,12A3,3 0 0,0 12,15C12.22,15 12.44,14.97 12.65,14.92L14.2,16.47C13.53,16.8 12.79,17 12,17A5,5 0 0,1 7,12C7,11.21 7.2,10.47 7.53,9.8M2,4.27L4.28,6.55L4.73,7C3.08,8.3 1.78,10 1,12C2.73,16.39 7,19.5 12,19.5C13.55,19.5 15.03,19.2 16.38,18.66L16.81,19.08L19.73,22L21,20.73L3.27,3M12,7A5,5 0 0,1 17,12C17,12.64 16.87,13.26 16.64,13.82L19.57,16.75C21.07,15.5 22.27,13.86 23,12C21.27,7.61 17,4.5 12,4.5C10.6,4.5 9.26,4.75 8,5.2L10.17,7.35C10.74,7.13 11.35,7 12,7Z";

        string _savedUser;
        string _savedPass;

        public LoginWindow()
        {
            InitializeComponent();
            UiInput.UseEnglishCredentials(UserBox, PasswordBox, PasswordPlainBox);

            try
            {
                AppPaths.EnsureDataDirectories();
            }
            catch (Exception ex)
            {
                AppLog.Error("Login EnsureDataDirectories failed", ex);
            }

            _savedUser = SecureStore.ReadProtected(AppPaths.RememberUserFile);
            var user = string.IsNullOrEmpty(_savedUser) ? AppConstants.DefaultAdminUser : _savedUser.Trim();
            if (TextUtil.ContainsPersianOrArabic(user))
                user = AppConstants.DefaultAdminUser;
            UserBox.Text = user;
            UiInput.ForceLtr(UserBox);

            var passBlob = SecureStore.ReadProtected(AppPaths.RememberPassFile);
            if (!string.IsNullOrEmpty(passBlob))
            {
                string u, p;
                if (TryParseCred(passBlob, out u, out p)
                    && !string.IsNullOrEmpty(p)
                    && !TextUtil.ContainsPersianOrArabic(p))
                {
                    if (string.IsNullOrEmpty(u)
                        || string.Equals(u, TextUtil.NormalizeUsername(UserBox.Text), StringComparison.OrdinalIgnoreCase))
                    {
                        if (!string.IsNullOrEmpty(u))
                        {
                            UserBox.Text = u;
                            _savedUser = u;
                        }
                        _savedPass = p;
                        PasswordBox.Password = p;
                        PasswordPlainBox.Text = p;
                        RememberPassBox.IsChecked = true;
                        UiInput.ForceLtr(PasswordBox);
                        UiInput.ForceLtr(PasswordPlainBox);
                    }
                }
            }

            VersionText.Text = AppPaths.IsPortable
                ? "نسخه " + AppConstants.AppVersion + "  ·  پرتابل"
                : "نسخه " + AppConstants.AppVersion;

            RememberPassBox.ToolTip = AppPaths.IsPortable
                ? "نام کاربری و رمز به‌صورت رمزنگاری‌شده داخل پوشهٔ برنامه ذخیره می‌شود."
                : "رمز فقط برای همین کاربر ویندوز به‌صورت رمزنگاری‌شده ذخیره می‌شود.";

            Loaded += OnLoaded;
            if (RememberPassBox.IsChecked == true)
                UserBox.Focus();
            else
                PasswordBox.Focus();
        }

        void OnLoaded(object sender, RoutedEventArgs e)
        {
            UiInput.ForceLtr(UserBox);
            UiInput.ForceLtr(PasswordBox);
            UiInput.ForceLtr(PasswordPlainBox);
            try
            {
                InputLanguageManager.Current.CurrentInputLanguage =
                    System.Globalization.CultureInfo.GetCultureInfo("en-US");
            }
            catch
            {
            }
        }

        static bool TryParseCred(string blob, out string user, out string pass)
        {
            user = null;
            pass = null;
            if (string.IsNullOrEmpty(blob))
                return false;
            var idx = blob.IndexOf('\n');
            if (idx <= 0 || idx >= blob.Length - 1)
                return false;
            user = blob.Substring(0, idx).Trim().TrimStart('\uFEFF');
            pass = blob.Substring(idx + 1);
            return user.Length > 0 && pass.Length > 0;
        }

        string ReadPassword()
        {
            return ShowPassToggle.IsChecked == true ? PasswordPlainBox.Text : PasswordBox.Password;
        }

        void OnTogglePassword(object sender, RoutedEventArgs e)
        {
            if (ShowPassToggle.IsChecked == true)
            {
                PasswordPlainBox.Text = PasswordBox.Password;
                PasswordPlainBox.Visibility = Visibility.Visible;
                PasswordBox.Visibility = Visibility.Collapsed;
                SetEye(true);
                PasswordPlainBox.Focus();
                PasswordPlainBox.CaretIndex = PasswordPlainBox.Text.Length;
            }
            else
            {
                PasswordBox.Password = PasswordPlainBox.Text ?? string.Empty;
                PasswordBox.Visibility = Visibility.Visible;
                PasswordPlainBox.Visibility = Visibility.Collapsed;
                SetEye(false);
                PasswordBox.Focus();
            }
        }

        void SetEye(bool visible)
        {
            if (EyePath == null)
                return;
            EyePath.Data = Geometry.Parse(visible ? EyeOff : EyeOpen);
            EyePath.Fill = TryFindResource(visible ? "PrimaryBrush" : "MutedBrush") as Brush
                ?? Brushes.Gray;
        }

        void OnLogin(object sender, RoutedEventArgs e)
        {
            ErrorText.Text = string.Empty;
            var password = ReadPassword();
            if (string.IsNullOrEmpty(password) && !string.IsNullOrEmpty(_savedPass)
                && string.Equals(TextUtil.NormalizeUsername(UserBox.Text), TextUtil.NormalizeUsername(_savedUser ?? string.Empty), StringComparison.OrdinalIgnoreCase))
                password = _savedPass;

            UserSession session;
            var err = SessionContext.Auth.Login(UserBox.Text, password, RememberPassBox.IsChecked == true, out session);
            if (err != null)
            {
                ErrorText.Text = err;
                return;
            }

            var user = TextUtil.NormalizeUsername(UserBox.Text);
            try
            {
                if (!string.IsNullOrEmpty(user))
                    SecureStore.WriteProtected(AppPaths.RememberUserFile, user);

                if (RememberPassBox.IsChecked == true && !string.IsNullOrEmpty(password))
                {
                    SecureStore.WriteProtected(AppPaths.RememberPassFile, user + "\n" + password);
                    _savedUser = user;
                    _savedPass = password;
                }
                else
                {
                    SecureStore.Delete(AppPaths.RememberPassFile);
                    _savedPass = null;
                }
            }
            catch (Exception ex)
            {
                AppLog.Error("Saving remembered credentials failed", ex);
                MessageBox.Show(
                    "ورود موفق بود، ولی ذخیرهٔ رمز ممکن نشد.\nاگر از فلش استفاده می‌کنید، بررسی کنید فقط‌خواندنی نباشد.",
                    AppConstants.AppNameFa,
                    MessageBoxButton.OK,
                    MessageBoxImage.Warning);
            }

            PasswordBox.Password = string.Empty;
            PasswordPlainBox.Text = string.Empty;
            SessionContext.Current = session;
            DialogResult = true;
            Close();
        }

        void OnForgot(object sender, RoutedEventArgs e)
        {
            MessageBox.Show(
                "برای بازنشانی رمز عبور با مدیر سیستم تماس بگیرید.\nرمز موقت پس از بازنشانی در ورود بعدی باید عوض شود.",
                "فراموشی رمز عبور",
                MessageBoxButton.OK,
                MessageBoxImage.Information);
        }

        void OnCredentialKey(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
                OnLogin(sender, e);
        }
    }
}
