using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Views
{
    public partial class SampleReportsWindow : Window
    {
        readonly SampleTitle _row;

        public SampleReportsWindow(SampleTitle row)
        {
            InitializeComponent();
            _row = row;
            TitleText.Text = "گزارش‌های «" + (row.EmployeeName ?? "") + "»";
            SubText.Text = SampleTitleKinds.Fa(row.Kind)
                + "  ·  سال " + PersianDate.DigitsFa(row.Year.ToString());
            Reload();
        }

        void Reload()
        {
            ListHost.Children.Clear();
            var list = SessionContext.SampleTitles.ListReports(_row.Id);
            if (list == null || list.Count == 0)
            {
                ListHost.Children.Add(new TextBlock
                {
                    Text = "هنوز گزارشی ثبت نشده است.",
                    Style = TryFindResource("MutedText") as Style,
                    Margin = new Thickness(0, 8, 0, 8)
                });
                return;
            }
            foreach (var report in list)
            {
                var card = new Border
                {
                    Style = TryFindResource("SoftPanel") as Style,
                    Margin = new Thickness(0, 0, 0, 8),
                    Padding = new Thickness(12)
                };
                var stack = new StackPanel();
                stack.Children.Add(new TextBlock
                {
                    Text = report.Body ?? "",
                    TextWrapping = TextWrapping.Wrap,
                    FontSize = 13
                });
                var meta = new DockPanel { Margin = new Thickness(0, 8, 0, 0) };
                var del = new Button
                {
                    Content = "حذف",
                    Style = TryFindResource("DangerButton") as Style,
                    Padding = new Thickness(10, 2, 10, 2),
                    MinHeight = 28,
                    FontSize = 11,
                    Tag = report
                };
                DockPanel.SetDock(del, Dock.Left);
                del.Click += OnDelete;
                meta.Children.Add(del);
                meta.Children.Add(new TextBlock
                {
                    Text = report.CreatedAtFa
                        + (string.IsNullOrWhiteSpace(report.CreatedBy) ? "" : "  ·  " + report.CreatedBy),
                    Style = TryFindResource("MutedText") as Style,
                    FontSize = 11,
                    VerticalAlignment = VerticalAlignment.Center
                });
                stack.Children.Add(meta);
                card.Child = stack;
                ListHost.Children.Add(card);
            }
        }

        void OnAdd(object sender, RoutedEventArgs e)
        {
            var err = SessionContext.SampleTitles.AddReport(_row.Id, BodyBox.Text, CurrentUsername());
            if (err != null)
            {
                MessageBox.Show(err, AppConstants.AppNameFa);
                return;
            }
            BodyBox.Text = "";
            Reload();
        }

        void OnDelete(object sender, RoutedEventArgs e)
        {
            var btn = sender as Button;
            var report = btn == null ? null : btn.Tag as SampleReport;
            if (report == null)
                return;
            if (MessageBox.Show("این گزارش حذف شود؟", AppConstants.AppNameFa,
                    MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            SessionContext.SampleTitles.DeleteReport(report.Id);
            Reload();
        }

        void OnClose(object sender, RoutedEventArgs e)
        {
            DialogResult = true;
            Close();
        }

        static string CurrentUsername()
        {
            return SessionContext.Current != null && SessionContext.Current.User != null
                ? SessionContext.Current.User.Username
                : null;
        }
    }
}
