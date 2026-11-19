using System.Collections.Generic;

using System.Collections.ObjectModel;

using System.Linq;

using System.Windows;

using System.Windows.Controls;

using System.Windows.Media;

using Qaemshahr.Core;

using Qaemshahr.Core.Models;

using Qaemshahr.Data;



namespace Qaemshahr.App.Views

{

    public partial class ExportColumnsWindow : Window

    {

        readonly List<CheckBox> _boxes = new List<CheckBox>();

        readonly Dictionary<string, ReportColumn> _byKey = new Dictionary<string, ReportColumn>();

        readonly ObservableCollection<ReportColumn> _order = new ObservableCollection<ReportColumn>();

        bool _suppress;



        public string[] ColumnKeys { get; private set; }



        public ExportColumnsWindow(IEnumerable<string> selectedKeys)

        {

            InitializeComponent();

            Title = AppConstants.AppNameFa + " — ستون‌های خروجی";

            foreach (var c in ExcelService.Catalog())

                _byKey[c.Key] = c;

            OrderBox.ItemsSource = _order;

            BuildColumns(new HashSet<string>(selectedKeys ?? new string[0]));

        }



        void BuildColumns(HashSet<string> selected)

        {

            ColumnsHost.Children.Clear();

            _boxes.Clear();

            _order.Clear();

            string lastGroup = null;

            var headerBrush = TryFindResource("PrimaryBrush") as Brush ?? Brushes.Black;

            var defaults = selected.Count == 0;

            foreach (var c in ExcelService.Catalog())

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

                var on = defaults ? c.Selected : selected.Contains(c.Key);

                var cb = new CheckBox

                {

                    Content = c.TitleFa,

                    IsChecked = on,

                    Margin = new Thickness(0, 2, 0, 6),

                    Tag = c.Key

                };

                cb.Checked += OnBoxChanged;

                cb.Unchecked += OnBoxChanged;

                _boxes.Add(cb);

                ColumnsHost.Children.Add(cb);

                if (on)

                    _order.Add(CloneCol(c));

            }

            if (!defaults && selected.Count > 0)

            {

                _order.Clear();

                foreach (var key in selected)

                {

                    ReportColumn c;

                    if (_byKey.TryGetValue(key, out c))

                        _order.Add(CloneCol(c));

                }

            }

        }



        static ReportColumn CloneCol(ReportColumn c)

        {

            return new ReportColumn

            {

                Key = c.Key,

                TitleFa = c.TitleFa,

                Group = c.Group,

                Selected = true

            };

        }



        void OnBoxChanged(object sender, RoutedEventArgs e)

        {

            if (_suppress)

                return;

            var cb = sender as CheckBox;

            var key = cb != null ? cb.Tag as string : null;

            if (string.IsNullOrEmpty(key))

                return;

            if (cb.IsChecked == true)

            {

                if (_order.All(x => x.Key != key) && _byKey.ContainsKey(key))

                    _order.Add(CloneCol(_byKey[key]));

            }

            else

            {

                for (var i = _order.Count - 1; i >= 0; i--)

                {

                    if (_order[i].Key == key)

                        _order.RemoveAt(i);

                }

            }

        }



        void OnAll(object sender, RoutedEventArgs e)

        {

            _suppress = true;

            foreach (var b in _boxes)

                b.IsChecked = true;

            _suppress = false;

            _order.Clear();

            foreach (var b in _boxes)

            {

                var key = b.Tag as string;

                if (_byKey.ContainsKey(key))

                    _order.Add(CloneCol(_byKey[key]));

            }

        }



        void OnNone(object sender, RoutedEventArgs e)

        {

            _suppress = true;

            foreach (var b in _boxes)

                b.IsChecked = false;

            _suppress = false;

            _order.Clear();

        }



        void OnDefault(object sender, RoutedEventArgs e)

        {

            var defaults = new HashSet<string>(ExcelService.Catalog().Where(c => c.Selected).Select(c => c.Key));

            _suppress = true;

            foreach (var b in _boxes)

                b.IsChecked = defaults.Contains((string)b.Tag);

            _suppress = false;

            _order.Clear();

            foreach (var c in ExcelService.Catalog())

            {

                if (defaults.Contains(c.Key))

                    _order.Add(CloneCol(c));

            }

        }



        void OnMoveUp(object sender, RoutedEventArgs e)

        {

            var i = OrderBox.SelectedIndex;

            if (i <= 0)

                return;

            _order.Move(i, i - 1);

            OrderBox.SelectedIndex = i - 1;

        }



        void OnMoveDown(object sender, RoutedEventArgs e)

        {

            var i = OrderBox.SelectedIndex;

            if (i < 0 || i >= _order.Count - 1)

                return;

            _order.Move(i, i + 1);

            OrderBox.SelectedIndex = i + 1;

        }



        void OnOk(object sender, RoutedEventArgs e)

        {

            if (_order.Count == 0)

            {

                MessageBox.Show("حداقل یک ستون انتخاب کنید.", AppConstants.AppNameFa);

                return;

            }

            ColumnKeys = _order.Select(c => c.Key).ToArray();

            DialogResult = true;

        }



        void OnCancel(object sender, RoutedEventArgs e)

        {

            DialogResult = false;

        }

    }

}


