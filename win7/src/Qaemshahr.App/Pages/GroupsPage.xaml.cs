using System.Collections.Generic;

using System.Linq;

using System.Windows;

using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;

using System.Windows.Media.Imaging;

using Microsoft.Win32;

using Qaemshahr.App.Services;

using Qaemshahr.App.Views;

using Qaemshahr.Core;

using Qaemshahr.Core.Models;

using Qaemshahr.Data;



namespace Qaemshahr.App.Pages

{

    public partial class GroupsPage : Page

    {

        static readonly SolidColorBrush ActiveBrush = Freeze(0x2E, 0x7D, 0x32);

        static readonly SolidColorBrush ArchivedBrush = Freeze(0x78, 0x90, 0x9C);

        static string[] _lastExportColumnKeys;



        public GroupsPage()
        {
            InitializeComponent();
            Loaded += (s, e) => UpdateCardColumns();
            Reload();
        }

        void OnPageSizeChanged(object sender, SizeChangedEventArgs e)
        {
            UpdateCardColumns();
        }

        void UpdateCardColumns()
        {
            var width = ActualWidth;
            if (CardsScroll != null && CardsScroll.ViewportWidth > 0)
                width = CardsScroll.ViewportWidth;
            if (width <= 0)
                return;
            var cols = width >= 1080 ? 3 : (width >= 680 ? 2 : 1);
            var grid = FindCardsGrid(CardsHost);
            if (grid != null && grid.Columns != cols)
                grid.Columns = cols;
        }

        static UniformGrid FindCardsGrid(DependencyObject root)
        {
            if (root == null)
                return null;
            var count = VisualTreeHelper.GetChildrenCount(root);
            for (var i = 0; i < count; i++)
            {
                var child = VisualTreeHelper.GetChild(root, i);
                var grid = child as UniformGrid;
                if (grid != null)
                    return grid;
                var nested = FindCardsGrid(child);
                if (nested != null)
                    return nested;
            }
            return null;
        }



        static SolidColorBrush Freeze(byte r, byte g, byte b)

        {

            var brush = new SolidColorBrush(Color.FromRgb(r, g, b));

            brush.Freeze();

            return brush;

        }



        void Reload()

        {

            var q = (SearchBox == null ? "" : SearchBox.Text) ?? "";

            var groups = SessionContext.Groups.List(q, null) ?? new List<EmployeeGroup>();

            var cards = new List<GroupCardVm>();

            foreach (var g in groups)

            {

                var acts = SessionContext.Groups.ListActivities(g.Id, 20) ?? new List<GroupActivity>();

                cards.Add(GroupCardVm.From(g, acts));

            }

            CardsHost.ItemsSource = cards;
            Dispatcher.BeginInvoke(new System.Action(UpdateCardColumns),
                System.Windows.Threading.DispatcherPriority.Loaded);
        }



        void OnFilter(object sender, TextChangedEventArgs e)

        {

            Reload();

        }



        void OnNew(object sender, RoutedEventArgs e)

        {

            if (!SessionContext.Can(PermissionCodes.GroupsCreate))

                return;

            var w = new GroupEditWindow(null, null) { Owner = Window.GetWindow(this) };

            if (w.ShowDialog() == true)

                Reload();

        }



        void OnEdit(object sender, RoutedEventArgs e)

        {

            var id = (sender as FrameworkElement)?.Tag as string;

            if (string.IsNullOrEmpty(id))

                return;

            if (!SessionContext.Can(PermissionCodes.GroupsEdit)

                && !SessionContext.Can(PermissionCodes.GroupsCreate))

            {

                MessageBox.Show("دسترسی ویرایش ندارید.", AppConstants.AppNameFa);

                return;

            }

            var w = new GroupEditWindow(id, null) { Owner = Window.GetWindow(this) };

            if (w.ShowDialog() == true)

                Reload();

        }



        void OnDelete(object sender, RoutedEventArgs e)

        {

            if (!SessionContext.Can(PermissionCodes.GroupsDelete))

                return;

            var id = (sender as FrameworkElement)?.Tag as string;

            if (string.IsNullOrEmpty(id))

                return;

            var card = CardsHost.Items.OfType<GroupCardVm>().FirstOrDefault(c => c.Id == id);

            var name = card != null ? card.Name : "گروه";

            if (MessageBox.Show("گروه «" + name + "» حذف شود؟", AppConstants.AppNameFa,

                    MessageBoxButton.YesNo, MessageBoxImage.Warning) != MessageBoxResult.Yes)

                return;

            SessionContext.Groups.SoftDelete(id);

            Reload();

        }



        void OnExport(object sender, RoutedEventArgs e)

        {

            var id = (sender as FrameworkElement)?.Tag as string;

            if (string.IsNullOrEmpty(id))

                return;

            var g = SessionContext.Groups.Get(id);

            if (g == null)

                return;

            var ids = new HashSet<string>(SessionContext.Groups.MemberIds(g.Id));

            var people = SessionContext.Employees.Search(new ParsedQuery()).Where(p => ids.Contains(p.Id)).ToList();



            var colsDlg = new ExportColumnsWindow(_lastExportColumnKeys)

            {

                Owner = Window.GetWindow(this)

            };

            if (colsDlg.ShowDialog() != true || colsDlg.ColumnKeys == null || colsDlg.ColumnKeys.Length == 0)

                return;

            _lastExportColumnKeys = colsDlg.ColumnKeys;



            var catalog = ExcelService.Catalog().ToDictionary(c => c.Key);

            var columns = new List<ReportColumn>();

            foreach (var key in colsDlg.ColumnKeys)

            {

                ReportColumn c;

                if (!catalog.TryGetValue(key, out c))

                    continue;

                columns.Add(new ReportColumn

                {

                    Key = c.Key,

                    TitleFa = c.TitleFa,

                    Group = c.Group,

                    Selected = true

                });

            }



            var dlg = new SaveFileDialog { Filter = "Excel|*.xlsx", FileName = g.Name + ".xlsx" };

            if (dlg.ShowDialog() != true)

                return;

            ExcelService.ExportEmployees(dlg.FileName, people, columns,

                new ReportExportOptions { Title = "گزارش گروه " + g.Name, ShowLogo = true, HeaderText = AppConstants.OrganizationNameFa },

                ReportAssets.LogoPng());

        }



        void OnAddActivity(object sender, RoutedEventArgs e)

        {

            var id = (sender as FrameworkElement)?.Tag as string;

            if (string.IsNullOrEmpty(id))

                return;

            if (!SessionContext.Can(PermissionCodes.GroupsEdit)

                && !SessionContext.Can(PermissionCodes.GroupsCreate))

            {

                MessageBox.Show("دسترسی ثبت فعالیت ندارید.", AppConstants.AppNameFa);

                return;

            }

            var card = CardsHost.Items.OfType<GroupCardVm>().FirstOrDefault(c => c.Id == id);

            var w = new GroupActivityWindow(id, card != null ? card.Name : null)

            {

                Owner = Window.GetWindow(this)

            };

            if (w.ShowDialog() == true)

                Reload();

        }



        void OnDeleteActivity(object sender, RoutedEventArgs e)

        {

            var activityId = (sender as FrameworkElement)?.Tag as string;

            if (string.IsNullOrEmpty(activityId))

                return;

            if (!SessionContext.Can(PermissionCodes.GroupsEdit)

                && !SessionContext.Can(PermissionCodes.GroupsDelete))

            {

                MessageBox.Show("دسترسی حذف فعالیت ندارید.", AppConstants.AppNameFa);

                return;

            }

            if (MessageBox.Show("این فعالیت حذف شود؟", AppConstants.AppNameFa,

                    MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)

                return;

            SessionContext.Groups.SoftDeleteActivity(activityId);

            Reload();

        }



        sealed class GroupCardVm

        {

            public string Id { get; set; }

            public string Name { get; set; }

            public string StatusFa { get; set; }

            public Brush StatusBrush { get; set; }

            public string PurposeLine { get; set; }

            public string MemberLine { get; set; }

            public string StartLine { get; set; }

            public string EndLine { get; set; }

            public string Description { get; set; }

            public Visibility DescriptionVisibility { get; set; }

            public List<ActivityVm> Activities { get; set; }

            public string EmptyActivitiesText { get; set; }

            public Visibility EmptyActivitiesVisibility { get; set; }

            public Visibility ActivitiesPanelVisibility { get; set; }

            public BitmapImage PhotoImage { get; set; }

            public Visibility PhotoVisibility { get; set; }

            public Visibility PhotoPlaceholderVisibility { get; set; }



            public static GroupCardVm From(EmployeeGroup g, List<GroupActivity> acts)

            {

                var list = (acts ?? new List<GroupActivity>())

                    .Select(ActivityVm.From)

                    .ToList();

                var desc = (g.Description ?? "").Trim();

                var photo = PhotoImages.FromEmployee(g.PhotoPath, 96);

                return new GroupCardVm

                {

                    Id = g.Id,

                    Name = g.Name,

                    StatusFa = g.StatusFa,

                    StatusBrush = g.Status == "archived" ? ArchivedBrush : ActiveBrush,

                    PurposeLine = "نوع: " + g.PurposeFa,

                    MemberLine = "اعضا: " + PersianDate.DigitsFa(g.MemberCount.ToString()),

                    StartLine = "شروع: " + (string.IsNullOrWhiteSpace(g.StartsFa) ? "—" : g.StartsFa),

                    EndLine = "پایان: " + (string.IsNullOrWhiteSpace(g.EndsFa) ? "—" : g.EndsFa),

                    Description = desc,

                    DescriptionVisibility = desc.Length > 0 ? Visibility.Visible : Visibility.Collapsed,

                    Activities = list,

                    EmptyActivitiesText = "هنوز فعالیتی ثبت نشده است.",

                    EmptyActivitiesVisibility = list.Count == 0 ? Visibility.Visible : Visibility.Collapsed,

                    ActivitiesPanelVisibility = list.Count > 0 ? Visibility.Visible : Visibility.Collapsed,

                    PhotoImage = photo,

                    PhotoVisibility = photo != null ? Visibility.Visible : Visibility.Collapsed,

                    PhotoPlaceholderVisibility = photo == null ? Visibility.Visible : Visibility.Collapsed

                };

            }

        }



        sealed class ActivityVm

        {

            public string Id { get; set; }

            public string SummaryLine { get; set; }

            public string Note { get; set; }

            public Visibility NoteVisibility { get; set; }



            public static ActivityVm From(GroupActivity a)

            {

                var note = (a.Note ?? "").Trim();

                return new ActivityVm

                {

                    Id = a.Id,

                    SummaryLine = a.SummaryLine,

                    Note = note,

                    NoteVisibility = note.Length > 0 ? Visibility.Visible : Visibility.Collapsed

                };

            }

        }

    }

}


