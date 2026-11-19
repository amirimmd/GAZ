using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;
using System.Windows.Shapes;
using Qaemshahr.App.Services;
using Qaemshahr.Core;

namespace Qaemshahr.App.Views
{
    public partial class ChangePasswordWindow : Window
    {
        const string EyeOpen =
            "M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9Z";
        const string EyeOff =
            "M11.83,9L15,12.16C15,12.11 15,12.05 15,12A3,3 0 0,0 12,9C11.94,9 11.89,9 11.83,9M7.53,9.8L9.08,11.35C9.03,11.56 9,11.77 9,12A3,3 0 0,0 12,15C12.22,15 12.44,14.97 12.65,14.92L14.2,16.47C13.53,16.8 12.79,17 12,17A5,5 0 0,1 7,12C7,11.21 7.2,10.47 7.53,9.8M2,4.27L4.28,6.55L4.73,7C3.08,8.3 1.78,10 1,12C2.73,16.39 7,19.5 12,19.5C13.55,19.5 15.03,19.2 16.38,18.66L16.81,19.08L19.73,22L21,20.73L3.27,3M12,7A5,5 0 0,1 17,12C17,12.64 16.87,13.26 16.64,13.82L19.57,16.75C21.07,15.5 22.27,13.86 23,12C21.27,7.61 17,4.5 12,4.5C10.6,4.5 9.26,4.75 8,5.2L10.17,7.35C10.74,7.13 11.35,7 12,7Z";

        public ChangePasswordWindow()
        {
            InitializeComponent();
            UiInput.UseEnglishCredentials(
                CurrentBox, CurrentPlainBox,
                NewBox, NewPlainBox,
                ConfirmBox, ConfirmPlainBox);
            CurrentBox.Focus();
        }

        void OnToggleCurrent(object sender, RoutedEventArgs e)
        {
            ToggleField(CurrentEye, CurrentBox, CurrentPlainBox, CurrentEyePath);
        }

        void OnToggleNew(object sender, RoutedEventArgs e)
        {
            ToggleField(NewEye, NewBox, NewPlainBox, NewEyePath);
        }

        void OnToggleConfirm(object sender, RoutedEventArgs e)
        {
            ToggleField(ConfirmEye, ConfirmBox, ConfirmPlainBox, ConfirmEyePath);
        }

        void ToggleField(ToggleButton eye, PasswordBox secret, TextBox plain, Path icon)
        {
            if (eye.IsChecked == true)
            {
                plain.Text = secret.Password;
                plain.Visibility = Visibility.Visible;
                secret.Visibility = Visibility.Collapsed;
                SetEye(icon, true);
                plain.Focus();
                plain.CaretIndex = plain.Text.Length;
            }
            else
            {
                secret.Password = plain.Text ?? string.Empty;
                secret.Visibility = Visibility.Visible;
                plain.Visibility = Visibility.Collapsed;
                SetEye(icon, false);
                secret.Focus();
            }
        }

        void SetEye(Path icon, bool visible)
        {
            if (icon == null)
                return;
            icon.Data = Geometry.Parse(visible ? EyeOff : EyeOpen);
            icon.Fill = TryFindResource(visible ? "PrimaryBrush" : "MutedBrush") as Brush
                ?? Brushes.Gray;
        }

        string ReadField(PasswordBox secret, TextBox plain, ToggleButton eye)
        {
            return eye.IsChecked == true ? (plain.Text ?? string.Empty) : secret.Password;
        }

        void OnSave(object sender, RoutedEventArgs e)
        {
            ErrorText.Text = string.Empty;
            var current = ReadField(CurrentBox, CurrentPlainBox, CurrentEye);
            var neu = ReadField(NewBox, NewPlainBox, NewEye);
            var confirm = ReadField(ConfirmBox, ConfirmPlainBox, ConfirmEye);
            if (neu != confirm)
            {
                ErrorText.Text = "رمز جدید و تکرار آن یکسان نیستند";
                return;
            }
            var err = SessionContext.Auth.ChangePassword(
                SessionContext.Current.User.Id,
                current,
                neu);
            if (err != null)
            {
                ErrorText.Text = err;
                return;
            }
            CurrentBox.Password = string.Empty;
            NewBox.Password = string.Empty;
            ConfirmBox.Password = string.Empty;
            CurrentPlainBox.Text = string.Empty;
            NewPlainBox.Text = string.Empty;
            ConfirmPlainBox.Text = string.Empty;
            SessionContext.Current.User.MustChangePassword = false;
            DialogResult = true;
            Close();
        }
    }
}
