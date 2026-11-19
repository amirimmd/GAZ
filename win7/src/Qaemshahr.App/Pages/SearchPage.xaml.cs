using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using Qaemshahr.App.Services;
using Qaemshahr.App.Views;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Pages
{
    public partial class SearchPage : Page
    {
        List<Employee> _results = new List<Employee>();

        public SearchPage()
        {
            InitializeComponent();
            UiInput.UseAutoDirection(QueryBox);
        }

        void OnKey(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
                OnSearch(sender, e);
        }

        void OnOr(object sender, RoutedEventArgs e)
        {
            QueryBox.Text = (QueryBox.Text ?? "").TrimEnd() + " OR ";
            QueryBox.CaretIndex = QueryBox.Text.Length;
        }

        void OnNot(object sender, RoutedEventArgs e)
        {
            QueryBox.Text = (QueryBox.Text ?? "").TrimEnd() + " -";
            QueryBox.CaretIndex = QueryBox.Text.Length;
        }

        void OnSearch(object sender, RoutedEventArgs e)
        {
            var parsed = QueryParser.Parse(QueryBox.Text);
            _results = SessionContext.Employees.Search(parsed) ?? new List<Employee>();
            CountText.Text = PersianDate.DigitsFa(_results.Count.ToString()) + " نتیجه";
            RenderResults();
        }

        void RenderResults()
        {
            ResultsHost.Children.Clear();
            if (_results == null || _results.Count == 0)
                return;

            foreach (var emp in _results)
            {
                if (emp == null)
                    continue;
                ResultsHost.Children.Add(BuildResultCard(emp));
            }
        }

        Border BuildResultCard(Employee emp)
        {
            var card = new Border
            {
                Style = TryFindResource("CardFill") as Style,
                Margin = new Thickness(0, 0, 0, 10),
                Padding = new Thickness(12),
                HorizontalAlignment = HorizontalAlignment.Stretch,
                Cursor = Cursors.Hand,
                Tag = emp
            };

            var row = new DockPanel { LastChildFill = true };

            var photo = new Border
            {
                Width = 56,
                Height = 74,
                CornerRadius = new CornerRadius(8),
                ClipToBounds = true,
                Margin = new Thickness(0, 0, 12, 0),
                Background = TryFindResource("SoftPanelBrush") as Brush ?? Brushes.LightGray,
                VerticalAlignment = VerticalAlignment.Top
            };
            DockPanel.SetDock(photo, Dock.Right);
            var img = PhotoImages.FromEmployee(emp.PhotoPath, 120);
            if (img != null)
                photo.Child = new Image { Source = img, Stretch = Stretch.UniformToFill };
            else
                photo.Child = GenderAvatars.ForEmployee(emp, 28);
            row.Children.Add(photo);

            var muted = TryFindResource("MutedBrush") as Brush ?? Brushes.Gray;
            var info = new StackPanel { VerticalAlignment = VerticalAlignment.Center };
            info.Children.Add(new TextBlock
            {
                Text = emp.FullName ?? "",
                FontWeight = FontWeights.SemiBold,
                FontSize = 15,
                TextAlignment = TextAlignment.Right,
                FlowDirection = FlowDirection.RightToLeft
            });
            info.Children.Add(Line("کد ملی", string.IsNullOrWhiteSpace(emp.NationalId)
                ? "—"
                : PersianDate.DigitsFa(emp.NationalId), muted));
            info.Children.Add(Line("سمت", string.IsNullOrWhiteSpace(emp.CurrentPosition) ? "—" : emp.CurrentPosition, muted));
            info.Children.Add(Line("تلفن", string.IsNullOrWhiteSpace(emp.PrimaryPhone)
                ? "—"
                : PersianDate.DigitsFa(emp.PrimaryPhone), muted));
            row.Children.Add(info);

            card.Child = row;
            card.MouseLeftButtonUp += (s, e) =>
            {
                e.Handled = true;
                if (string.IsNullOrEmpty(emp.Id))
                    return;
                var w = new EmployeeEditWindow(emp.Id) { Owner = Window.GetWindow(this) };
                w.ShowDialog();
            };
            return card;
        }

        static TextBlock Line(string label, string value, Brush muted)
        {
            return new TextBlock
            {
                Text = label + ": " + (value ?? ""),
                Foreground = muted,
                FontSize = 12,
                Margin = new Thickness(0, 3, 0, 0),
                TextAlignment = TextAlignment.Right,
                FlowDirection = FlowDirection.RightToLeft,
                TextWrapping = TextWrapping.Wrap
            };
        }

        void OnGroup(object sender, RoutedEventArgs e)
        {
            if (_results == null || _results.Count == 0)
            {
                MessageBox.Show("نتیجه‌ای نیست.");
                return;
            }
            var ids = _results.Where(x => x != null && !string.IsNullOrEmpty(x.Id))
                .Select(x => x.Id)
                .ToList();
            if (ids.Count == 0)
            {
                MessageBox.Show("نتیجه‌ای نیست.");
                return;
            }
            var w = new GroupEditWindow(null, ids) { Owner = Window.GetWindow(this) };
            w.ShowDialog();
        }
    }
}
