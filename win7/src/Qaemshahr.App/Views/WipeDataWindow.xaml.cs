using System;
using System.Windows;
using System.Windows.Controls;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Data;

namespace Qaemshahr.App.Views
{
    public partial class WipeDataWindow : Window
    {
        public WipeDataWindow()
        {
            InitializeComponent();
            UiInput.UseEnglish(PassBox);
            PhraseBox.Focus();
        }

        void OnFormChanged(object sender, RoutedEventArgs e)
        {
            RefreshEnable();
        }

        void OnPassChanged(object sender, RoutedEventArgs e)
        {
            RefreshEnable();
        }

        void RefreshEnable()
        {
            var phraseOk = string.Equals((PhraseBox.Text ?? string.Empty).Trim(), DataWipeService.ConfirmPhrase, StringComparison.Ordinal);
            var passOk = !string.IsNullOrEmpty(PassBox.Password);
            var checkOk = UnderstandBox.IsChecked == true;
            WipeButton.IsEnabled = phraseOk && passOk && checkOk;
            if (ErrorText != null)
                ErrorText.Text = string.Empty;
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        void OnWipe(object sender, RoutedEventArgs e)
        {
            ErrorText.Text = string.Empty;
            if (!string.Equals((PhraseBox.Text ?? string.Empty).Trim(), DataWipeService.ConfirmPhrase, StringComparison.Ordinal))
            {
                ErrorText.Text = "عبارت تأیید را دقیقاً به صورت «پاک کردن همه» بنویسید.";
                return;
            }
            if (UnderstandBox.IsChecked != true)
            {
                ErrorText.Text = "تأیید برگشت‌ناپذیر بودن الزامی است.";
                return;
            }
            if (SessionContext.Current == null || SessionContext.Auth == null)
            {
                ErrorText.Text = "نشست کاربری معتبر نیست.";
                return;
            }
            if (!SessionContext.Can(PermissionCodes.SystemBackup) && !SessionContext.Can(PermissionCodes.SystemRestore))
            {
                ErrorText.Text = "شما اجازهٔ پاک‌سازی داده را ندارید.";
                return;
            }

            var verify = SessionContext.Auth.VerifyPassword(SessionContext.Current.User.Id, PassBox.Password);
            if (verify != null)
            {
                ErrorText.Text = verify;
                return;
            }

            if (MessageBox.Show(
                    "آخرین هشدار: همه داده‌ها الان پاک می‌شوند. ادامه می‌دهید؟",
                    AppConstants.AppNameFa,
                    MessageBoxButton.YesNo,
                    MessageBoxImage.Stop) != MessageBoxResult.Yes)
                return;

            WipeButton.IsEnabled = false;
            SessionContext.Current = null;
            SessionContext.Unbind(true);

            var err = DataWipeService.WipeAllData();
            if (err != null)
            {
                try { SessionContext.Bind(AppDatabase.OpenOrCreate()); }
                catch { }
                ErrorText.Text = err;
                WipeButton.IsEnabled = true;
                return;
            }

            DialogResult = true;
            Close();
        }
    }
}
