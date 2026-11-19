using System.Windows;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Views
{
    public partial class WorkerProjectWindow : Window
    {
        public WorkerProjectRow Result { get; private set; }

        public WorkerProjectWindow(WorkerProjectRow existing)
        {
            InitializeComponent();
            for (var i = 1; i <= 10; i++)
                LevelBox.Items.Add(i);
            if (existing != null)
            {
                TitleBox.Text = existing.Title;
                LevelBox.SelectedItem = existing.Level < 1 ? 5 : existing.Level;
                HoursBox.Text = existing.Hours.ToString("0.##");
                ProgressBox.Text = existing.ProgressPercent.ToString("0.##");
                ChecklistBox.Text = existing.ChecklistCount.ToString();
                DirectBox.Text = existing.IncidentsDirect.ToString();
                IndirectBox.Text = existing.IncidentsIndirect.ToString();
                SevereBox.IsChecked = existing.SevereIncident;
                Result = existing;
            }
            else
            {
                LevelBox.SelectedItem = 5;
                HoursBox.Text = "0";
                ProgressBox.Text = "100";
                ChecklistBox.Text = "0";
                DirectBox.Text = "0";
                IndirectBox.Text = "0";
                Result = new WorkerProjectRow { Id = System.Guid.NewGuid().ToString() };
            }
        }

        void OnOk(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(TitleBox.Text))
            {
                MessageBox.Show("عنوان پروژه الزامی است.");
                return;
            }
            double hours, progress;
            int checklists, direct, indirect;
            if (!double.TryParse(HoursBox.Text.Replace('/', '.'), out hours) || hours < 0)
            {
                MessageBox.Show("ساعت فعالیت نامعتبر است.");
                return;
            }
            if (!double.TryParse(ProgressBox.Text.Replace('/', '.'), out progress) || progress < 0 || progress > 100)
            {
                MessageBox.Show("پیشرفت باید بین ۰ تا ۱۰۰ باشد.");
                return;
            }
            int.TryParse(ChecklistBox.Text, out checklists);
            int.TryParse(DirectBox.Text, out direct);
            int.TryParse(IndirectBox.Text, out indirect);
            var level = LevelBox.SelectedItem is int ? (int)LevelBox.SelectedItem : 5;
            Result.Title = TitleBox.Text.Trim();
            Result.Level = level;
            Result.Hours = hours;
            Result.ProgressPercent = progress;
            Result.ChecklistCount = checklists < 0 ? 0 : checklists;
            Result.IncidentsDirect = direct < 0 ? 0 : direct;
            Result.IncidentsIndirect = indirect < 0 ? 0 : indirect;
            Result.SevereIncident = SevereBox.IsChecked == true;
            DialogResult = true;
            Close();
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        void OnAddHours(object sender, RoutedEventArgs e)
        {
            var btn = sender as FrameworkElement;
            double add;
            if (btn == null || !double.TryParse(System.Convert.ToString(btn.Tag), out add))
                return;
            double current;
            double.TryParse((HoursBox.Text ?? "0").Replace('/', '.'), out current);
            HoursBox.Text = (current + add).ToString("0.##");
        }

        void OnSetProgress(object sender, RoutedEventArgs e)
        {
            var btn = sender as FrameworkElement;
            if (btn == null)
                return;
            ProgressBox.Text = System.Convert.ToString(btn.Tag);
        }
    }
}
