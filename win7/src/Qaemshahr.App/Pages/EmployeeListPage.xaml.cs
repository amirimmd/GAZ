using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.Win32;
using Qaemshahr.App.Services;
using Qaemshahr.App.Views;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Pages
{
    public partial class EmployeeListPage : Page
    {
        List<Employee> _all = new List<Employee>();
        List<Employee> _filtered = new List<Employee>();
        Employee _selected;
        Border _selectedCard;
        string _dashFilter;
        string _dashValue;
        HashSet<string> _photos = new HashSet<string>();
        HashSet<string> _birthDocs = new HashSet<string>();
        HashSet<string> _nationalDocs = new HashSet<string>();
        HashSet<string> _groupMembers = new HashSet<string>();
        int _peoplePage;
        const int PeoplePageSize = 48;
        readonly DispatcherTimer _searchDebounce = new DispatcherTimer { Interval = TimeSpan.FromMilliseconds(250) };
        string _expandedEmployeeId;

        sealed class CardState
        {
            public Employee Employee;
            public StackPanel Details;
            public Button ExpandButton;
        }

        public EmployeeListPage() : this(null, null)
        {
        }

        public EmployeeListPage(string dashboardFilter, string dashboardValue)
        {
            InitializeComponent();
            _dashFilter = dashboardFilter;
            _dashValue = dashboardValue;
            NewButton.IsEnabled = SessionContext.Can(PermissionCodes.EmployeesCreate);
            ImportButton.IsEnabled = SessionContext.Can(PermissionCodes.EmployeesImport);
            ExportButton.IsEnabled = SessionContext.Can(PermissionCodes.EmployeesExport);
            _searchDebounce.Tick += (s, e) =>
            {
                _searchDebounce.Stop();
                ApplyFilter();
            };
            UpdateFilterBanner();
            Reload();
        }

        void Reload()
        {
            // بدون Attach عملکرد/نمونه برای همه — سرعت باز شدن تب
            _all = SessionContext.Employees.Search(new ParsedQuery(), null, 0, false)
                ?? new List<Employee>();
            if (HrDashboardAnalytics.FilterNeedsFiles(_dashFilter))
            {
                var sets = SessionContext.Dashboard.FileSetsFor(_all);
                _photos = sets.Photos;
                _birthDocs = sets.Birth;
                _nationalDocs = sets.National;
            }
            LoadGroupMembersForFilter();
            // نشان‌ها فقط برای صفحهٔ جاری در RenderPeoplePage
            _peoplePage = 0;
            ApplyFilter();
        }

        void LoadGroupMembersForFilter()
        {
            _groupMembers = new HashSet<string>(StringComparer.Ordinal);
            if (!HrDashboardAnalytics.FilterNeedsGroupMembers(_dashFilter) || SessionContext.Groups == null)
                return;
            if (_dashFilter == DashboardFilter.Group && !string.IsNullOrWhiteSpace(_dashValue))
            {
                foreach (var id in SessionContext.Groups.MemberIds(_dashValue) ?? new List<string>())
                {
                    if (!string.IsNullOrEmpty(id))
                        _groupMembers.Add(id);
                }
                return;
            }
            var groups = SessionContext.Groups.List(null, null) ?? new List<EmployeeGroup>();
            foreach (var g in groups)
            {
                if (g == null || string.IsNullOrEmpty(g.Id))
                    continue;
                foreach (var id in SessionContext.Groups.MemberIds(g.Id) ?? new List<string>())
                {
                    if (!string.IsNullOrEmpty(id))
                        _groupMembers.Add(id);
                }
            }
        }

        void OnSearch(object sender, TextChangedEventArgs e)
        {
            _searchDebounce.Stop();
            _searchDebounce.Start();
        }

        void ApplyFilter()
        {
            var q = (SearchBox.Text ?? string.Empty).Trim();
            IEnumerable<Employee> src = _all;
            if (q.Length > 0)
            {
                var nq = q.ToLowerInvariant();
                src = _all.Where(e =>
                    (e.FullName ?? "").IndexOf(q, StringComparison.OrdinalIgnoreCase) >= 0
                    || (e.NationalId ?? "").IndexOf(nq, StringComparison.OrdinalIgnoreCase) >= 0
                    || (e.EmployeeNumber ?? "").IndexOf(nq, StringComparison.OrdinalIgnoreCase) >= 0
                    || (e.PrimaryPhone ?? "").IndexOf(nq, StringComparison.OrdinalIgnoreCase) >= 0);
            }
            if (!string.IsNullOrEmpty(_dashFilter))
            {
                var year = PersianDate.CurrentYear();
                var season = EvaluationScoring.CurrentSeason();
                src = src.Where(e => HrDashboardAnalytics.MatchesFilter(
                    e, _dashFilter, _dashValue, _photos, _birthDocs, _nationalDocs, year, season, _groupMembers));
            }
            _filtered = src.ToList();
            _peoplePage = 0;
            EmptyText.Visibility = _filtered.Count == 0 ? Visibility.Visible : Visibility.Collapsed;
            RenderPeoplePage();
        }

        int PeoplePageCount()
        {
            if (_filtered == null || _filtered.Count == 0)
                return 1;
            return (_filtered.Count + PeoplePageSize - 1) / PeoplePageSize;
        }

        void RenderPeoplePage()
        {
            CardsHost.Children.Clear();
            _selectedCard = null;
            var keep = _selected;
            _selected = null;
            if (_filtered == null || _filtered.Count == 0)
            {
                UpdatePeoplePager();
                return;
            }
            var pages = PeoplePageCount();
            if (_peoplePage >= pages)
                _peoplePage = pages - 1;
            if (_peoplePage < 0)
                _peoplePage = 0;
            var pageItems = _filtered.Skip(_peoplePage * PeoplePageSize).Take(PeoplePageSize).ToList();
            // نشان ارزیابی/نمونه فقط برای همین صفحه
            try
            {
                if (SessionContext.Database != null)
                {
                    new PerformanceReviewRepository(SessionContext.Database).AttachLatestApproved(pageItems);
                    new SampleTitleRepository(SessionContext.Database).AttachForYear(pageItems, PersianDate.CurrentYear());
                }
            }
            catch
            {
            }
            foreach (var emp in pageItems)
            {
                var card = BuildCard(emp);
                CardsHost.Children.Add(card);
                if (keep != null && emp.Id == keep.Id)
                    SelectCard(card, emp);
            }
            UpdatePeoplePager();
        }

        void UpdatePeoplePager()
        {
            var total = _filtered == null ? 0 : _filtered.Count;
            var pages = PeoplePageCount();
            var page = Math.Min(_peoplePage + 1, pages);
            if (PeoplePageInfo != null)
            {
                PeoplePageInfo.Text = total == 0
                    ? "بدون ردیف"
                    : "صفحه " + PersianDate.DigitsFa(page.ToString())
                      + " از " + PersianDate.DigitsFa(pages.ToString())
                      + "  ·  "
                      + PersianDate.DigitsFa(total.ToString()) + " نفر";
            }
            if (PrevPeoplePage != null)
                PrevPeoplePage.IsEnabled = _peoplePage > 0 && total > 0;
            if (NextPeoplePage != null)
                NextPeoplePage.IsEnabled = _peoplePage < pages - 1 && total > 0;
        }

        void OnPrevPeoplePage(object sender, RoutedEventArgs e)
        {
            if (_peoplePage <= 0)
                return;
            _peoplePage--;
            RenderPeoplePage();
        }

        void OnNextPeoplePage(object sender, RoutedEventArgs e)
        {
            if (_peoplePage >= PeoplePageCount() - 1)
                return;
            _peoplePage++;
            RenderPeoplePage();
        }

        Border BuildCard(Employee emp)
        {
            var primary = TryFindResource("PrimaryBrush") as Brush ?? Brushes.SteelBlue;
            var muted = TryFindResource("MutedBrush") as Brush ?? Brushes.Gray;
            var borderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.LightGray;

            var photo = new Border
            {
                Width = 64,
                Height = 86,
                CornerRadius = new CornerRadius(8),
                Background = TryFindResource("FieldBgBrush") as Brush
                    ?? new SolidColorBrush(Color.FromRgb(0xEE, 0xF3, 0xF6)),
                ClipToBounds = true
            };
            var img = PhotoImages.FromEmployee(emp.PhotoPath);
            if (img != null)
                photo.Child = new Image { Source = img, Stretch = Stretch.UniformToFill };
            else
                photo.Child = GenderAvatars.ForEmployee(emp);

            var details = new StackPanel
            {
                Margin = new Thickness(0, 10, 0, 0),
                Visibility = Visibility.Collapsed
            };
            details.Children.Add(DetailLine("کد ملی", emp.NationalId, muted));
            details.Children.Add(DetailLine("تلفن", emp.PrimaryPhone, muted));
            details.Children.Add(DetailLine("نوع استخدام", emp.EmploymentType, muted));
            details.Children.Add(DetailLine("نوع پرسنل", emp.PersonTypeFa, muted));
            details.Children.Add(DetailLine("پایه سمت", emp.PositionBase.HasValue ? emp.PositionBase.Value.ToString("0.##") : "—", muted));
            details.Children.Add(DetailLine("پایه شخصی", emp.PersonalBase.HasValue ? emp.PersonalBase.Value.ToString("0.##") : "—", muted));
            details.Children.Add(DetailLine("گروه شغلی", string.IsNullOrWhiteSpace(emp.JobGroup) ? "—" : emp.JobGroup, muted));
            details.Children.Add(DetailLine("وضعیت", emp.StatusFa, muted));
            if (!string.IsNullOrWhiteSpace(emp.RetirementDate))
                details.Children.Add(DetailLine("بازنشستگی", PersianDate.DigitsFa(emp.RetirementDate), muted));
            if (emp.EmploymentStatus == "inactive" && !string.IsNullOrWhiteSpace(emp.InactiveReasonFa))
                details.Children.Add(DetailLine("دلیل غیرفعال", emp.InactiveReasonFa, muted));
            if (emp.SampleHistory != null && emp.SampleHistory.Count > 0)
            {
                details.Children.Add(DetailLine("عناوین نمونه", emp.SampleHistory[0], muted));
                for (var i = 1; i < emp.SampleHistory.Count; i++)
                    details.Children.Add(DetailLine("", emp.SampleHistory[i], muted));
            }

            var expandBtn = new Button
            {
                Content = "جزئیات ▾",
                Style = TryFindResource("GhostButton") as Style,
                Padding = new Thickness(10, 4, 10, 4),
                MinHeight = 30,
                MinWidth = 72,
                FontSize = 12,
                Margin = new Thickness(0, 8, 0, 0),
                HorizontalAlignment = HorizontalAlignment.Right
            };
            expandBtn.Click += (s, e) =>
            {
                e.Handled = true;
                ToggleDetails(emp.Id, details, expandBtn);
            };

            var state = new CardState { Employee = emp, Details = details, ExpandButton = expandBtn };

            var menuBtn = new Button
            {
                Content = "⋮",
                Width = 34,
                Height = 34,
                Padding = new Thickness(0),
                MinWidth = 34,
                MinHeight = 34,
                Margin = new Thickness(0),
                FontSize = 18,
                FontWeight = FontWeights.Bold,
                Background = Brushes.Transparent,
                BorderThickness = new Thickness(0),
                Cursor = Cursors.Hand,
                ToolTip = "منوی عملیات",
                Tag = emp
            };
            var menu = new ContextMenu { FlowDirection = FlowDirection.RightToLeft };
            var editItem = new MenuItem { Header = "ویرایش پرونده" };
            editItem.Click += (s, e) => { SelectCardByEmployee(emp); OpenEdit(emp); };
            var expandItem = new MenuItem { Header = "نمایش / پنهان جزئیات" };
            expandItem.Click += (s, e) => expandBtn.RaiseEvent(new RoutedEventArgs(ButtonBase.ClickEvent));
            menu.Items.Add(editItem);
            menu.Items.Add(expandItem);
            if (SessionContext.Can(PermissionCodes.EmployeesDelete))
            {
                menu.Items.Add(new Separator());
                var delItem = new MenuItem { Header = "حذف کارمند" };
                delItem.Click += (s, e) =>
                {
                    SelectCardByEmployee(emp);
                    OnDelete(s, e);
                };
                menu.Items.Add(delItem);
            }
            menuBtn.Click += (s, e) =>
            {
                e.Handled = true;
                SelectCardByEmployee(emp);
                menu.PlacementTarget = menuBtn;
                menu.Placement = PlacementMode.Bottom;
                menu.IsOpen = true;
            };

            var titleRow = new DockPanel { Margin = new Thickness(0, 0, 0, 4) };
            DockPanel.SetDock(menuBtn, Dock.Left);
            titleRow.Children.Add(menuBtn);
            titleRow.Children.Add(new TextBlock
            {
                Text = emp.FullName,
                FontWeight = FontWeights.SemiBold,
                FontSize = 15,
                TextWrapping = TextWrapping.Wrap,
                VerticalAlignment = VerticalAlignment.Center
            });

            var info = new StackPanel { VerticalAlignment = VerticalAlignment.Top };
            info.Children.Add(titleRow);
            info.Children.Add(new TextBlock
            {
                Text = string.IsNullOrWhiteSpace(emp.CurrentPosition) ? "بدون سمت" : emp.CurrentPosition,
                Foreground = muted,
                Margin = new Thickness(0, 2, 0, 0),
                TextWrapping = TextWrapping.Wrap,
                FontSize = 13
            });
            info.Children.Add(BuildStatusChip(emp));
            var sampleBadges = BuildSampleBadges(emp);
            if (sampleBadges != null)
                info.Children.Add(sampleBadges);
            info.Children.Add(expandBtn);
            info.Children.Add(details);

            var body = new DockPanel { Margin = new Thickness(0, 2, 0, 0) };
            DockPanel.SetDock(photo, Dock.Right);
            photo.Margin = new Thickness(12, 0, 0, 0);
            body.Children.Add(photo);
            body.Children.Add(info);

            var stack = new DockPanel();
            stack.Children.Add(body);

            // اگر این کارت قبلاً باز بوده، باز نگه دار
            if (!string.IsNullOrEmpty(_expandedEmployeeId)
                && string.Equals(_expandedEmployeeId, emp.Id, StringComparison.Ordinal))
            {
                details.Visibility = Visibility.Visible;
                expandBtn.Content = "جزئیات ▴";
            }

            var card = new Border
            {
                Width = 340,
                Padding = new Thickness(14, 12, 14, 12),
                Margin = new Thickness(0, 0, 14, 14),
                Background = TryFindResource("SurfaceBrush") as Brush ?? Brushes.White,
                BorderBrush = borderBrush,
                BorderThickness = new Thickness(1),
                CornerRadius = new CornerRadius(14),
                Cursor = Cursors.Hand,
                VerticalAlignment = VerticalAlignment.Top,
                Tag = state,
                Child = stack,
                Effect = new System.Windows.Media.Effects.DropShadowEffect
                {
                    BlurRadius = 12,
                    ShadowDepth = 1,
                    Opacity = 0.08,
                    Color = Colors.Black
                }
            };
            card.MouseLeftButtonUp += (s, e) =>
            {
                if (e.OriginalSource is DependencyObject d && FindParentButton(d) != null)
                    return;
                SelectCard(card, emp);
            };
            card.MouseLeftButtonDown += (s, e) =>
            {
                if (e.ClickCount == 2)
                {
                    SelectCard(card, emp);
                    OpenEdit(emp);
                }
            };
            return card;
        }

        void ToggleDetails(string employeeId, StackPanel details, Button expandBtn)
        {
            var open = details.Visibility != Visibility.Visible;
            if (open)
            {
                CollapseAllDetails();
                details.Visibility = Visibility.Visible;
                expandBtn.Content = "جزئیات ▴";
                _expandedEmployeeId = employeeId;
            }
            else
            {
                details.Visibility = Visibility.Collapsed;
                expandBtn.Content = "جزئیات ▾";
                if (string.Equals(_expandedEmployeeId, employeeId, StringComparison.Ordinal))
                    _expandedEmployeeId = null;
            }
        }

        void CollapseAllDetails()
        {
            if (CardsHost == null)
                return;
            foreach (Border card in CardsHost.Children)
            {
                var state = card == null ? null : card.Tag as CardState;
                if (state == null || state.Details == null)
                    continue;
                state.Details.Visibility = Visibility.Collapsed;
                if (state.ExpandButton != null)
                    state.ExpandButton.Content = "جزئیات ▾";
            }
        }

        static Button FindParentButton(DependencyObject start)
        {
            var d = start;
            while (d != null)
            {
                if (d is Button)
                    return (Button)d;
                d = VisualTreeHelper.GetParent(d);
            }
            return null;
        }

        FrameworkElement BuildStatusChip(Employee emp)
        {
            var active = emp.EmploymentStatus != "inactive";
            return new Border
            {
                Margin = new Thickness(0, 8, 0, 0),
                HorizontalAlignment = HorizontalAlignment.Right,
                Background = new SolidColorBrush(active
                    ? Color.FromRgb(0xE8, 0xF5, 0xE9)
                    : Color.FromRgb(0xFF, 0xEB, 0xEE)),
                CornerRadius = new CornerRadius(8),
                Padding = new Thickness(8, 3, 8, 3),
                Child = new TextBlock
                {
                    Text = emp.StatusFa,
                    FontSize = 11,
                    Foreground = new SolidColorBrush(active
                        ? Color.FromRgb(0x2E, 0x7D, 0x32)
                        : Color.FromRgb(0xC6, 0x28, 0x28))
                }
            };
        }

        FrameworkElement BuildSampleBadges(Employee emp)
        {
            var hasCurrent = emp.PerformanceExemplary || emp.ExtraOrgBadge;
            var hasHistory = emp.SampleHistory != null && emp.SampleHistory.Count > 0;
            if (!hasCurrent && !hasHistory)
                return null;

            var badges = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                Margin = new Thickness(0, 10, 0, 0)
            };
            if (emp.PerformanceExemplary)
            {
                var label = emp.SampleKind == SampleTitleKinds.WorkerSample
                    ? "★ کارگر نمونه"
                    : "★ کارمند نمونه";
                if (emp.SampleYear > 0)
                    label += " " + PersianDate.DigitsFa(emp.SampleYear.ToString());
                badges.Children.Add(MiniBadge(label, Color.FromRgb(0x2E, 0x7D, 0x32)));
            }
            else if (hasHistory)
            {
                // فقط سابقه سال‌های قبل — نشان خلاصه روی کارت
                var first = emp.SampleHistory[0];
                var shortLabel = first.IndexOf('—') > 0
                    ? "★ " + first.Substring(0, first.IndexOf('—')).Trim()
                    : "★ نمونه";
                badges.Children.Add(MiniBadge(shortLabel, Color.FromRgb(0x55, 0x8B, 0x2F)));
            }
            if (emp.ExtraOrgBadge)
            {
                var label = "معرفی فراسازمانی";
                if (emp.IntroducedOrganizations != null && emp.IntroducedOrganizations.Count > 0)
                {
                    label = emp.IntroducedOrganizations.Count == 1
                        ? "معرفی به " + emp.IntroducedOrganizations[0]
                        : "فراسازمانی (" + PersianDate.DigitsFa(emp.IntroducedOrganizations.Count.ToString()) + ")";
                }
                var badge = MiniBadge(label, Color.FromRgb(0x0F, 0x4C, 0x5C));
                if (emp.IntroducedOrganizations != null && emp.IntroducedOrganizations.Count > 0)
                    badge.ToolTip = string.Join("\n", emp.IntroducedOrganizations);
                badges.Children.Add(badge);
            }
            return badges;
        }

        static Border MiniBadge(string text, Color bg)
        {
            return new Border
            {
                Background = new SolidColorBrush(bg),
                CornerRadius = new CornerRadius(7),
                Padding = new Thickness(7, 2, 7, 2),
                Margin = new Thickness(0, 0, 6, 0),
                Child = new TextBlock
                {
                    Text = text,
                    FontSize = 10,
                    FontWeight = FontWeights.SemiBold,
                    Foreground = Brushes.White
                }
            };
        }

        static TextBlock DetailLine(string label, string value, Brush muted)
        {
            var text = string.IsNullOrWhiteSpace(label)
                ? (string.IsNullOrWhiteSpace(value) ? "—" : value)
                : label + ": " + (string.IsNullOrWhiteSpace(value) ? "—" : value);
            return new TextBlock
            {
                Text = text,
                FontSize = 12,
                Foreground = muted,
                Margin = new Thickness(0, 0, 0, 4),
                TextWrapping = TextWrapping.Wrap
            };
        }

        void SelectCardByEmployee(Employee emp)
        {
            foreach (Border card in CardsHost.Children)
            {
                var state = card.Tag as CardState;
                var match = state != null ? state.Employee : card.Tag as Employee;
                if (match == emp || (match != null && emp != null && match.Id == emp.Id))
                {
                    SelectCard(card, emp);
                    return;
                }
            }
        }

        void SelectCard(Border card, Employee emp)
        {
            if (_selectedCard != null)
            {
                _selectedCard.BorderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.LightGray;
                _selectedCard.BorderThickness = new Thickness(1);
            }
            _selected = emp;
            _selectedCard = card;
            card.BorderBrush = TryFindResource("PrimaryBrush") as Brush ?? Brushes.SteelBlue;
            card.BorderThickness = new Thickness(2);
        }

        void UpdateFilterBanner()
        {
            if (string.IsNullOrEmpty(_dashFilter))
            {
                FilterBanner.Visibility = Visibility.Collapsed;
                return;
            }
            FilterBanner.Visibility = Visibility.Visible;
            FilterBannerText.Text = "فیلتر داشبورد: " + DashboardFilter.TitleFa(_dashFilter, _dashValue);
        }

        void OnClearDashboardFilter(object sender, RoutedEventArgs e)
        {
            _dashFilter = null;
            _dashValue = null;
            UpdateFilterBanner();
            ApplyFilter();
        }

        void OnNew(object sender, RoutedEventArgs e)
        {
            var w = new EmployeeEditWindow(null) { Owner = Window.GetWindow(this) };
            if (w.ShowDialog() == true)
                Reload();
        }

        void OnEdit(object sender, RoutedEventArgs e)
        {
            OpenEdit(_selected);
        }

        void OpenEdit(Employee row)
        {
            if (row == null)
                return;
            var w = new EmployeeEditWindow(row.Id) { Owner = Window.GetWindow(this) };
            if (w.ShowDialog() == true)
                Reload();
        }

        void OnDelete(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.EmployeesDelete))
            {
                MessageBox.Show("دسترسی حذف ندارید.");
                return;
            }
            var row = _selected;
            if (row == null)
                return;
            if (MessageBox.Show("کارمند «" + row.FullName + "» حذف شود؟", AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Warning) != MessageBoxResult.Yes)
                return;
            EmployeePhotoStore.Delete(row.PhotoPath);
            SessionContext.Employees.SoftDelete(row.Id);
            SessionContext.Audit.Add(SessionContext.Current.User.Id, SessionContext.Current.User.Username, "employee_delete", "employee", row.Id);
            _selected = null;
            Reload();
        }

        void OnImport(object sender, RoutedEventArgs e)
        {
            var w = new BulkImportWindow { Owner = Window.GetWindow(this) };
            if (w.ShowDialog() == true)
                Reload();
        }

        void OnExport(object sender, RoutedEventArgs e)
        {
            var dlg = new SaveFileDialog { Filter = "Excel|*.xlsx", FileName = "employees.xlsx" };
            if (dlg.ShowDialog() != true)
                return;
            ExcelService.ExportEmployees(dlg.FileName, _all, ExcelService.Catalog(),
                new ReportExportOptions { Title = "فهرست کارکنان", ShowLogo = true, ShowPhotos = true, HeaderText = AppConstants.OrganizationNameFa },
                ReportAssets.LogoPng());
            MessageBox.Show("فایل ذخیره شد.");
        }
    }
}
