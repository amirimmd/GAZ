using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Views
{
    public partial class ReportLayoutEditWindow : Window
    {
        readonly List<CheckBox> _boxes = new List<CheckBox>();
        readonly List<ReportColumn> _cols;

        public string LayoutName { get; private set; }
        public string[] ColumnKeys { get; private set; }

        public ReportLayoutEditWindow(string name, IEnumerable<string> selectedKeys)
        {
            InitializeComponent();
            Title = AppConstants.AppNameFa + " — چیدمان گزارش";
            NameBox.Text = string.IsNullOrWhiteSpace(name) ? "چیدمان جدید" : name;
            _cols = ExcelService.Catalog().ToList();
            var selected = new HashSet<string>(selectedKeys ?? new string[0]);
            BuildColumns(selected);
        }

        void BuildColumns(HashSet<string> selected)
        {
            ColumnsHost.Children.Clear();
            _boxes.Clear();
            string lastGroup = null;
            var headerBrush = TryFindResource("PrimaryBrush") as Brush ?? Brushes.Black;
            foreach (var c in _cols)
            {
                if (c.Group != lastGroup)
                {
                    lastGroup = c.Group;
                    ColumnsHost.Children.Add(new TextBlock
                    {
                        Text = c.Group,
                        FontWeight = FontWeights.SemiBold,
                        Foreground = headerBrush,
                        Margin = new Thickness(0, 10, 0, 6)
                    });
                }
                var cb = new CheckBox
                {
                    Content = c.TitleFa,
                    IsChecked = selected.Count == 0 ? c.Selected : selected.Contains(c.Key),
                    Margin = new Thickness(0, 2, 0, 6),
                    Tag = c.Key
                };
                _boxes.Add(cb);
                ColumnsHost.Children.Add(cb);
            }
        }

        void OnAll(object sender, RoutedEventArgs e)
        {
            foreach (var b in _boxes)
                b.IsChecked = true;
        }

        void OnNone(object sender, RoutedEventArgs e)
        {
            foreach (var b in _boxes)
                b.IsChecked = false;
        }

        void OnDefault(object sender, RoutedEventArgs e)
        {
            var defaults = new HashSet<string>(ExcelService.Catalog().Where(c => c.Selected).Select(c => c.Key));
            foreach (var b in _boxes)
                b.IsChecked = defaults.Contains((string)b.Tag);
        }

        void OnSave(object sender, RoutedEventArgs e)
        {
            var name = (NameBox.Text ?? "").Trim();
            if (name.Length == 0)
            {
                MessageBox.Show("نام چیدمان را وارد کنید.", AppConstants.AppNameFa);
                return;
            }
            var keys = _boxes.Where(b => b.IsChecked == true).Select(b => (string)b.Tag).ToArray();
            if (keys.Length == 0)
            {
                MessageBox.Show("حداقل یک ستون انتخاب کنید.", AppConstants.AppNameFa);
                return;
            }
            LayoutName = name;
            ColumnKeys = keys;
            DialogResult = true;
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
        }
    }
}
