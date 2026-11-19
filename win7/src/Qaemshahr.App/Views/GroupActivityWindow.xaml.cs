using System.Windows;

using Qaemshahr.App.Services;

using Qaemshahr.Core;

using Qaemshahr.Core.Models;



namespace Qaemshahr.App.Views

{

    public partial class GroupActivityWindow : Window

    {

        readonly string _groupId;



        public GroupActivityWindow(string groupId, string groupName)

        {

            InitializeComponent();

            _groupId = groupId;

            GroupNameText.Text = string.IsNullOrWhiteSpace(groupName) ? "گروه" : groupName.Trim();

            DateBox.Value = PersianDate.Today();

            if (SessionContext.Current != null && SessionContext.Current.User != null)

            {

                RecorderBox.Text = string.IsNullOrWhiteSpace(SessionContext.Current.User.DisplayName)

                    ? SessionContext.Current.User.Username

                    : SessionContext.Current.User.DisplayName;

            }

            TitleBox.Focus();

        }



        void OnSave(object sender, RoutedEventArgs e)

        {

            if (SessionContext.Groups == null || SessionContext.Current == null)

                return;

            var recorder = (RecorderBox.Text ?? "").Trim();

            if (recorder.Length == 0)

            {

                MessageBox.Show("نام ثبت‌کننده را وارد کنید.", AppConstants.AppNameFa);

                RecorderBox.Focus();

                return;

            }

            var a = new GroupActivity

            {

                GroupId = _groupId,

                Title = TitleBox.Text,

                Note = NoteBox.Text,

                ActivityDate = DateBox.Value

            };

            var err = SessionContext.Groups.AddActivity(

                a,

                SessionContext.Current.User.Id,

                recorder);

            if (err != null)

            {

                MessageBox.Show(err, AppConstants.AppNameFa);

                return;

            }

            DialogResult = true;

            Close();

        }



        void OnCancel(object sender, RoutedEventArgs e)

        {

            DialogResult = false;

            Close();

        }

    }

}


