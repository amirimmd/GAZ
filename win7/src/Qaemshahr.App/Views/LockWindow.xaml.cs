using System.Windows;
using System.Windows.Input;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Views
{
    public partial class LockWindow : Window
    {
        public LockWindow()
        {
            InitializeComponent();
            UserText.Text = SessionContext.Current.User.DisplayName;
            UiInput.UseEnglish(PassBox);
            PassBox.Focus();
        }

        void OnKey(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
                OnUnlock(sender, e);
        }

        void OnUnlock(object sender, RoutedEventArgs e)
        {
            UserSession session;
            var err = SessionContext.Auth.Login(SessionContext.Current.User.Username, PassBox.Password, false, out session);
            if (err != null)
            {
                ErrorText.Text = err;
                PassBox.Password = string.Empty;
                PassBox.Focus();
                return;
            }
            PassBox.Password = string.Empty;
            SessionContext.Current = session;
            DialogResult = true;
            Close();
        }
    }
}
