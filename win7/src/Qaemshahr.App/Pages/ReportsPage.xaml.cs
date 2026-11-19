using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.Win32;
using Qaemshahr.App.Controls;
using Qaemshahr.App.Services;
using Qaemshahr.App.Views;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Pages
{
    public partial class ReportsPage : Page
    {
        readonly List<ReportColumn> _cols;
        readonly List<string> _order = new List<string>();
        readonly List<string> _jobGroupOptions = new List<string>();
        readonly List<string> _employmentOptions = new List<string>();
        readonly Dictionary<string, List<string>> _enumSelections = new Dictionary<string, List<string>>(StringComparer.Ordinal);
        readonly List<CheckBox> _matchBoxes = new List<CheckBox>();
        readonly HashSet<string> _exportIds = new HashSet<string>(StringComparer.Ordinal);
        List<Employee> _matchedPeople = new List<Employee>();
        int _resultPage;
        const int ResultPageSize = 50;
        ReportEmployeeFilter _filter = ReportEmployeeFilter.CreateDefault();
        string _layoutId = ReportLayoutRepository.DefaultId;
        string _selectedGroupId;
        bool _groupFilterUiReady;
        string _watermarkMode = "none";
        string _orientation = "auto";
        bool _ready;
        bool _matchSync;
        bool _exporting;
        Popup _openPopup;
        List<Employee> _peopleCache;
        bool _docsAttached;
        readonly DispatcherTimer _matchDebounce = new DispatcherTimer { Interval = TimeSpan.FromMilliseconds(280) };

        public ReportsPage()
        {
            InitializeComponent();
            HeaderBox.Text = AppConstants.OrganizationNameFa;
            FooterBox.Text = AppConstants.AppNameFa;
            WatermarkBox.Text = AppConstants.AppNameFa;
            _cols = ExcelService.Catalog().ToList();
            _matchDebounce.Tick += (s, e) =>
            {
                _matchDebounce.Stop();
                RefreshMatchList(true);
            };
            LoadLookupOptions();
            BuildSortUi();
            SessionContext.ReportLayouts.EnsureDefaults();
            RebuildLayoutButtons();
            ApplyLayout(SessionContext.ReportLayouts.Get(_layoutId), false);
            _ready = true;
            ReloadGroupFilterUi();
            ScheduleMatchRefresh();
        }

        void ScheduleMatchRefresh()
        {
            if (!_ready)
            {
                RefreshMatchList(true);
                return;
            }
            _matchDebounce.Stop();
            _matchDebounce.Start();
        }

        void InvalidatePeopleCache()
        {
            _peopleCache = null;
            _docsAttached = false;
        }

        void ReloadGroupFilterUi()
        {
            if (GroupFilterBox == null)
                return;
            _groupFilterUiReady = false;
            var keep = _selectedGroupId;
            GroupFilterBox.Items.Clear();
            GroupFilterBox.Items.Add(new ComboBoxItem
            {
                Content = "بدون گروه — استفاده از فیلترهای عادی",
                Tag = ""
            });
            try
            {
                var groups = SessionContext.Groups != null
                    ? SessionContext.Groups.List(null, null) ?? new List<EmployeeGroup>()
                    : new List<EmployeeGroup>();
                foreach (var g in groups)
                {
                    var label = (g.Name ?? "بدون نام").Trim()
                        + "  (" + PersianDate.DigitsFa(g.MemberCount.ToString()) + " نفر"
                        + (g.Status == "archived" ? " · بایگانی" : "")
                        + ")";
                    GroupFilterBox.Items.Add(new ComboBoxItem
                    {
                        Content = label,
                        Tag = g.Id
                    });
                }
            }
            catch
            {
            }

            ComboBoxItem selected = null;
            foreach (ComboBoxItem item in GroupFilterBox.Items)
            {
                var tag = (item.Tag as string) ?? "";
                if (string.Equals(tag, keep ?? "", StringComparison.Ordinal))
                {
                    selected = item;
                    break;
                }
            }
            GroupFilterBox.SelectedItem = selected ?? GroupFilterBox.Items[0] as ComboBoxItem;
            _groupFilterUiReady = true;
            UpdateGroupFilterChrome();
        }

        void OnGroupFilterExpand(object sender, RoutedEventArgs e)
        {
            ReloadGroupFilterUi();
        }

        void OnGroupFilterChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!_ready || !_groupFilterUiReady)
                return;
            var item = GroupFilterBox.SelectedItem as ComboBoxItem;
            _selectedGroupId = item == null ? null : (item.Tag as string);
            if (string.IsNullOrWhiteSpace(_selectedGroupId))
                _selectedGroupId = null;
            UpdateGroupFilterChrome();
            RefreshMatchCount();
        }

        void OnClearGroupFilter(object sender, RoutedEventArgs e)
        {
            _selectedGroupId = null;
            if (GroupFilterBox.Items.Count > 0)
                GroupFilterBox.SelectedIndex = 0;
            UpdateGroupFilterChrome();
            RefreshMatchCount();
        }

        void UpdateGroupFilterChrome()
        {
            var on = !string.IsNullOrWhiteSpace(_selectedGroupId);
            if (ClassicFilterBar != null)
                ClassicFilterBar.Opacity = on ? 0.45 : 1;
            if (SearchBox != null)
                SearchBox.IsEnabled = !on;
            if (SortByBox != null)
                SortByBox.IsEnabled = true;
            if (SortDirBox != null)
                SortDirBox.IsEnabled = true;
            if (GroupFilterHint != null)
            {
                GroupFilterHint.Text = on
                    ? "گروه انتخاب شده است؛ فیلترهای جستجو/وضعیت و … اعمال نمی‌شوند. مرتب‌سازی همچنان فعال است."
                    : "با انتخاب گروه، فقط اعضای همان گروه برای خروجی می‌آیند و فیلترهای دیگر اعمال نمی‌شوند.";
            }
            if (GroupFilterExpander != null && on && !GroupFilterExpander.IsExpanded)
                GroupFilterExpander.IsExpanded = true;
        }

        void LoadLookupOptions()
        {
            _employmentOptions.Clear();
            _employmentOptions.AddRange(ReportFilterDefs.EmploymentTypes);
            _jobGroupOptions.Clear();
            try
            {
                var people = SessionContext.Employees.Search(new ParsedQuery(), null, 5000, false);
                foreach (var e in people)
                {
                    var t = (e.EmploymentType ?? "").Trim();
                    if (t.Length > 0 && !_employmentOptions.Any(x => string.Equals(x, t, StringComparison.CurrentCultureIgnoreCase)))
                        _employmentOptions.Add(t);
                }
                foreach (var g in SessionContext.Employees.ListDistinctJobGroups())
                {
                    var t = (g ?? "").Trim();
                    if (t.Length > 0)
                        _jobGroupOptions.Add(t);
                }
            }
            catch
            {
            }
        }

        void BuildSortUi()
        {
            SortByBox.Items.Clear();
            for (var i = 0; i < ReportFilterDefs.SortKeys.Length; i++)
                SortByBox.Items.Add(new ComboBoxItem
                {
                    Content = ReportFilterDefs.SortLabels[i],
                    Tag = ReportFilterDefs.SortKeys[i]
                });
            SortByBox.SelectedIndex = 0;
            SortDirBox.Items.Clear();
            SortDirBox.Items.Add(new ComboBoxItem { Content = "صعودی", Tag = "asc" });
            SortDirBox.Items.Add(new ComboBoxItem { Content = "نزولی", Tag = "desc" });
            SortDirBox.SelectedIndex = 0;
        }

        void RebuildLayoutButtons()
        {
            LayoutButtonsHost.Children.Clear();
            foreach (var layout in SessionContext.ReportLayouts.ListAll())
            {
                var btn = new Button
                {
                    Content = string.IsNullOrWhiteSpace(layout.Name) ? layout.Id : layout.Name,
                    Tag = layout.Id,
                    Style = (Style)FindResource(
                        layout.Id == _layoutId ? "ChipButtonSelected" : "ChipButton"),
                    Margin = new Thickness(0, 0, 8, 8),
                    MinWidth = 96,
                    MinHeight = 34,
                    Padding = new Thickness(12, 6, 12, 6),
                    VerticalAlignment = VerticalAlignment.Center
                };
                btn.Click += OnSelectLayout;
                if (!string.Equals(layout.Id, ReportLayoutRepository.DefaultId, StringComparison.OrdinalIgnoreCase))
                {
                    btn.MouseRightButtonUp += (s, e) =>
                    {
                        e.Handled = true;
                        ConfirmDeleteLayout(layout.Id, layout.Name);
                    };
                    var tip = new ToolTip { Content = "کلیک راست برای حذف" };
                    btn.ToolTip = tip;
                }
                LayoutButtonsHost.Children.Add(btn);
            }

            var plus = new Button
            {
                Content = "+",
                Style = (Style)FindResource("PrimaryButton"),
                MinWidth = 44,
                MinHeight = 34,
                Margin = new Thickness(0, 0, 8, 8),
                FontWeight = FontWeights.Bold,
                FontSize = 16,
                Padding = new Thickness(10, 4, 10, 4),
                VerticalAlignment = VerticalAlignment.Center,
                ToolTip = "چیدمان جدید"
            };
            plus.Click += OnAddLayout;
            LayoutButtonsHost.Children.Add(plus);
        }

        void ConfirmDeleteLayout(string id, string name)
        {
            if (MessageBox.Show(
                    "چیدمان «" + name + "» حذف شود؟",
                    AppConstants.AppNameFa,
                    MessageBoxButton.YesNo,
                    MessageBoxImage.Warning) != MessageBoxResult.Yes)
                return;
            SessionContext.ReportLayouts.Delete(id);
            if (string.Equals(_layoutId, id, StringComparison.OrdinalIgnoreCase))
            {
                _layoutId = ReportLayoutRepository.DefaultId;
                ApplyLayout(SessionContext.ReportLayouts.Get(_layoutId), true);
            }
            RebuildLayoutButtons();
            StatusText.Text = "چیدمان حذف شد.";
        }

        void OnAddLayout(object sender, RoutedEventArgs e)
        {
            var dlg = new ReportLayoutEditWindow("چیدمان جدید", OrderedKeys())
            {
                Owner = Window.GetWindow(this)
            };
            if (dlg.ShowDialog() != true)
                return;
            var id = SessionContext.ReportLayouts.NewId();
            SessionContext.ReportLayouts.Save(new ReportLayout
            {
                Id = id,
                Name = dlg.LayoutName,
                Options = ReadOptions(),
                ColumnKeys = dlg.ColumnKeys,
                Filters = ReportEmployeeFilter.CreateDefault()
            });
            _layoutId = id;
            ApplyLayout(SessionContext.ReportLayouts.Get(id), true);
            RebuildLayoutButtons();
            StatusText.Text = "چیدمان «" + dlg.LayoutName + "» ساخته شد.";
        }

        void OnEditColumns(object sender, RoutedEventArgs e)
        {
            var current = SessionContext.ReportLayouts.Get(_layoutId);
            var name = current != null ? current.Name : "پیش‌فرض";
            var dlg = new ReportLayoutEditWindow(name, OrderedKeys())
            {
                Owner = Window.GetWindow(this)
            };
            if (dlg.ShowDialog() != true)
                return;
            SetColumns(new HashSet<string>(dlg.ColumnKeys), false);
            _order.Clear();
            foreach (var k in dlg.ColumnKeys)
            {
                if (_cols.Any(c => c.Key == k) && !_order.Contains(k))
                    _order.Add(k);
            }
            EnsureFullOrder();
            RebuildFilterBar();
            if (current != null && !string.Equals(current.Id, ReportLayoutRepository.DefaultId, StringComparison.OrdinalIgnoreCase))
            {
                current.Name = dlg.LayoutName;
                current.ColumnKeys = OrderedKeys();
                current.Options = ReadOptions();
                current.Filters = ReadFilters();
                SessionContext.ReportLayouts.Save(current);
                RebuildLayoutButtons();
            }
            RefreshMatchCount();
            StatusText.Text = "ستون‌های چیدمان به‌روز شد.";
        }

        void OnSelectLayout(object sender, RoutedEventArgs e)
        {
            CloseOpenPopup();
            _layoutId = ((Button)sender).Tag as string ?? ReportLayoutRepository.DefaultId;
            ApplyLayout(SessionContext.ReportLayouts.Get(_layoutId), true);
            RebuildLayoutButtons();
            StatusText.Text = "چیدمان بارگذاری شد.";
        }

        void OnSaveLayout(object sender, RoutedEventArgs e)
        {
            if (SelectedCount() == 0)
            {
                StatusText.Text = "حداقل یک ستون انتخاب کنید.";
                return;
            }
            var current = SessionContext.ReportLayouts.Get(_layoutId);
            SessionContext.ReportLayouts.Save(new ReportLayout
            {
                Id = _layoutId,
                Name = current != null ? current.Name : "پیش‌فرض",
                Options = ReadOptions(),
                ColumnKeys = OrderedKeys(),
                Filters = ReadFilters()
            });
            RebuildLayoutButtons();
            StatusText.Text = "در «" + (current != null ? current.Name : "پیش‌فرض") + "» ذخیره شد.";
        }

        void OnResetFilters(object sender, RoutedEventArgs e)
        {
            CloseOpenPopup();
            _filter = ReportEmployeeFilter.CreateDefault();
            _enumSelections.Clear();
            InitEnumDefaults();
            SearchBox.Text = "";
            SelectComboByTag(SortByBox, "fullName");
            SelectComboByTag(SortDirBox, "asc");
            RebuildFilterBar();
            RefreshMatchCount();
            StatusText.Text = "فیلترها بازنشانی شد.";
        }

        void InitEnumDefaults()
        {
            _enumSelections["status"] = new List<string>(ReportFilterDefs.StatusLabels);
            _enumSelections["gender"] = new List<string>(ReportFilterDefs.GenderValues);
            _enumSelections["maritalStatus"] = new List<string>(ReportFilterDefs.MaritalValues);
            _enumSelections["bloodGroup"] = new List<string>(ReportFilterDefs.BloodValues);
            _enumSelections["militaryStatus"] = new List<string>(ReportFilterDefs.MilitaryValues);
            _enumSelections["employmentType"] = new List<string>();
            _enumSelections["personType"] = new List<string>();
            _enumSelections["jobGroup"] = new List<string>();
            foreach (var key in new[]
            {
                "birthPlace", "serviceCity", "veteranStatus", "position", "previousPosition", "desiredPosition",
                "educationLevel", "major", "university", "skillName", "skillLevel", "insuranceType"
            })
                _enumSelections[key] = new List<string>();
        }

        void RebuildFilterBar()
        {
            CloseOpenPopup();
            ScheduleMatchRefresh();
        }

        const double ColWidth = 168;
        const double CheckColWidth = 48;
        const double HeaderHeight = 118;

        void RefreshMatchList(bool selectAll)
        {
            try
            {
                _matchedPeople = FilteredPeople() ?? new List<Employee>();
                if (selectAll)
                    _resultPage = 0;
                var totalPages = ResultPageCount();
                if (_resultPage >= totalPages)
                    _resultPage = Math.Max(0, totalPages - 1);
                MatchCountText.Text = "تطبیق فعلی: " + PersianDate.DigitsFa(_matchedPeople.Count.ToString()) + " نفر";
                RebuildResultTable(selectAll);
            }
            catch
            {
                MatchCountText.Text = "";
                _matchedPeople = new List<Employee>();
                if (ResultTableHost != null)
                {
                    ResultTableHost.Children.Clear();
                    ResultTableHost.ColumnDefinitions.Clear();
                    ResultTableHost.RowDefinitions.Clear();
                }
                _matchBoxes.Clear();
                _exportIds.Clear();
                UpdateExportCount();
                UpdatePagerUi();
            }
        }

        int ResultPageCount()
        {
            var n = _matchedPeople == null ? 0 : _matchedPeople.Count;
            if (n <= 0)
                return 1;
            return (n + ResultPageSize - 1) / ResultPageSize;
        }

        List<Employee> CurrentPagePeople()
        {
            if (_matchedPeople == null || _matchedPeople.Count == 0)
                return new List<Employee>();
            var skip = _resultPage * ResultPageSize;
            if (skip < 0)
                skip = 0;
            return _matchedPeople.Skip(skip).Take(ResultPageSize).ToList();
        }

        void UpdatePagerUi()
        {
            var total = _matchedPeople == null ? 0 : _matchedPeople.Count;
            var pages = ResultPageCount();
            var page = Math.Min(_resultPage + 1, pages);
            if (PageInfoText != null)
            {
                PageInfoText.Text = total == 0
                    ? "بدون ردیف"
                    : "صفحه " + PersianDate.DigitsFa(page.ToString())
                      + " از " + PersianDate.DigitsFa(pages.ToString())
                      + "  ·  نمایش حداکثر "
                      + PersianDate.DigitsFa(ResultPageSize.ToString())
                      + " ردیف";
            }
            if (PrevPageButton != null)
                PrevPageButton.IsEnabled = _resultPage > 0 && total > 0;
            if (NextPageButton != null)
                NextPageButton.IsEnabled = _resultPage < pages - 1 && total > 0;
        }

        void OnPrevResultPage(object sender, RoutedEventArgs e)
        {
            if (_resultPage <= 0)
                return;
            _resultPage--;
            RebuildResultTable(false);
        }

        void OnNextResultPage(object sender, RoutedEventArgs e)
        {
            if (_resultPage >= ResultPageCount() - 1)
                return;
            _resultPage++;
            RebuildResultTable(false);
        }

        void RebuildResultTable(List<Employee> people, bool selectAll)
        {
            // سازگاری با فراخوانی‌های قدیمی — لیست کامل از قبل در _matchedPeople است
            RebuildResultTable(selectAll);
        }

        void RebuildResultTable(bool selectAll)
        {
            if (ResultTableHost == null)
                return;
            CloseOpenPopup();
            _matchSync = true;
            try
            {
                ResultTableHost.Children.Clear();
                ResultTableHost.ColumnDefinitions.Clear();
                ResultTableHost.RowDefinitions.Clear();
                ResultTableHost.FlowDirection = FlowDirection.RightToLeft;
                _matchBoxes.Clear();
                if (selectAll)
                {
                    _exportIds.Clear();
                    foreach (var p in _matchedPeople)
                    {
                        if (p != null && !string.IsNullOrWhiteSpace(p.Id))
                            _exportIds.Add(p.Id);
                    }
                }

                var people = CurrentPagePeople();
                var cols = GridColumns();
                ResultTableHost.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(CheckColWidth) });
                foreach (var _ in cols)
                    ResultTableHost.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(ColWidth) });

                ResultTableHost.RowDefinitions.Add(new RowDefinition { Height = new GridLength(HeaderHeight) });

                var headerBg = TryFindResource("GridHeaderBgBrush") as Brush
                    ?? TryFindResource("SoftPanelBrush") as Brush
                    ?? Brushes.WhiteSmoke;
                var borderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.LightGray;
                var primary = TryFindResource("PrimaryBrush") as Brush ?? Brushes.DarkSlateGray;

                var allSelected = _matchedPeople.Count > 0
                    && _matchedPeople.All(p => p != null && _exportIds.Contains(p.Id));
                var headerSelectAll = new CheckBox
                {
                    HorizontalAlignment = HorizontalAlignment.Center,
                    VerticalAlignment = VerticalAlignment.Center,
                    ToolTip = "انتخاب / برداشتن همهٔ نتایج فیلتر (همه صفحات)",
                    Style = TryFindResource("GridCheckBox") as Style,
                    IsChecked = allSelected
                };
                headerSelectAll.Checked += (s, e) =>
                {
                    if (_matchSync) return;
                    OnSelectAllMatches(s, e);
                };
                headerSelectAll.Unchecked += (s, e) =>
                {
                    if (_matchSync) return;
                    OnClearAllMatches(s, e);
                };

                var selectHeader = new Border
                {
                    Background = headerBg,
                    BorderBrush = borderBrush,
                    BorderThickness = new Thickness(0, 0, 1, 1),
                    ClipToBounds = false,
                    Child = headerSelectAll
                };
                Grid.SetRow(selectHeader, 0);
                Grid.SetColumn(selectHeader, 0);
                ResultTableHost.Children.Add(selectHeader);

                for (var i = 0; i < cols.Count; i++)
                {
                    var header = BuildHeaderCell(cols[i], headerBg, borderBrush, primary);
                    Grid.SetRow(header, 0);
                    Grid.SetColumn(header, i + 1);
                    ResultTableHost.Children.Add(header);
                }

                if (people == null || people.Count == 0)
                {
                    ResultTableHost.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });
                    var empty = new TextBlock
                    {
                        Text = "با فیلتر فعلی هیچ کارمندی یافت نشد.",
                        Style = TryFindResource("MutedText") as Style,
                        Margin = new Thickness(12),
                        HorizontalAlignment = HorizontalAlignment.Center
                    };
                    Grid.SetRow(empty, 1);
                    Grid.SetColumn(empty, 0);
                    Grid.SetColumnSpan(empty, Math.Max(1, cols.Count + 1));
                    ResultTableHost.Children.Add(empty);
                    UpdateExportCount();
                    UpdatePagerUi();
                    return;
                }

                var soft = TryFindResource("RowAltBrush") as Brush
                    ?? TryFindResource("SoftPanelBrush") as Brush
                    ?? Brushes.WhiteSmoke;
                var surface = TryFindResource("SurfaceBrush") as Brush ?? Brushes.White;
                var rowIndex = 1;
                foreach (var e in people)
                {
                    if (e == null || string.IsNullOrWhiteSpace(e.Id))
                        continue;

                    ResultTableHost.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto, MinHeight = 36 });
                    var bg = (rowIndex % 2 == 0) ? soft : surface;

                    var cb = new CheckBox
                    {
                        IsChecked = _exportIds.Contains(e.Id),
                        HorizontalAlignment = HorizontalAlignment.Center,
                        VerticalAlignment = VerticalAlignment.Center,
                        Tag = e.Id,
                        Style = TryFindResource("GridCheckBox") as Style
                    };
                    cb.Checked += OnMatchCheckChanged;
                    cb.Unchecked += OnMatchCheckChanged;
                    _matchBoxes.Add(cb);
                    var checkCell = new Border
                    {
                        Background = bg,
                        BorderBrush = borderBrush,
                        BorderThickness = new Thickness(0, 0, 1, 1),
                        Padding = new Thickness(4),
                        Child = cb
                    };
                    Grid.SetRow(checkCell, rowIndex);
                    Grid.SetColumn(checkCell, 0);
                    ResultTableHost.Children.Add(checkCell);

                    for (var i = 0; i < cols.Count; i++)
                    {
                        var text = ExcelService.CellValue(e, cols[i].Key);
                        if (DocumentKinds.IsDocColumn(cols[i].Key))
                        {
                            var kind = DocumentKinds.KindFromColumn(cols[i].Key);
                            text = DocumentKinds.Of(e, kind).Count > 0 ? "مشاهده" : "";
                        }
                        var accent = ExportAccentBrush(cols[i].Key);
                        var cell = new Border
                        {
                            Background = bg,
                            BorderBrush = accent,
                            BorderThickness = new Thickness(2, 0, 2, 1),
                            Padding = new Thickness(8, 6, 8, 6),
                            Child = new TextBlock
                            {
                                Text = string.IsNullOrWhiteSpace(text) ? "—" : text,
                                TextWrapping = TextWrapping.NoWrap,
                                TextTrimming = TextTrimming.CharacterEllipsis,
                                VerticalAlignment = VerticalAlignment.Center,
                                FontSize = 12,
                                ToolTip = string.IsNullOrWhiteSpace(text) ? null : text
                            }
                        };
                        Grid.SetRow(cell, rowIndex);
                        Grid.SetColumn(cell, i + 1);
                        ResultTableHost.Children.Add(cell);
                    }
                    rowIndex++;
                }

                _matchSync = true;
                headerSelectAll.IsChecked = allSelected;
                UpdateExportCount();
                UpdatePagerUi();
            }
            finally
            {
                _matchSync = false;
            }
        }

        FrameworkElement BuildHeaderCell(ReportColumn col, Brush headerBg, Brush borderBrush, Brush primary)
        {
            var inExport = IsExportColumn(col.Key);
            var accent = ExportAccentBrush(col.Key);
            var border = new Border
            {
                Background = headerBg,
                BorderBrush = accent,
                BorderThickness = new Thickness(2),
                Padding = new Thickness(8, 8, 8, 8),
                Cursor = Cursors.Hand,
                Tag = col.Key,
                ClipToBounds = false,
                VerticalAlignment = VerticalAlignment.Stretch,
                ToolTip = (inExport ? "ستون خروجی (سبز) — " : "خارج از خروجی (قرمز) — ")
                    + "کلیک برای فیلتر «" + col.TitleFa + "»"
            };

            var stack = new StackPanel
            {
                VerticalAlignment = VerticalAlignment.Center,
                HorizontalAlignment = HorizontalAlignment.Stretch
            };

            var title = new TextBlock
            {
                Text = col.TitleFa ?? "",
                FontWeight = FontWeights.SemiBold,
                Foreground = primary,
                FontSize = 12,
                TextAlignment = TextAlignment.Center,
                TextWrapping = TextWrapping.Wrap,
                TextTrimming = TextTrimming.None,
                Margin = new Thickness(0, 0, 0, 4),
                MaxHeight = 48
            };
            stack.Children.Add(title);

            var summary = new TextBlock
            {
                Text = FilterSummary(col.Key),
                Foreground = TryFindResource("MutedBrush") as Brush ?? Brushes.Gray,
                FontSize = 10,
                TextAlignment = TextAlignment.Center,
                TextWrapping = TextWrapping.Wrap,
                TextTrimming = TextTrimming.None,
                Margin = new Thickness(0, 0, 0, 6),
                MaxHeight = 32
            };
            stack.Children.Add(summary);

            var moves = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                HorizontalAlignment = HorizontalAlignment.Center,
                FlowDirection = FlowDirection.LeftToRight
            };
            // جدول RTL است: ایندکس کمتر = سمت راست‌تر، ایندکس بیشتر = سمت چپ‌تر
            moves.Children.Add(MakeMoveButton("»", "انتقال به چپ (ترتیب نمایش و خروجی)", col.Key, OnMoveColumnLeft));
            moves.Children.Add(MakeMoveButton("«", "انتقال به راست (ترتیب نمایش و خروجی)", col.Key, OnMoveColumnRight));
            stack.Children.Add(moves);

            border.Child = stack;

            var popup = new Popup
            {
                Placement = PlacementMode.Bottom,
                PlacementTarget = border,
                StaysOpen = false,
                AllowsTransparency = true,
                PopupAnimation = PopupAnimation.Fade,
                VerticalOffset = 2
            };
            popup.Child = BuildFilterPopupContent(col, popup, summary);
            border.MouseLeftButtonUp += (s, e) =>
            {
                if (e.OriginalSource is Button)
                    return;
                e.Handled = true;
                TogglePopup(popup);
            };
            return border;
        }

        bool IsExportColumn(string key)
        {
            var c = _cols.FirstOrDefault(x => x.Key == key);
            return c != null && c.Selected;
        }

        static readonly SolidColorBrush ExportGreenBrush = CreateFrozenBrush(0x2E, 0x7D, 0x32);
        static readonly SolidColorBrush ExportRedBrush = CreateFrozenBrush(0xC6, 0x28, 0x28);

        static SolidColorBrush CreateFrozenBrush(byte r, byte g, byte b)
        {
            var brush = new SolidColorBrush(Color.FromRgb(r, g, b));
            brush.Freeze();
            return brush;
        }

        Brush ExportAccentBrush(string key)
        {
            return IsExportColumn(key) ? ExportGreenBrush : ExportRedBrush;
        }

        Button MakeMoveButton(string content, string tip, string key, RoutedEventHandler handler)
        {
            var btn = new Button
            {
                Content = content,
                Width = 22,
                Height = 20,
                Padding = new Thickness(0),
                Margin = new Thickness(2, 0, 2, 0),
                FontSize = 14,
                FontWeight = FontWeights.Bold,
                ToolTip = tip,
                Tag = key,
                Style = TryFindResource("ChipButton") as Style,
                Focusable = false
            };
            btn.Click += handler;
            return btn;
        }

        void TogglePopup(Popup popup)
        {
            if (_openPopup != null && !ReferenceEquals(_openPopup, popup))
                _openPopup.IsOpen = false;
            popup.IsOpen = !popup.IsOpen;
            _openPopup = popup.IsOpen ? popup : null;
        }

        void CloseOpenPopup()
        {
            if (_openPopup != null)
            {
                _openPopup.IsOpen = false;
                _openPopup = null;
            }
        }

        UIElement BuildFilterPopupContent(ReportColumn col, Popup popup, TextBlock summary)
        {
            var card = new Border
            {
                Background = Brushes.White,
                BorderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.Gray,
                BorderThickness = new Thickness(1),
                CornerRadius = new CornerRadius(10),
                Padding = new Thickness(12),
                MinWidth = 280,
                MaxWidth = 420,
                MaxHeight = 420
            };

            var body = new StackPanel();
            body.Children.Add(new TextBlock
            {
                Text = "فیلتر: " + col.TitleFa,
                FontWeight = FontWeights.SemiBold,
                Margin = new Thickness(0, 0, 0, 8)
            });

            Action commitExtra = null;
            var kind = ReportFilterDefs.FilterKind(col.Key);
            if (kind == "enum")
                BuildEnumPopup(body, col.Key);
            else if (kind == "suggest")
                BuildSuggestPopup(body, col.Key);
            else if (kind == "number")
                commitExtra = BuildNumberPopup(body, col.Key);
            else if (kind == "date")
                BuildDatePopup(body, col.Key);
            else if (kind == "presence")
                BuildPresencePopup(body, col.Key);
            else if (kind == "text")
                BuildTextPopup(body, col.Key);

            if (col.Key == "birthDate")
                BuildAgeExtra(body);
            if (col.Key == "employmentDate")
                BuildTenureExtra(body);

            var scroll = new ScrollViewer
            {
                Content = body,
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                HorizontalScrollBarVisibility = ScrollBarVisibility.Disabled,
                MaxHeight = 300
            };

            var apply = new Button
            {
                Content = "اعمال",
                Style = (Style)FindResource("PrimaryButton"),
                Margin = new Thickness(0, 10, 0, 0),
                HorizontalAlignment = HorizontalAlignment.Stretch
            };
            apply.Click += (s, e) =>
            {
                SyncFilterFromEnums();
                if (commitExtra != null)
                    commitExtra();
                summary.Text = FilterSummary(col.Key);
                popup.IsOpen = false;
                _openPopup = null;
                RefreshMatchCount();
            };

            var dock = new DockPanel { LastChildFill = true };
            DockPanel.SetDock(apply, Dock.Bottom);
            dock.Children.Add(apply);
            dock.Children.Add(scroll);
            card.Child = dock;
            return card;
        }

        void BuildEnumPopup(Panel root, string key)
        {
            var options = key == "jobGroup"
                ? _jobGroupOptions.ToArray()
                : (key == "employmentType"
                    ? _employmentOptions.ToArray()
                    : ReportFilterDefs.ValueOptions(key));
            if (options.Length == 0)
            {
                root.Children.Add(new TextBlock
                {
                    Text = "گزینه‌ای موجود نیست.",
                    Style = TryFindResource("MutedText") as Style
                });
                return;
            }
            if (!_enumSelections.ContainsKey(key))
                _enumSelections[key] = new List<string>(options);

            var selected = new HashSet<string>(_enumSelections[key], StringComparer.CurrentCultureIgnoreCase);
            // employment / jobGroup / personType: خالی = بدون فیلتر؛ بقیه خالی = هیچ‌کدام انتخاب نشده
            var host = new StackPanel { MaxHeight = 220 };
            var scroll = new ScrollViewer
            {
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                MaxHeight = 220,
                Content = host
            };
            foreach (var opt in options)
            {
                var cb = new CheckBox
                {
                    Content = opt,
                    IsChecked = selected.Contains(opt) ||
                                (key != "employmentType" && key != "jobGroup" && key != "personType" && selected.Count == 0),
                    Margin = new Thickness(0, 2, 0, 4),
                    Tag = opt
                };
                if (key == "employmentType" || key == "jobGroup" || key == "personType")
                    cb.IsChecked = selected.Contains(opt);
                cb.Checked += (s, e) => UpdateEnumSelection(key, host);
                cb.Unchecked += (s, e) => UpdateEnumSelection(key, host);
                host.Children.Add(cb);
            }
            root.Children.Add(scroll);

            var row = new WrapPanel { Margin = new Thickness(0, 6, 0, 0) };
            var all = new Button { Content = "همه", Style = (Style)FindResource("ChipButton") };
            all.Click += (s, e) =>
            {
                foreach (CheckBox cb in host.Children.OfType<CheckBox>())
                    cb.IsChecked = true;
                UpdateEnumSelection(key, host);
            };
            var none = new Button { Content = "هیچ‌کدام", Style = (Style)FindResource("ChipButton") };
            none.Click += (s, e) =>
            {
                foreach (CheckBox cb in host.Children.OfType<CheckBox>())
                    cb.IsChecked = false;
                UpdateEnumSelection(key, host);
            };
            row.Children.Add(all);
            row.Children.Add(none);
            root.Children.Add(row);
        }

        void BuildSuggestPopup(Panel root, string key)
        {
            var category = FieldSuggestionKeys.CategoryForReportColumn(key);
            var options = new List<string>();
            if (SessionContext.FieldSuggestions != null && category != null)
                options.AddRange(SessionContext.FieldSuggestions.List(category));
            if (options.Count == 0)
            {
                root.Children.Add(new TextBlock
                {
                    Text = "هنوز پیشنهادی برای این فیلد ذخیره نشده. پس از ورود در پرونده کارمند، اینجا ظاهر می‌شود.",
                    Style = TryFindResource("MutedText") as Style,
                    TextWrapping = TextWrapping.Wrap
                });
                if (!_enumSelections.ContainsKey(key))
                    _enumSelections[key] = new List<string>();
                return;
            }

            if (!_enumSelections.ContainsKey(key))
                _enumSelections[key] = new List<string>();

            var selected = new HashSet<string>(_enumSelections[key] ?? new List<string>(), StringComparer.CurrentCultureIgnoreCase);
            var host = new StackPanel();
            var scroll = new ScrollViewer
            {
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                MaxHeight = 220,
                Content = host
            };
            foreach (var opt in options)
            {
                var cb = new CheckBox
                {
                    Content = opt,
                    IsChecked = selected.Count > 0 && selected.Contains(opt),
                    Margin = new Thickness(0, 2, 0, 4),
                    Tag = opt
                };
                cb.Checked += (s, e) => UpdateEnumSelection(key, host);
                cb.Unchecked += (s, e) => UpdateEnumSelection(key, host);
                host.Children.Add(cb);
            }
            root.Children.Add(scroll);

            var row = new WrapPanel { Margin = new Thickness(0, 6, 0, 0) };
            var all = new Button { Content = "همه (بدون فیلتر)", Style = (Style)FindResource("ChipButton") };
            all.Click += (s, e) =>
            {
                foreach (CheckBox cb in host.Children.OfType<CheckBox>())
                    cb.IsChecked = false;
                UpdateEnumSelection(key, host);
            };
            var pickAll = new Button { Content = "انتخاب همه", Style = (Style)FindResource("ChipButton") };
            pickAll.Click += (s, e) =>
            {
                foreach (CheckBox cb in host.Children.OfType<CheckBox>())
                    cb.IsChecked = true;
                UpdateEnumSelection(key, host);
            };
            row.Children.Add(all);
            row.Children.Add(pickAll);
            root.Children.Add(row);
        }

        void UpdateEnumSelection(string key, Panel host)
        {
            _enumSelections[key] = host.Children.OfType<CheckBox>()
                .Where(b => b.IsChecked == true)
                .Select(b => (string)b.Tag)
                .ToList();
        }

        Action BuildNumberPopup(Panel root, string key)
        {
            bool enabled;
            double min, max, lo, hi, tick;
            GetNumberBounds(key, out enabled, out min, out max, out lo, out hi, out tick);

            var enable = new CheckBox
            {
                Content = "اعمال بازه",
                IsChecked = enabled,
                Margin = new Thickness(0, 0, 0, 8)
            };
            var minBox = new TextBox { Text = FormatNum(min), Margin = new Thickness(0, 0, 0, 6) };
            var maxBox = new TextBox { Text = FormatNum(max), Margin = new Thickness(0, 0, 0, 6) };
            root.Children.Add(enable);
            root.Children.Add(new TextBlock { Text = "از", Style = TryFindResource("FieldLabel") as Style });
            root.Children.Add(minBox);
            root.Children.Add(new TextBlock { Text = "تا", Style = TryFindResource("FieldLabel") as Style });
            root.Children.Add(maxBox);
            root.Children.Add(new TextBlock
            {
                Text = "با تغییر عدد و زدن «اعمال»، فیلتر فعال می‌شود.",
                Style = TryFindResource("MutedText") as Style,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 4, 0, 0)
            });

            Action commit = () =>
            {
                WriteNumberFilter(key, enable.IsChecked == true, minBox.Text, maxBox.Text, lo, hi);
            };

            enable.Checked += (s, e) => WriteNumberFilter(key, true, minBox.Text, maxBox.Text, lo, hi);
            enable.Unchecked += (s, e) => WriteNumberFilter(key, false, minBox.Text, maxBox.Text, lo, hi);
            minBox.TextChanged += (s, e) =>
            {
                if (enable.IsChecked != true)
                    enable.IsChecked = true;
                else
                    WriteNumberFilter(key, true, minBox.Text, maxBox.Text, lo, hi);
            };
            maxBox.TextChanged += (s, e) =>
            {
                if (enable.IsChecked != true)
                    enable.IsChecked = true;
                else
                    WriteNumberFilter(key, true, minBox.Text, maxBox.Text, lo, hi);
            };
            return commit;
        }

        void GetNumberBounds(string key, out bool enabled, out double min, out double max,
            out double lo, out double hi, out double tick)
        {
            lo = 0;
            hi = 50;
            tick = 1;
            enabled = false;
            min = 0;
            max = 50;
            if (key == "childrenCount")
            {
                hi = ReportFilterDefs.ChildrenMaxDefault;
                enabled = _filter.ChildrenEnabled;
                min = _filter.ChildrenMin;
                max = _filter.ChildrenMax;
            }
            else if (key == "positionBase")
            {
                lo = ReportFilterDefs.BaseMinDefault;
                hi = ReportFilterDefs.BaseMaxDefault;
                tick = 0.5;
                enabled = _filter.PositionBaseEnabled;
                min = _filter.PositionBaseMin;
                max = _filter.PositionBaseMax;
            }
            else if (key == "personalBase")
            {
                lo = ReportFilterDefs.BaseMinDefault;
                hi = ReportFilterDefs.BaseMaxDefault;
                tick = 0.5;
                enabled = _filter.PersonalBaseEnabled;
                min = _filter.PersonalBaseMin;
                max = _filter.PersonalBaseMax;
            }
        }

        void WriteNumberFilter(string key, bool enabled, string minText, string maxText, double lo, double hi)
        {
            double minVal, maxVal;
            if (!TryParseFilterNumber(minText, out minVal))
                minVal = lo;
            if (!TryParseFilterNumber(maxText, out maxVal))
                maxVal = hi;
            if (minVal > maxVal)
            {
                var t = minVal;
                minVal = maxVal;
                maxVal = t;
            }
            // برای پایه‌ها سقف سخت نگیر؛ فقط کف صفر
            if (key == "positionBase" || key == "personalBase")
            {
                if (minVal < 0) minVal = 0;
                if (maxVal < 0) maxVal = 0;
            }
            else
            {
                minVal = Math.Max(lo, Math.Min(hi, minVal));
                maxVal = Math.Max(lo, Math.Min(hi, maxVal));
            }
            if (key == "childrenCount")
            {
                _filter.ChildrenEnabled = enabled;
                _filter.ChildrenMin = (int)Math.Round(minVal);
                _filter.ChildrenMax = (int)Math.Round(maxVal);
            }
            else if (key == "positionBase")
            {
                _filter.PositionBaseEnabled = enabled;
                _filter.PositionBaseMin = minVal;
                _filter.PositionBaseMax = maxVal;
            }
            else if (key == "personalBase")
            {
                _filter.PersonalBaseEnabled = enabled;
                _filter.PersonalBaseMin = minVal;
                _filter.PersonalBaseMax = maxVal;
            }
        }

        static bool TryParseFilterNumber(string text, out double value)
        {
            value = 0;
            var raw = PersianDate.DigitsEn(text ?? "").Trim();
            if (raw.Length == 0)
                return false;
            raw = raw.Replace('\u066B', '.').Replace('\u06D4', '.')
                .Replace(',', '.').Replace('/', '.');
            return double.TryParse(raw, NumberStyles.Float, CultureInfo.InvariantCulture, out value);
        }

        static string FormatNum(double v)
        {
            if (Math.Abs(v - Math.Round(v)) < 0.001)
                return ((int)Math.Round(v)).ToString(CultureInfo.InvariantCulture);
            return v.ToString("0.#", CultureInfo.InvariantCulture);
        }

        void OnResultScrollWheel(object sender, MouseWheelEventArgs e)
        {
            if (e.Handled || ResultScroll == null || PageScroll == null)
                return;

            // Shift = اسکرول افقی جدول
            if ((Keyboard.Modifiers & ModifierKeys.Shift) == ModifierKeys.Shift)
            {
                ResultScroll.ScrollToHorizontalOffset(ResultScroll.HorizontalOffset - e.Delta);
                e.Handled = true;
                return;
            }

            var canUp = ResultScroll.VerticalOffset > 0.5;
            var canDown = ResultScroll.VerticalOffset < ResultScroll.ScrollableHeight - 0.5;
            var wantUp = e.Delta > 0;
            var wantDown = e.Delta < 0;

            // اگر جدول در آن جهت جا ندارد، چرخ را به اسکرول صفحه بده تا گیر نکند
            if ((wantUp && !canUp) || (wantDown && !canDown) || ResultScroll.ScrollableHeight <= 0.5)
            {
                PageScroll.ScrollToVerticalOffset(PageScroll.VerticalOffset - e.Delta);
                e.Handled = true;
            }
        }

        void BuildDatePopup(Panel root, string key)
        {
            bool enabled;
            string from, to;
            if (key == "employmentDate")
            {
                enabled = _filter.EmploymentDateEnabled;
                from = _filter.EmploymentDateFrom ?? "";
                to = _filter.EmploymentDateTo ?? "";
            }
            else
            {
                enabled = _filter.BirthDateEnabled;
                from = _filter.BirthDateFrom ?? "";
                to = _filter.BirthDateTo ?? "";
            }

            var enable = new CheckBox { Content = "اعمال بازه تاریخ", IsChecked = enabled, Margin = new Thickness(0, 0, 0, 8) };
            var fromField = new ShamsiDateField { Value = from, Margin = new Thickness(0, 0, 0, 8) };
            var toField = new ShamsiDateField { Value = to, Margin = new Thickness(0, 0, 0, 6) };
            root.Children.Add(enable);
            root.Children.Add(new TextBlock
            {
                Text = "از تاریخ",
                Style = TryFindResource("FieldLabel") as Style,
                Margin = new Thickness(0, 0, 0, 4)
            });
            root.Children.Add(fromField);
            root.Children.Add(new TextBlock
            {
                Text = "تا تاریخ",
                Style = TryFindResource("FieldLabel") as Style,
                Margin = new Thickness(0, 0, 0, 4)
            });
            root.Children.Add(toField);

            Action sync = () =>
            {
                var on = enable.IsChecked == true;
                if (key == "employmentDate")
                {
                    _filter.EmploymentDateEnabled = on;
                    _filter.EmploymentDateFrom = (fromField.Value ?? "").Trim();
                    _filter.EmploymentDateTo = (toField.Value ?? "").Trim();
                }
                else
                {
                    _filter.BirthDateEnabled = on;
                    _filter.BirthDateFrom = (fromField.Value ?? "").Trim();
                    _filter.BirthDateTo = (toField.Value ?? "").Trim();
                }
            };
            enable.Checked += (s, e) => sync();
            enable.Unchecked += (s, e) => sync();
            fromField.ValueChanged += (s, e) =>
            {
                if (enable.IsChecked != true)
                    enable.IsChecked = true;
                sync();
            };
            toField.ValueChanged += (s, e) =>
            {
                if (enable.IsChecked != true)
                    enable.IsChecked = true;
                sync();
            };
        }

        void BuildAgeExtra(Panel root)
        {
            root.Children.Add(new Separator { Margin = new Thickness(0, 8, 0, 8) });
            root.Children.Add(new TextBlock
            {
                Text = "یا فیلتر سن (سال کامل)",
                FontWeight = FontWeights.SemiBold,
                Margin = new Thickness(0, 0, 0, 6)
            });
            var enable = new CheckBox
            {
                Content = "اعمال بازه سن",
                IsChecked = _filter.AgeEnabled,
                Margin = new Thickness(0, 0, 0, 8)
            };
            var minBox = new TextBox { Text = _filter.AgeMin.ToString(), Margin = new Thickness(0, 0, 0, 6) };
            var maxBox = new TextBox { Text = _filter.AgeMax.ToString(), Margin = new Thickness(0, 0, 0, 6) };
            root.Children.Add(enable);
            root.Children.Add(new TextBlock { Text = "از سن", Style = TryFindResource("FieldLabel") as Style });
            root.Children.Add(minBox);
            root.Children.Add(new TextBlock { Text = "تا سن", Style = TryFindResource("FieldLabel") as Style });
            root.Children.Add(maxBox);
            Action sync = () =>
            {
                _filter.AgeEnabled = enable.IsChecked == true;
                int amin, amax;
                if (!int.TryParse(PersianDate.DigitsEn(minBox.Text ?? ""), out amin))
                    amin = ReportFilterDefs.AgeMinDefault;
                if (!int.TryParse(PersianDate.DigitsEn(maxBox.Text ?? ""), out amax))
                    amax = ReportFilterDefs.AgeMaxDefault;
                _filter.AgeMin = amin;
                _filter.AgeMax = amax;
            };
            enable.Checked += (s, e) => sync();
            enable.Unchecked += (s, e) => sync();
            minBox.TextChanged += (s, e) => sync();
            maxBox.TextChanged += (s, e) => sync();
        }

        void BuildTenureExtra(Panel root)
        {
            root.Children.Add(new Separator { Margin = new Thickness(0, 8, 0, 8) });
            root.Children.Add(new TextBlock
            {
                Text = "یا فیلتر سابقه خدمت (سال کامل)",
                FontWeight = FontWeights.SemiBold,
                Margin = new Thickness(0, 0, 0, 6)
            });
            var enable = new CheckBox
            {
                Content = "اعمال بازه سابقه",
                IsChecked = _filter.TenureEnabled,
                Margin = new Thickness(0, 0, 0, 8)
            };
            var minBox = new TextBox { Text = _filter.TenureMin.ToString(), Margin = new Thickness(0, 0, 0, 6) };
            var maxBox = new TextBox { Text = _filter.TenureMax.ToString(), Margin = new Thickness(0, 0, 0, 6) };
            root.Children.Add(enable);
            root.Children.Add(new TextBlock { Text = "از سابقه", Style = TryFindResource("FieldLabel") as Style });
            root.Children.Add(minBox);
            root.Children.Add(new TextBlock { Text = "تا سابقه", Style = TryFindResource("FieldLabel") as Style });
            root.Children.Add(maxBox);
            Action sync = () =>
            {
                _filter.TenureEnabled = enable.IsChecked == true;
                int tmin, tmax;
                if (!int.TryParse(PersianDate.DigitsEn(minBox.Text ?? ""), out tmin))
                    tmin = ReportFilterDefs.TenureMinDefault;
                if (!int.TryParse(PersianDate.DigitsEn(maxBox.Text ?? ""), out tmax))
                    tmax = ReportFilterDefs.TenureMaxDefault;
                _filter.TenureMin = tmin;
                _filter.TenureMax = tmax;
            };
            enable.Checked += (s, e) => sync();
            enable.Unchecked += (s, e) => sync();
            minBox.TextChanged += (s, e) => sync();
            maxBox.TextChanged += (s, e) => sync();
        }

        void BuildPresencePopup(Panel root, string key)
        {
            var box = new ComboBox { Margin = new Thickness(0, 0, 0, 4) };
            for (var i = 0; i < ReportFilterDefs.PresenceModes.Length; i++)
                box.Items.Add(new ComboBoxItem
                {
                    Content = ReportFilterDefs.PresenceLabels[i],
                    Tag = ReportFilterDefs.PresenceModes[i]
                });
            var current = GetPresenceMode(key);
            SelectComboByTag(box, current);
            box.SelectionChanged += (s, e) => SetPresenceMode(key, ComboTag(box, "any"));
            root.Children.Add(box);
        }

        void BuildTextPopup(Panel root, string key)
        {
            var current = GetTextFilter(key) ?? "";
            var box = new TextBox { Text = current, Margin = new Thickness(0, 0, 0, 4) };
            box.TextChanged += (s, e) => SetTextFilter(key, (box.Text ?? "").Trim());
            root.Children.Add(new TextBlock
            {
                Text = "شامل این عبارت:",
                Style = TryFindResource("FieldLabel") as Style,
                Margin = new Thickness(0, 0, 0, 4)
            });
            root.Children.Add(box);
        }

        string GetTextFilter(string key)
        {
            switch (key)
            {
                case "fatherName": return _filter.FatherNameContains;
                case "birthPlace": return _filter.BirthPlaceContains;
                case "position": return _filter.PositionContains;
                case "previousPosition": return _filter.PreviousPositionContains;
                case "desiredPosition": return _filter.DesiredPositionContains;
                case "personalDescription": return _filter.DescriptionContains;
                case "address": return _filter.AddressContains;
                case "postalCode": return _filter.PostalCodeContains;
                case "email": return _filter.EmailContains;
                case "phone":
                case "secondaryPhone":
                case "emergencyPhone":
                    return _filter.PhoneContains;
                case "telegram":
                case "whatsapp":
                case "instagram":
                case "linkedin":
                    return _filter.SocialContains;
                case "firstName":
                case "lastName":
                case "fullName":
                case "nationalId":
                case "employeeNumber":
                case "subscriptionNumber":
                    if (_filter.ExtraContains != null && _filter.ExtraContains.ContainsKey(key))
                        return _filter.ExtraContains[key];
                    return "";
                default: return "";
            }
        }

        void SetTextFilter(string key, string value)
        {
            switch (key)
            {
                case "fatherName": _filter.FatherNameContains = value; break;
                case "birthPlace": _filter.BirthPlaceContains = value; break;
                case "position": _filter.PositionContains = value; break;
                case "previousPosition": _filter.PreviousPositionContains = value; break;
                case "desiredPosition": _filter.DesiredPositionContains = value; break;
                case "personalDescription": _filter.DescriptionContains = value; break;
                case "address": _filter.AddressContains = value; break;
                case "postalCode": _filter.PostalCodeContains = value; break;
                case "email": _filter.EmailContains = value; break;
                case "phone":
                case "secondaryPhone":
                case "emergencyPhone":
                    _filter.PhoneContains = value; break;
                case "telegram":
                case "whatsapp":
                case "instagram":
                case "linkedin":
                    _filter.SocialContains = value; break;
                case "firstName":
                case "lastName":
                case "fullName":
                case "nationalId":
                case "employeeNumber":
                case "subscriptionNumber":
                    if (_filter.ExtraContains == null)
                        _filter.ExtraContains = new Dictionary<string, string>();
                    _filter.ExtraContains[key] = value;
                    break;
            }
        }

        string FilterSummary(string key)
        {
            var kind = ReportFilterDefs.FilterKind(key);
            if (kind == "enum" || kind == "suggest")
            {
                List<string> sel;
                if (!_enumSelections.TryGetValue(key, out sel) || sel == null || sel.Count == 0)
                    return "همه";
                if (kind == "enum")
                {
                    var all = key == "jobGroup" ? _jobGroupOptions.Count : ReportFilterDefs.ValueOptions(key).Length;
                    if (key == "employmentType")
                        all = _employmentOptions.Count;
                    if (key != "employmentType" && key != "jobGroup" && key != "personType" && all > 0 && sel.Count >= all)
                        return "همه";
                }
                if (sel.Count <= 2)
                    return string.Join("، ", sel);
                return sel.Count + " مورد";
            }
            if (kind == "number")
            {
                if (key == "childrenCount" && _filter.ChildrenEnabled)
                    return _filter.ChildrenMin + " تا " + _filter.ChildrenMax;
                if (key == "positionBase" && _filter.PositionBaseEnabled)
                    return FormatNum(_filter.PositionBaseMin) + " تا " + FormatNum(_filter.PositionBaseMax);
                if (key == "personalBase" && _filter.PersonalBaseEnabled)
                    return FormatNum(_filter.PersonalBaseMin) + " تا " + FormatNum(_filter.PersonalBaseMax);
                return "بدون بازه";
            }
            if (kind == "date")
            {
                var parts = new List<string>();
                if (key == "birthDate")
                {
                    if (_filter.BirthDateEnabled)
                        parts.Add("تاریخ");
                    if (_filter.AgeEnabled)
                        parts.Add("سن " + _filter.AgeMin + "-" + _filter.AgeMax);
                }
                else
                {
                    if (_filter.EmploymentDateEnabled)
                        parts.Add("تاریخ");
                    if (_filter.TenureEnabled)
                        parts.Add("سابقه " + _filter.TenureMin + "-" + _filter.TenureMax);
                }
                return parts.Count == 0 ? "بدون بازه" : string.Join(" + ", parts);
            }
            if (kind == "presence")
            {
                var mode = GetPresenceMode(key);
                if (mode == "yes") return "دارد";
                if (mode == "no") return "ندارد";
                return "مهم نیست";
            }
            var text = GetTextFilter(key);
            return string.IsNullOrWhiteSpace(text) ? "بدون فیلتر" : "«" + text + "»";
        }

        void OnMoveColumnLeft(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            // جدول RTL: ایندکس بیشتر = سمت چپ‌تر
            MoveColumn(((Button)sender).Tag as string, +1);
        }

        void OnMoveColumnRight(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            // جدول RTL: ایندکس کمتر = سمت راست‌تر
            MoveColumn(((Button)sender).Tag as string, -1);
        }

        void MoveColumn(string key, int delta)
        {
            if (string.IsNullOrWhiteSpace(key))
                return;
            var i = _order.IndexOf(key);
            if (i < 0)
                return;
            var j = i + delta;
            if (j < 0 || j >= _order.Count)
                return;
            var tmp = _order[i];
            _order[i] = _order[j];
            _order[j] = tmp;
            RefreshMatchList(false);
        }

        void OnFilterChanged(object sender, RoutedEventArgs e)
        {
            if (!_ready)
                return;
            RefreshMatchCount();
        }

        void SyncFilterFromEnums()
        {
            _filter.Statuses = GetEnumOrAll("status", ReportFilterDefs.StatusLabels);
            _filter.Genders = GetEnumOrAll("gender", ReportFilterDefs.GenderValues);
            _filter.Maritals = GetEnumOrAll("maritalStatus", ReportFilterDefs.MaritalValues);
            _filter.Bloods = GetEnumOrAll("bloodGroup", ReportFilterDefs.BloodValues);
            _filter.Militaries = GetEnumOrAll("militaryStatus", ReportFilterDefs.MilitaryValues);
            List<string> emp;
            _filter.EmploymentTypes = _enumSelections.TryGetValue("employmentType", out emp) && emp != null
                ? new List<string>(emp)
                : new List<string>();
            List<string> pts;
            _filter.PersonTypes = _enumSelections.TryGetValue("personType", out pts) && pts != null
                ? new List<string>(pts)
                : new List<string>();
            List<string> jobs;
            _filter.JobGroups = _enumSelections.TryGetValue("jobGroup", out jobs) && jobs != null
                ? new List<string>(jobs)
                : new List<string>();

            if (_filter.SuggestionIn == null)
                _filter.SuggestionIn = new Dictionary<string, List<string>>();
            else
                _filter.SuggestionIn.Clear();
            foreach (var key in FieldSuggestionKeys.All
                .Select(c => c == FieldSuggestionKeys.CurrentPosition ? "position" : c)
                .Distinct())
            {
                List<string> sel;
                if (!_enumSelections.TryGetValue(key, out sel) || sel == null || sel.Count == 0)
                    continue;
                _filter.SuggestionIn[key] = new List<string>(sel);
            }
        }

        List<string> GetEnumOrAll(string key, string[] all)
        {
            List<string> sel;
            if (!_enumSelections.TryGetValue(key, out sel) || sel == null || sel.Count == 0)
                return new List<string>(all);
            return new List<string>(sel);
        }

        ReportEmployeeFilter ReadFilters()
        {
            SyncFilterFromEnums();
            _filter.SearchText = (SearchBox.Text ?? "").Trim();
            _filter.SortBy = ComboTag(SortByBox, "fullName");
            _filter.SortAscending = ComboTag(SortDirBox, "asc") != "desc";
            return CloneFilter(_filter);
        }

        void ApplyFiltersToUi(ReportEmployeeFilter f)
        {
            _filter = f == null ? ReportEmployeeFilter.CreateDefault() : CloneFilter(f);
            SearchBox.Text = _filter.SearchText ?? "";
            _enumSelections["status"] = new List<string>(_filter.Statuses ?? new List<string>(ReportFilterDefs.StatusLabels));
            _enumSelections["gender"] = new List<string>(_filter.Genders ?? new List<string>(ReportFilterDefs.GenderValues));
            _enumSelections["maritalStatus"] = new List<string>(_filter.Maritals ?? new List<string>(ReportFilterDefs.MaritalValues));
            _enumSelections["bloodGroup"] = new List<string>(_filter.Bloods ?? new List<string>(ReportFilterDefs.BloodValues));
            _enumSelections["militaryStatus"] = new List<string>(_filter.Militaries ?? new List<string>(ReportFilterDefs.MilitaryValues));
            _enumSelections["employmentType"] = new List<string>(_filter.EmploymentTypes ?? new List<string>());
            _enumSelections["personType"] = new List<string>(_filter.PersonTypes ?? new List<string>());
            _enumSelections["jobGroup"] = new List<string>(_filter.JobGroups ?? new List<string>());
            foreach (var key in new[]
            {
                "birthPlace", "serviceCity", "veteranStatus", "position", "previousPosition", "desiredPosition",
                "educationLevel", "major", "university", "skillName", "skillLevel", "insuranceType"
            })
            {
                List<string> saved = null;
                if (_filter.SuggestionIn != null)
                    _filter.SuggestionIn.TryGetValue(key, out saved);
                _enumSelections[key] = saved != null ? new List<string>(saved) : new List<string>();
            }
            SelectComboByTag(SortByBox, _filter.SortBy ?? "fullName");
            SelectComboByTag(SortDirBox, _filter.SortAscending ? "asc" : "desc");
            RebuildFilterBar();
        }

        static ReportEmployeeFilter CloneFilter(ReportEmployeeFilter src)
        {
            if (src == null)
                return ReportEmployeeFilter.CreateDefault();
            var json = Newtonsoft.Json.JsonConvert.SerializeObject(src);
            return Newtonsoft.Json.JsonConvert.DeserializeObject<ReportEmployeeFilter>(json)
                   ?? ReportEmployeeFilter.CreateDefault();
        }

        static string ComboTag(ComboBox box, string fallback)
        {
            var item = box.SelectedItem as ComboBoxItem;
            if (item != null && item.Tag != null)
                return item.Tag.ToString();
            return fallback;
        }

        static void SelectComboByTag(ComboBox box, string tag)
        {
            for (var i = 0; i < box.Items.Count; i++)
            {
                var item = box.Items[i] as ComboBoxItem;
                if (item != null && string.Equals(item.Tag as string, tag, StringComparison.OrdinalIgnoreCase))
                {
                    box.SelectedIndex = i;
                    return;
                }
            }
            if (box.Items.Count > 0)
                box.SelectedIndex = 0;
        }

        void RefreshMatchCount()
        {
            ScheduleMatchRefresh();
        }

        void OnMatchCheckChanged(object sender, RoutedEventArgs e)
        {
            if (_matchSync)
                return;
            var cb = sender as CheckBox;
            if (cb == null)
                return;
            var id = cb.Tag as string;
            if (string.IsNullOrWhiteSpace(id))
                return;
            if (cb.IsChecked == true)
                _exportIds.Add(id);
            else
                _exportIds.Remove(id);
            UpdateExportCount();
        }

        void UpdateExportCount()
        {
            if (ExportCountText == null)
                return;
            var n = _exportIds.Count;
            ExportCountText.Text = "تعداد خروجی: " + PersianDate.DigitsFa(n.ToString()) + " نفر";
        }

        void OnSelectAllMatches(object sender, RoutedEventArgs e)
        {
            _matchSync = true;
            try
            {
                foreach (var p in _matchedPeople)
                {
                    if (p != null && !string.IsNullOrWhiteSpace(p.Id))
                        _exportIds.Add(p.Id);
                }
                foreach (var cb in _matchBoxes)
                    cb.IsChecked = true;
            }
            finally
            {
                _matchSync = false;
            }
            UpdateExportCount();
        }

        void OnClearAllMatches(object sender, RoutedEventArgs e)
        {
            _matchSync = true;
            try
            {
                _exportIds.Clear();
                foreach (var cb in _matchBoxes)
                    cb.IsChecked = false;
            }
            finally
            {
                _matchSync = false;
            }
            UpdateExportCount();
        }

        string GetPresenceMode(string key)
        {
            switch (key)
            {
                case "docBirth": return _filter.DocBirthMode ?? "any";
                case "docNational": return _filter.DocNationalMode ?? "any";
                case "docOther": return _filter.DocOtherMode ?? "any";
                default: return _filter.PhotoMode ?? "any";
            }
        }

        void SetPresenceMode(string key, string mode)
        {
            if (string.IsNullOrWhiteSpace(mode))
                mode = "any";
            switch (key)
            {
                case "docBirth": _filter.DocBirthMode = mode; break;
                case "docNational": _filter.DocNationalMode = mode; break;
                case "docOther": _filter.DocOtherMode = mode; break;
                default: _filter.PhotoMode = mode; break;
            }
        }

        List<Employee> FilteredPeople()
        {
            EnsurePeopleCache();
            var all = _peopleCache ?? new List<Employee>();

            if (!string.IsNullOrWhiteSpace(_selectedGroupId) && SessionContext.Groups != null)
            {
                var memberIds = new HashSet<string>(
                    SessionContext.Groups.MemberIds(_selectedGroupId) ?? new List<string>(),
                    StringComparer.Ordinal);
                var members = all.Where(e => e != null && memberIds.Contains(e.Id)).ToList();
                var sortOnly = ReportEmployeeFilter.CreateDefault();
                var ui = ReadFilters();
                sortOnly.SortBy = ui.SortBy;
                sortOnly.SortAscending = ui.SortAscending;
                return sortOnly.Apply(members);
            }

            return ReadFilters().Apply(all);
        }

        void EnsurePeopleCache()
        {
            if (_peopleCache != null)
                return;
            _peopleCache = SessionContext.Employees.Search(new ParsedQuery(), null, 5000, false)
                ?? new List<Employee>();
            if (!_docsAttached && SessionContext.Documents != null)
            {
                DocumentRepository.AttachTo(_peopleCache, SessionContext.Documents, false);
                _docsAttached = true;
            }
        }

        bool HasDocPresenceFilter()
        {
            return IsYesNo(_filter.DocBirthMode) || IsYesNo(_filter.DocNationalMode) || IsYesNo(_filter.DocOtherMode);
        }

        static bool IsYesNo(string mode)
        {
            return mode == "yes" || mode == "no";
        }

        List<Employee> SelectedForExport()
        {
            return FilteredPeople().Where(e => e != null && _exportIds.Contains(e.Id)).ToList();
        }

        void SyncOrderFromSelection()
        {
            EnsureFullOrder();
        }

        /// <summary>ترتیب نمایش همهٔ ستون‌ها؛ کلیدهای خروجی حذف نمی‌شوند.</summary>
        void EnsureFullOrder()
        {
            var known = new HashSet<string>(_cols.Select(c => c.Key), StringComparer.Ordinal);
            _order.RemoveAll(k => !known.Contains(k));
            foreach (var c in _cols)
            {
                if (!_order.Contains(c.Key))
                    _order.Add(c.Key);
            }
        }

        void OnWatermark(object sender, RoutedEventArgs e)
        {
            _watermarkMode = ((Button)sender).Tag as string ?? "none";
            WatermarkBox.Visibility = _watermarkMode == "text" ? Visibility.Visible : Visibility.Collapsed;
            SetChip(WaterNoneButton, _watermarkMode == "none");
            SetChip(WaterLogoButton, _watermarkMode == "logo");
            SetChip(WaterTextButton, _watermarkMode == "text");
        }

        void OnOrientation(object sender, RoutedEventArgs e)
        {
            _orientation = ((Button)sender).Tag as string ?? "auto";
            SetChip(OrientAutoButton, _orientation == "auto");
            SetChip(OrientPortButton, _orientation == "portrait");
            SetChip(OrientLandButton, _orientation == "landscape");
        }

        void OnPdf(object sender, RoutedEventArgs e) { Export(true); }
        void OnExcel(object sender, RoutedEventArgs e) { Export(false); }

        async void Export(bool pdf)
        {
            if (_exporting)
                return;
            if (SelectedCount() == 0)
            {
                StatusText.Text = "برای این چیدمان حداقل یک ستون خروجی در «ویرایش ستون‌ها» انتخاب کنید.";
                return;
            }
            var people = SelectedForExport();
            if (people.Count == 0)
            {
                StatusText.Text = "حداقل یک کارمند را برای خروجی تیک بزنید.";
                return;
            }
            var options = ReadOptions();
            var stamp = PersianDate.Today().Replace("/", "-");
            var dlg = new SaveFileDialog
            {
                Filter = pdf ? "PDF|*.pdf" : "Excel|*.xlsx",
                FileName = pdf ? "گزارش-پرسنل-" + stamp + ".pdf" : "گزارش-پرسنل-" + stamp + ".xlsx"
            };
            if (dlg.ShowDialog() != true)
                return;

            var withDocs = HasDocColumn();
            var ordered = OrderedColumns();
            var outPath = withDocs ? ReportDocPack.WrapReportPath(dlg.FileName, true) : dlg.FileName;
            var logo = options.ShowLogo || options.WatermarkMode == "logo" ? ReportAssets.LogoPng() : null;
            var excelLogo = ReportAssets.LogoPng();
            var docs = withDocs ? SessionContext.Documents : null;
            var countLabel = PersianDate.DigitsFa(people.Count.ToString());

            _exporting = true;
            SetExportUiEnabled(false);
            ShowExportBusy(true, "آماده‌سازی فهرست " + countLabel + " نفر…");
            try
            {
                // یک فریم برای نمایش پوشش قبل از کار سنگین
                await Dispatcher.Yield(DispatcherPriority.Render);
                await Task.Delay(40);

                if (withDocs)
                {
                    SetExportBusyDetail("بارگذاری فهرست مدارک…");
                    await Dispatcher.Yield(DispatcherPriority.Background);
                    DocumentRepository.AttachTo(people, docs, false);
                    SetExportBusyDetail("استخراج موازی مدارک…");
                    await Dispatcher.Yield(DispatcherPriority.Render);
                    await Task.Run(() => ReportDocPack.Prefetch(people, ordered, docs, outPath));
                }

                SetExportBusyDetail(pdf
                    ? "در حال ساخت فایل PDF — لطفاً صبر کنید…"
                    : "در حال ساخت فایل اکسل — لطفاً صبر کنید…");
                await Dispatcher.Yield(DispatcherPriority.Render);

                await Task.Run(() =>
                {
                    if (pdf)
                        PdfReport.Write(outPath, people, ordered, options, logo, docs);
                    else
                        ExcelService.ExportEmployees(outPath, people, ordered, options, excelLogo, docs);
                });

                try
                {
                    Process.Start(new ProcessStartInfo { FileName = outPath, UseShellExecute = true });
                }
                catch
                {
                }
                StatusText.Text = (pdf ? "PDF" : "اکسل") + " ذخیره و باز شد. "
                    + countLabel + " نفر، "
                    + PersianDate.DigitsFa(ordered.Count.ToString()) + " ستون خروجی."
                    + (withDocs ? " مدارک کنار فایل در پوشه docs قرار گرفت." : "");
            }
            catch (OutOfMemoryException)
            {
                StatusText.Text = "حافظه کافی برای این حجم خروجی نبود. تعداد نفرات یا ستون‌ها را کم کنید و دوباره تلاش کنید.";
                MessageBox.Show(
                    "خروجی به‌خاطر حجم زیاد داده متوقف شد.\nتعداد کارکنان یا ستون‌های خروجی را کمتر کنید.",
                    AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Warning);
            }
            catch (Exception ex)
            {
                StatusText.Text = "خروجی ناموفق بود: " + ex.Message;
                MessageBox.Show(
                    "ساخت خروجی انجام نشد.\n" + ex.Message,
                    AppConstants.AppNameFa, MessageBoxButton.OK, MessageBoxImage.Warning);
            }
            finally
            {
                ShowExportBusy(false, null);
                SetExportUiEnabled(true);
                _exporting = false;
                try
                {
                    GC.Collect(2, GCCollectionMode.Optimized);
                }
                catch
                {
                }
            }
        }

        void ShowExportBusy(bool on, string detail)
        {
            if (ExportBusyOverlay == null)
                return;
            ExportBusyOverlay.Visibility = on ? Visibility.Visible : Visibility.Collapsed;
            if (ExportBusyBar != null)
                ExportBusyBar.IsIndeterminate = on;
            if (!string.IsNullOrEmpty(detail))
                SetExportBusyDetail(detail);
            if (on)
                Mouse.OverrideCursor = Cursors.Wait;
            else
                Mouse.OverrideCursor = null;
        }

        void SetExportBusyDetail(string text)
        {
            if (ExportBusyDetail != null)
                ExportBusyDetail.Text = text ?? string.Empty;
        }

        void SetExportUiEnabled(bool enabled)
        {
            if (PdfExportButton != null)
                PdfExportButton.IsEnabled = enabled;
            if (ExcelExportButton != null)
                ExcelExportButton.IsEnabled = enabled;
        }

        /// <summary>همهٔ ستون‌ها برای فیلتر؛ ترتیب از _order؛ Selected = ستون خروجی چیدمان.</summary>
        List<ReportColumn> GridColumns()
        {
            EnsureFullOrder();
            var map = _cols.ToDictionary(c => c.Key);
            var list = new List<ReportColumn>();
            foreach (var k in _order)
            {
                ReportColumn c;
                if (!map.TryGetValue(k, out c))
                    continue;
                list.Add(new ReportColumn
                {
                    Key = c.Key,
                    TitleFa = c.TitleFa,
                    Group = c.Group,
                    Selected = c.Selected
                });
            }
            return list;
        }

        /// <summary>فقط ستون‌های انتخاب‌شده در چیدمان فعلی برای PDF/اکسل.</summary>
        List<ReportColumn> OrderedColumns()
        {
            var map = _cols.ToDictionary(c => c.Key);
            var list = new List<ReportColumn>();
            foreach (var k in _order)
            {
                ReportColumn c;
                if (map.TryGetValue(k, out c) && c.Selected)
                    list.Add(new ReportColumn
                    {
                        Key = c.Key,
                        TitleFa = c.TitleFa,
                        Group = c.Group,
                        Selected = true
                    });
            }
            foreach (var c in _cols)
            {
                if (c.Selected && !_order.Contains(c.Key))
                    list.Add(new ReportColumn
                    {
                        Key = c.Key,
                        TitleFa = c.TitleFa,
                        Group = c.Group,
                        Selected = true
                    });
            }
            return list;
        }

        ReportExportOptions ReadOptions()
        {
            var o = ReportExportOptions.CreateDefault();
            o.Title = (TitleBox.Text ?? "").Trim();
            o.HeaderText = (HeaderBox.Text ?? "").Trim();
            o.FooterText = (FooterBox.Text ?? "").Trim();
            o.Watermark = (WatermarkBox.Text ?? "").Trim();
            o.WatermarkMode = _watermarkMode;
            o.ShowLogo = LogoBox.IsChecked == true;
            o.ShowPageNumbers = PageNumBox.IsChecked == true;
            o.ShowPhotos = false;
            o.ShowDocuments = false;
            o.Orientation = _orientation;
            o.ReportDate = (ReportDateField.Value ?? "").Trim();
            o.ShowSignature = SignatureBox.IsChecked == true;
            o.SignatureTitle = (SignatureTitleBox.Text ?? "").Trim();
            return o;
        }

        void OnSignatureToggle(object sender, RoutedEventArgs e)
        {
            SignatureTitleBox.IsEnabled = SignatureBox.IsChecked == true;
        }

        void ApplyLayout(ReportLayout layout, bool overwriteTitle)
        {
            if (layout == null)
                return;
            var keys = layout.ColumnKeys ?? new string[0];
            SetColumns(new HashSet<string>(keys), false);
            _order.Clear();
            foreach (var k in keys)
            {
                if (_cols.Any(c => c.Key == k) && !_order.Contains(k))
                    _order.Add(k);
            }
            EnsureFullOrder();
            ApplyFiltersToUi(layout.Filters ?? ReportEmployeeFilter.CreateDefault());
            var o = layout.Options ?? ReportExportOptions.CreateDefault();
            if (overwriteTitle || string.IsNullOrWhiteSpace(TitleBox.Text))
                TitleBox.Text = string.IsNullOrWhiteSpace(o.Title) ? "گزارش کارکنان" : o.Title;
            HeaderBox.Text = o.HeaderText ?? "";
            FooterBox.Text = o.FooterText ?? "";
            WatermarkBox.Text = string.IsNullOrWhiteSpace(o.Watermark) ? AppConstants.AppNameFa : o.Watermark;
            LogoBox.IsChecked = o.ShowLogo;
            PageNumBox.IsChecked = o.ShowPageNumbers;
            ReportDateField.Value = o.ReportDate ?? "";
            SignatureBox.IsChecked = o.ShowSignature;
            SignatureTitleBox.Text = string.IsNullOrWhiteSpace(o.SignatureTitle)
                ? "مدیر منابع انسانی"
                : o.SignatureTitle;
            SignatureTitleBox.IsEnabled = o.ShowSignature;
            _watermarkMode = string.IsNullOrWhiteSpace(o.WatermarkMode) ? "none" : o.WatermarkMode;
            _orientation = string.IsNullOrWhiteSpace(o.Orientation) ? "auto" : o.Orientation;
            WatermarkBox.Visibility = _watermarkMode == "text" ? Visibility.Visible : Visibility.Collapsed;
            SetChip(WaterNoneButton, _watermarkMode == "none");
            SetChip(WaterLogoButton, _watermarkMode == "logo");
            SetChip(WaterTextButton, _watermarkMode == "text");
            SetChip(OrientAutoButton, _orientation == "auto");
            SetChip(OrientPortButton, _orientation == "portrait");
            SetChip(OrientLandButton, _orientation == "landscape");
            RefreshMatchCount();
        }

        void SetColumns(HashSet<string> keys, bool all)
        {
            foreach (var c in _cols)
                c.Selected = all || (keys != null && keys.Contains(c.Key));
            SyncOrderFromSelection();
        }

        bool HasDocColumn()
        {
            return _cols.Exists(c => c.Selected && DocumentKinds.IsDocColumn(c.Key));
        }

        string[] OrderedKeys()
        {
            return OrderedColumns().Select(c => c.Key).ToArray();
        }

        int SelectedCount()
        {
            return _cols.Count(c => c.Selected);
        }

        void SetChip(Button button, bool on)
        {
            if (button == null)
                return;
            button.Style = (Style)FindResource(on ? "ChipButtonSelected" : "ChipButton");
        }
    }
}
