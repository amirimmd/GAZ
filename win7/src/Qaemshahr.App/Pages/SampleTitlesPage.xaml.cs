using System;
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
    public partial class SampleTitlesPage : Page
    {
        List<Employee> _people = new List<Employee>();
        int? _focusYear;
        string _search = "";

        public SampleTitlesPage()
        {
            InitializeComponent();
            BuildYears();
            LoadPeople();
            SearchBox.TextChanged += (s, e) =>
            {
                _search = (SearchBox.Text ?? "").Trim();
                RebuildCards();
            };
            UpdatePersonHint();
            RebuildCards();
        }

        void BuildYears()
        {
            YearBox.Items.Clear();
            var current = PersianDate.CurrentYear();
            var years = new HashSet<int>();
            for (var y = current + 2; y >= current - 15; y--)
                years.Add(y);
            foreach (var y in SessionContext.SampleTitles.ListYears())
                years.Add(y);
            foreach (var y in years.OrderByDescending(v => v))
                YearBox.Items.Add(y);
            YearBox.SelectedItem = current;
            _focusYear = current;
        }

        void LoadPeople()
        {
            _people = SessionContext.Employees.ListPicker() ?? new List<Employee>();
            RefreshPersonList();
        }

        void RefreshPersonList()
        {
            var list = _people.OrderBy(p => p.LastName).ThenBy(p => p.FirstName).ToList();
            PersonBox.DisplayMemberPath = null;
            System.Windows.Controls.TextSearch.SetTextPath(PersonBox, "FullName");
            PersonBox.ItemsSource = list;
            PersonBox.ItemTemplate = BuildPersonItemTemplate();
            ClearPersonPreview();
        }

        DataTemplate BuildPersonItemTemplate()
        {
            // نام + کد ملی در فهرست کشویی
            var template = new DataTemplate(typeof(Employee));
            var factory = new FrameworkElementFactory(typeof(StackPanel));
            factory.SetValue(StackPanel.MarginProperty, new Thickness(2, 4, 2, 4));
            var name = new FrameworkElementFactory(typeof(TextBlock));
            name.SetBinding(TextBlock.TextProperty, new System.Windows.Data.Binding("FullName"));
            name.SetValue(TextBlock.FontWeightProperty, FontWeights.SemiBold);
            name.SetValue(TextBlock.FontSizeProperty, 13.0);
            var nid = new FrameworkElementFactory(typeof(TextBlock));
            nid.SetBinding(TextBlock.TextProperty, new System.Windows.Data.Binding("NationalId")
            {
                StringFormat = "کد ملی: {0}"
            });
            nid.SetValue(TextBlock.FontSizeProperty, 11.0);
            nid.SetValue(TextBlock.ForegroundProperty, TryFindResource("MutedBrush") as Brush ?? Brushes.Gray);
            nid.SetValue(TextBlock.MarginProperty, new Thickness(0, 2, 0, 0));
            factory.AppendChild(name);
            factory.AppendChild(nid);
            template.VisualTree = factory;
            return template;
        }

        void OnPersonSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!IsLoaded)
                return;
            ShowPersonPreview(PersonBox.SelectedItem as Employee);
        }

        void ShowPersonPreview(Employee person)
        {
            if (PersonPreviewHost == null)
                return;
            if (person == null)
            {
                ClearPersonPreview();
                return;
            }
            PersonPreviewHost.Visibility = Visibility.Visible;
            PersonPreviewName.Text = person.FullName ?? "";
            PersonPreviewKind.Text = "ثبت به‌عنوان: " + SampleTitleKinds.Fa(KindForPerson(person));
            PersonPreviewNationalId.Text = string.IsNullOrWhiteSpace(person.NationalId)
                ? "کد ملی ثبت نشده"
                : "کد ملی: " + PersianDate.DigitsFa(person.NationalId);
            PersonPreviewPosition.Text = string.IsNullOrWhiteSpace(person.CurrentPosition)
                ? HrLookups.PersonTypeFa(person.PersonType)
                : person.CurrentPosition + "  ·  " + HrLookups.PersonTypeFa(person.PersonType);

            var photo = PhotoImages.FromEmployee(person.PhotoPath, 90);
            if (photo != null)
                PersonPreviewPhoto.Child = new Image { Source = photo, Stretch = Stretch.UniformToFill };
            else
                PersonPreviewPhoto.Child = GenderAvatars.ForEmployee(person, 26);
        }

        void ClearPersonPreview()
        {
            if (PersonPreviewHost == null)
                return;
            PersonPreviewHost.Visibility = Visibility.Collapsed;
            PersonPreviewName.Text = "";
            if (PersonPreviewKind != null)
                PersonPreviewKind.Text = "";
            PersonPreviewNationalId.Text = "";
            PersonPreviewPosition.Text = "";
            PersonPreviewPhoto.Child = null;
        }

        void UpdatePersonHint()
        {
            PersonHintText.Text =
                "نوع نمونه از پرونده فرد مشخص می‌شود. قبل از ثبت، عکس و کد ملی را در پیش‌نمایش بررسی کنید.";
        }

        static string KindForPerson(Employee person)
        {
            return HrLookups.IsWorker(person == null ? null : person.PersonType)
                ? SampleTitleKinds.WorkerSample
                : SampleTitleKinds.StaffSample;
        }

        int SelectedYear()
        {
            if (YearBox.SelectedItem is int)
                return (int)YearBox.SelectedItem;
            int y;
            if (int.TryParse(Convert.ToString(YearBox.SelectedItem), out y))
                return y;
            return PersianDate.CurrentYear();
        }

        void OnAddYearChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!IsLoaded)
                return;
            _focusYear = SelectedYear();
            RebuildCards();
        }

        void OnFocusCurrentYear(object sender, RoutedEventArgs e)
        {
            _focusYear = SelectedYear();
            RebuildCards();
        }

        void OnShowAllYears(object sender, RoutedEventArgs e)
        {
            _focusYear = null;
            RebuildCards();
        }

        void OnCopyPrevYear(object sender, RoutedEventArgs e)
        {
            var to = SelectedYear();
            var from = to - 1;
            if (MessageBox.Show(
                    "عنوان‌های نمونه و معرفی‌های فراسازمانی سال " + PersianDate.DigitsFa(from.ToString())
                    + " به سال " + PersianDate.DigitsFa(to.ToString())
                    + " کپی شوند؟",
                    AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            var n = SessionContext.SampleTitles.CopyYear(from, to, CurrentUsername());
            MessageBox.Show(
                n == 0
                    ? "مورد جدیدی برای کپی نبود."
                    : PersianDate.DigitsFa(n.ToString()) + " عنوان نمونه کپی شد.",
                AppConstants.AppNameFa);
            RebuildCards();
        }

        void OnAdd(object sender, RoutedEventArgs e)
        {
            var person = ResolvePerson();
            if (person == null || string.IsNullOrEmpty(person.Id))
            {
                MessageBox.Show("یک نفر از فهرست پرسنل انتخاب کنید.", AppConstants.AppNameFa);
                return;
            }
            if (string.IsNullOrWhiteSpace(NoteBox.Text))
            {
                MessageBox.Show("متن گزارش نمونه را وارد کنید.", AppConstants.AppNameFa);
                return;
            }
            var kind = KindForPerson(person);
            string titleId;
            var err = SessionContext.SampleTitles.Upsert(
                person.Id, SelectedYear(), kind, NoteBox.Text, CurrentUsername(), out titleId, true);
            if (err != null)
            {
                MessageBox.Show(err, AppConstants.AppNameFa);
                return;
            }
            Audit("sample_title_add", person.Id);
            NoteBox.Text = "";
            PersonBox.SelectedItem = null;
            PersonBox.Text = "";
            ClearPersonPreview();
            _focusYear = SelectedYear();
            RebuildCards();
        }

        Employee ResolvePerson()
        {
            var person = PersonBox.SelectedItem as Employee;
            if (person != null)
                return person;
            if (string.IsNullOrWhiteSpace(PersonBox.Text))
                return null;
            var q = PersonBox.Text.Trim();
            return _people.FirstOrDefault(p =>
                p != null && (
                    string.Equals(p.FullName, q, StringComparison.OrdinalIgnoreCase)
                    || string.Equals(p.NationalId, q, StringComparison.OrdinalIgnoreCase)
                    || (p.FullName ?? "").IndexOf(q, StringComparison.OrdinalIgnoreCase) >= 0));
        }

        void RebuildCards()
        {
            YearsHost.Children.Clear();
            var years = new HashSet<int>();
            foreach (var y in SessionContext.SampleTitles.ListYears())
                years.Add(y);
            if (_focusYear.HasValue)
                years.Add(_focusYear.Value);
            else if (years.Count == 0)
                years.Add(PersianDate.CurrentYear());

            IEnumerable<int> ordered = years.OrderByDescending(y => y);
            if (_focusYear.HasValue)
                ordered = ordered.Where(y => y == _focusYear.Value);

            var any = false;
            foreach (var year in ordered)
            {
                var rows = SessionContext.SampleTitles.List(year, null);
                if (!string.IsNullOrEmpty(_search))
                {
                    rows = rows.Where(r =>
                        (r.EmployeeName ?? "").IndexOf(_search, StringComparison.OrdinalIgnoreCase) >= 0
                        || (r.NationalId ?? "").IndexOf(_search, StringComparison.OrdinalIgnoreCase) >= 0
                        || (r.Position ?? "").IndexOf(_search, StringComparison.OrdinalIgnoreCase) >= 0
                        || (r.Note ?? "").IndexOf(_search, StringComparison.OrdinalIgnoreCase) >= 0
                        || (r.Introductions != null && r.Introductions.Any(i =>
                            (i.Organization ?? "").IndexOf(_search, StringComparison.OrdinalIgnoreCase) >= 0
                            || (i.Note ?? "").IndexOf(_search, StringComparison.OrdinalIgnoreCase) >= 0))).ToList();
                }
                if (!_focusYear.HasValue && rows.Count == 0 && !string.IsNullOrEmpty(_search))
                    continue;
                YearsHost.Children.Add(BuildYearBlock(year, rows));
                any = true;
            }
            if (!any)
            {
                YearsHost.Children.Add(new TextBlock
                {
                    Text = "هنوز نمونه‌ای ثبت نشده است.",
                    Style = TryFindResource("MutedText") as Style,
                    Margin = new Thickness(4, 12, 4, 0)
                });
            }
        }

        UIElement BuildYearBlock(int year, List<SampleTitle> rows)
        {
            var staff = rows.Where(r => r.Kind == SampleTitleKinds.StaffSample).ToList();
            var workers = rows.Where(r => r.Kind == SampleTitleKinds.WorkerSample).ToList();
            var introCount = rows.Sum(r => r.Introductions == null ? 0 : r.Introductions.Count);

            var outer = new Border
            {
                Style = TryFindResource("CardFill") as Style,
                Padding = new Thickness(16),
                Margin = new Thickness(0, 0, 0, 12),
                HorizontalAlignment = HorizontalAlignment.Stretch
            };
            var root = new StackPanel();

            var head = new DockPanel { Margin = new Thickness(0, 0, 0, 12) };
            var useBtn = new Button
            {
                Content = "ثبت در این سال",
                Style = TryFindResource("GhostButton") as Style,
                Padding = new Thickness(10, 4, 10, 4),
                MinHeight = 30,
                VerticalAlignment = VerticalAlignment.Center
            };
            DockPanel.SetDock(useBtn, Dock.Left);
            useBtn.Click += (s, e) =>
            {
                YearBox.SelectedItem = year;
                _focusYear = year;
            };
            head.Children.Add(useBtn);

            var titles = new StackPanel();
            titles.Children.Add(new TextBlock
            {
                Text = "سال " + PersianDate.DigitsFa(year.ToString()),
                FontSize = 18,
                FontWeight = FontWeights.Bold,
                Foreground = TryFindResource("PrimaryBrush") as Brush
            });
            titles.Children.Add(new TextBlock
            {
                Text = "کارمند نمونه " + PersianDate.DigitsFa(staff.Count.ToString())
                    + "  |  کارگر نمونه " + PersianDate.DigitsFa(workers.Count.ToString())
                    + "  |  معرفی فراسازمانی " + PersianDate.DigitsFa(introCount.ToString()),
                Style = TryFindResource("MutedText") as Style,
                Margin = new Thickness(0, 2, 0, 0)
            });
            head.Children.Add(titles);
            root.Children.Add(head);

            root.Children.Add(BuildSectionHeader("کارمند نمونه", staff.Count, SampleTitleKinds.StaffSample, year));
            root.Children.Add(BuildHonorWall(staff, true));
            root.Children.Add(BuildSectionHeader("کارگر نمونه", workers.Count, SampleTitleKinds.WorkerSample, year));
            root.Children.Add(BuildHonorWall(workers, false));

            outer.Child = root;
            return outer;
        }

        UIElement BuildHonorWall(List<SampleTitle> rows, bool staffWall)
        {
            var board = new Border
            {
                CornerRadius = new CornerRadius(12),
                Padding = new Thickness(14, 16, 14, 10),
                Margin = new Thickness(0, 0, 0, 4),
                MinHeight = rows.Count == 0 ? 72 : 0
            };
            board.Background = new LinearGradientBrush(
                staffWall ? Color.FromRgb(0xE8, 0xF1, 0xF7) : Color.FromRgb(0xF3, 0xEE, 0xE6),
                staffWall ? Color.FromRgb(0xD5, 0xE6, 0xF0) : Color.FromRgb(0xE7, 0xDF, 0xD2),
                90);

            if (rows == null || rows.Count == 0)
            {
                board.Child = new TextBlock
                {
                    Text = "این تابلو خالی است — از «افزودن» بالا نفر ثبت کنید.",
                    Style = TryFindResource("MutedText") as Style,
                    HorizontalAlignment = HorizontalAlignment.Center,
                    VerticalAlignment = VerticalAlignment.Center,
                    Margin = new Thickness(8)
                };
                return board;
            }

            var wall = new WrapPanel
            {
                Orientation = Orientation.Horizontal,
                HorizontalAlignment = HorizontalAlignment.Center
            };
            foreach (var row in rows)
                wall.Children.Add(BuildWallPlaque(row, staffWall));
            board.Child = wall;
            return board;
        }

        UIElement BuildWallPlaque(SampleTitle row, bool staffWall)
        {
            var frame = new Border
            {
                Width = 196,
                MinWidth = 196,
                Margin = new Thickness(8, 6, 8, 10),
                Padding = new Thickness(10, 10, 10, 10),
                CornerRadius = new CornerRadius(6),
                Background = Brushes.White,
                BorderBrush = staffWall
                    ? new SolidColorBrush(Color.FromRgb(0x0B, 0x4A, 0x6F))
                    : new SolidColorBrush(Color.FromRgb(0x6D, 0x4C, 0x2B)),
                BorderThickness = new Thickness(1.5),
                Effect = new System.Windows.Media.Effects.DropShadowEffect
                {
                    BlurRadius = 10,
                    ShadowDepth = 3,
                    Opacity = 0.22,
                    Direction = 270,
                    Color = Colors.Black
                }
            };

            var stack = new StackPanel();
            var photo = new Border
            {
                Width = 120,
                Height = 160,
                CornerRadius = new CornerRadius(3),
                ClipToBounds = true,
                HorizontalAlignment = HorizontalAlignment.Center,
                Background = TryFindResource("SoftPanelBrush") as Brush ?? Brushes.LightGray,
                Cursor = Cursors.Hand,
                ToolTip = "باز کردن پرونده"
            };
            var img = PhotoImages.FromEmployee(row.PhotoPath, 160);
            if (img != null)
                photo.Child = new Image { Source = img, Stretch = Stretch.UniformToFill };
            else
                photo.Child = GenderAvatars.ForGender(row.Gender, 52);
            photo.MouseLeftButtonUp += (s, e) =>
            {
                e.Handled = true;
                OpenEmployee(row.EmployeeId);
            };
            stack.Children.Add(photo);

            var namePlate = new Border
            {
                Margin = new Thickness(0, 8, 0, 0),
                Padding = new Thickness(6, 6, 6, 6),
                Background = staffWall
                    ? new SolidColorBrush(Color.FromRgb(0x0B, 0x4A, 0x6F))
                    : new SolidColorBrush(Color.FromRgb(0x5D, 0x40, 0x37)),
                CornerRadius = new CornerRadius(3)
            };
            namePlate.Child = new TextBlock
            {
                Text = row.EmployeeName ?? "",
                Foreground = Brushes.White,
                FontWeight = FontWeights.SemiBold,
                FontSize = 12,
                TextAlignment = TextAlignment.Center,
                TextWrapping = TextWrapping.Wrap
            };
            stack.Children.Add(namePlate);

            if (!string.IsNullOrWhiteSpace(row.NationalId))
            {
                stack.Children.Add(new TextBlock
                {
                    Text = "کد ملی: " + PersianDate.DigitsFa(row.NationalId),
                    FontSize = 10,
                    Foreground = TryFindResource("MutedBrush") as Brush,
                    TextAlignment = TextAlignment.Center,
                    Margin = new Thickness(0, 4, 0, 0)
                });
            }
            if (!string.IsNullOrWhiteSpace(row.Position))
            {
                stack.Children.Add(new TextBlock
                {
                    Text = row.Position,
                    FontSize = 10,
                    Foreground = TryFindResource("MutedBrush") as Brush,
                    TextAlignment = TextAlignment.Center,
                    TextTrimming = TextTrimming.CharacterEllipsis,
                    Margin = new Thickness(0, 2, 0, 0)
                });
            }

            var intros = row.Introductions ?? new List<SampleIntroduction>();
            stack.Children.Add(BuildIntrosDropdown(row, intros));

            var introBtn = new Button
            {
                Content = "معرفی فراسازمانی",
                Padding = new Thickness(8, 5, 8, 5),
                MinHeight = 32,
                FontSize = 11,
                Margin = new Thickness(0, 8, 0, 0),
                HorizontalAlignment = HorizontalAlignment.Stretch,
                Tag = row,
                ToolTip = "ثبت معرفی جدید",
                Background = TryFindResource("PrimaryActionBrush") as Brush ?? Brushes.SteelBlue,
                Foreground = Brushes.White,
                BorderThickness = new Thickness(0),
                Cursor = Cursors.Hand
            };
            introBtn.Click += OnIntroduce;
            stack.Children.Add(introBtn);

            var reportBtn = new Button
            {
                Content = "گزارش‌ها (" + PersianDate.DigitsFa(row.ReportCount.ToString()) + ")",
                Padding = new Thickness(8, 5, 8, 5),
                MinHeight = 32,
                FontSize = 11,
                Margin = new Thickness(0, 6, 0, 0),
                HorizontalAlignment = HorizontalAlignment.Stretch,
                Tag = row,
                ToolTip = "مشاهده و ثبت گزارش‌های این فرد نمونه",
                Background = TryFindResource("SoftPanelBrush") as Brush ?? Brushes.WhiteSmoke,
                Foreground = TryFindResource("PrimaryBrush") as Brush ?? Brushes.SteelBlue,
                BorderBrush = TryFindResource("BorderBrush") as Brush,
                BorderThickness = new Thickness(1),
                Cursor = Cursors.Hand
            };
            reportBtn.Click += OnViewReports;
            stack.Children.Add(reportBtn);

            var del = new Button
            {
                Content = "حذف از نمونه",
                Padding = new Thickness(8, 5, 8, 5),
                MinHeight = 32,
                FontSize = 11,
                Margin = new Thickness(0, 6, 0, 0),
                HorizontalAlignment = HorizontalAlignment.Stretch,
                Tag = row,
                Background = TryFindResource("DangerSoftBrush") as Brush ?? new SolidColorBrush(Color.FromRgb(0xFF, 0xEB, 0xEE)),
                Foreground = TryFindResource("DangerBrush") as Brush ?? Brushes.DarkRed,
                BorderBrush = TryFindResource("DangerSoftBorderBrush") as Brush,
                BorderThickness = new Thickness(1),
                Cursor = Cursors.Hand
            };
            del.Click += OnDeleteCard;
            stack.Children.Add(del);

            frame.Child = stack;
            return frame;
        }

        UIElement BuildIntrosDropdown(SampleTitle row, List<SampleIntroduction> intros)
        {
            var box = new ComboBox
            {
                Margin = new Thickness(0, 8, 0, 0),
                MinHeight = 30,
                FontSize = 11,
                HorizontalAlignment = HorizontalAlignment.Stretch,
                IsEditable = false,
                ToolTip = "همه معرفی‌های فراسازمانی این فرد"
            };
            if (intros == null || intros.Count == 0)
            {
                box.Items.Add("بدون معرفی فراسازمانی");
                box.SelectedIndex = 0;
                box.IsEnabled = false;
                return box;
            }

            box.Items.Add("معرفی‌ها (" + PersianDate.DigitsFa(intros.Count.ToString()) + ") — انتخاب برای حذف");
            foreach (var intro in intros)
            {
                var label = intro.Organization ?? "سازمان";
                if (!string.IsNullOrWhiteSpace(intro.Note))
                    label += " — " + intro.Note.Trim();
                box.Items.Add(new ComboBoxItem
                {
                    Content = label,
                    Tag = intro,
                    ToolTip = "برای حذف این معرفی، آن را انتخاب کنید"
                });
            }
            box.SelectedIndex = 0;
            box.SelectionChanged += (s, e) =>
            {
                if (box.SelectedIndex <= 0)
                    return;
                var item = box.SelectedItem as ComboBoxItem;
                var intro = item == null ? null : item.Tag as SampleIntroduction;
                box.SelectedIndex = 0;
                if (intro == null)
                    return;
                var ask = MessageBox.Show(
                    "معرفی به «" + (intro.Organization ?? "") + "» حذف شود؟",
                    AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (ask != MessageBoxResult.Yes)
                    return;
                SessionContext.SampleTitles.DeleteIntroduction(intro.Id);
                Audit("sample_intro_delete", row.EmployeeId);
                RebuildCards();
            };
            return box;
        }

        UIElement BuildSectionHeader(string title, int count, string kind, int year)
        {
            var bar = new Border
            {
                Background = TryFindResource("SoftPanelBrush") as Brush
                    ?? new SolidColorBrush(Color.FromRgb(0xF0, 0xF4, 0xF7)),
                CornerRadius = new CornerRadius(6),
                Padding = new Thickness(10, 6, 10, 6),
                Margin = new Thickness(0, 8, 0, 6)
            };
            var dock = new DockPanel();
            var add = new Button
            {
                Content = "افزودن",
                Style = TryFindResource("ChipButton") as Style,
                Padding = new Thickness(10, 2, 10, 2),
                MinHeight = 26,
                FontSize = 11
            };
            DockPanel.SetDock(add, Dock.Left);
            add.Click += (s, e) =>
            {
                YearBox.SelectedItem = year;
                _focusYear = year;
                PersonBox.Focus();
            };
            dock.Children.Add(add);
            dock.Children.Add(new TextBlock
            {
                Text = title + "  (" + PersianDate.DigitsFa(count.ToString()) + ")",
                FontWeight = FontWeights.SemiBold,
                VerticalAlignment = VerticalAlignment.Center,
                Foreground = TryFindResource("PrimaryBrush") as Brush
            });
            bar.Child = dock;
            return bar;
        }

        UIElement EmptyHint(string text, string kind, int year)
        {
            return new TextBlock
            {
                Text = text,
                Style = TryFindResource("MutedText") as Style,
                Margin = new Thickness(8, 0, 8, 8),
                FontSize = 12
            };
        }

        UIElement BuildPersonRow(SampleTitle row)
        {
            var card = new Border
            {
                Background = Brushes.White,
                BorderBrush = TryFindResource("BorderBrush") as Brush,
                BorderThickness = new Thickness(1),
                CornerRadius = new CornerRadius(8),
                Padding = new Thickness(10),
                Margin = new Thickness(0, 0, 0, 6)
            };
            var root = new StackPanel();

            var top = new Grid();
            top.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
            top.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            top.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

            var photo = new Border
            {
                Width = 40,
                Height = 40,
                CornerRadius = new CornerRadius(6),
                ClipToBounds = true,
                Margin = new Thickness(0, 0, 10, 0),
                Background = TryFindResource("SoftPanelBrush") as Brush,
                Cursor = Cursors.Hand,
                ToolTip = "باز کردن پرونده",
                VerticalAlignment = VerticalAlignment.Top
            };
            var img = PhotoImages.FromEmployee(row.PhotoPath, 80);
            if (img != null)
                photo.Child = new Image { Source = img, Stretch = Stretch.UniformToFill };
            else
                photo.Child = GenderAvatars.ForGender(row.Gender, 22);
            photo.MouseLeftButtonUp += (s, e) =>
            {
                e.Handled = true;
                OpenEmployee(row.EmployeeId);
            };
            top.Children.Add(photo);

            var info = new StackPanel { VerticalAlignment = VerticalAlignment.Center };
            info.Children.Add(new TextBlock
            {
                Text = row.EmployeeName ?? "",
                FontWeight = FontWeights.SemiBold,
                FontSize = 13,
                TextTrimming = TextTrimming.CharacterEllipsis
            });
            var meta = row.Position ?? "بدون سمت";
            if (!string.IsNullOrWhiteSpace(row.NationalId))
                meta += "  ·  " + PersianDate.DigitsFa(row.NationalId);
            info.Children.Add(new TextBlock
            {
                Text = meta,
                FontSize = 11,
                Foreground = TryFindResource("MutedBrush") as Brush,
                TextTrimming = TextTrimming.CharacterEllipsis,
                Margin = new Thickness(0, 2, 0, 0)
            });
            if (!string.IsNullOrWhiteSpace(row.Note))
            {
                info.Children.Add(new TextBlock
                {
                    Text = row.Note,
                    FontSize = 11,
                    TextWrapping = TextWrapping.Wrap,
                    Margin = new Thickness(0, 3, 0, 0)
                });
            }
            Grid.SetColumn(info, 1);
            top.Children.Add(info);

            var actions = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                VerticalAlignment = VerticalAlignment.Top,
                Margin = new Thickness(8, 0, 0, 0)
            };
            var introBtn = new Button
            {
                Content = "معرفی فراسازمانی",
                Style = TryFindResource("PrimaryButton") as Style,
                Padding = new Thickness(10, 4, 10, 4),
                MinHeight = 30,
                FontSize = 11,
                Tag = row,
                ToolTip = "معرفی همین نمونه به سازمان/اداره بالاتر"
            };
            introBtn.Click += OnIntroduce;
            actions.Children.Add(introBtn);
            var reportBtn = new Button
            {
                Content = "گزارش‌ها",
                Style = TryFindResource("GhostButton") as Style,
                Padding = new Thickness(10, 4, 10, 4),
                MinHeight = 30,
                FontSize = 11,
                Margin = new Thickness(6, 0, 0, 0),
                Tag = row,
                ToolTip = "مشاهده گزارش‌ها (" + PersianDate.DigitsFa(row.ReportCount.ToString()) + ")"
            };
            reportBtn.Click += OnViewReports;
            actions.Children.Add(reportBtn);
            var del = new Button
            {
                Content = "حذف",
                Style = TryFindResource("GhostButton") as Style,
                Padding = new Thickness(10, 4, 10, 4),
                MinHeight = 30,
                FontSize = 11,
                Margin = new Thickness(6, 0, 0, 0),
                Tag = row
            };
            del.Click += OnDeleteCard;
            actions.Children.Add(del);
            Grid.SetColumn(actions, 2);
            top.Children.Add(actions);
            root.Children.Add(top);

            var intros = row.Introductions ?? new List<SampleIntroduction>();
            if (intros.Count > 0)
            {
                var introHost = new StackPanel { Margin = new Thickness(50, 8, 0, 0) };
                foreach (var intro in intros)
                {
                    var line = new Border
                    {
                        Background = TryFindResource("SoftPanelBrush") as Brush,
                        CornerRadius = new CornerRadius(6),
                        Padding = new Thickness(8, 5, 8, 5),
                        Margin = new Thickness(0, 0, 0, 4)
                    };
                    var dock = new DockPanel();
                    var delIntro = new Button
                    {
                        Content = "حذف معرفی",
                        Style = TryFindResource("GhostButton") as Style,
                        Padding = new Thickness(8, 2, 8, 2),
                        MinHeight = 24,
                        FontSize = 10,
                        Tag = intro
                    };
                    DockPanel.SetDock(delIntro, Dock.Left);
                    delIntro.Click += OnDeleteIntro;
                    dock.Children.Add(delIntro);
                    var text = "معرفی به «" + (intro.Organization ?? "") + "»";
                    if (!string.IsNullOrWhiteSpace(intro.Note))
                        text += " — " + intro.Note;
                    dock.Children.Add(new TextBlock
                    {
                        Text = text,
                        FontSize = 11,
                        TextWrapping = TextWrapping.Wrap,
                        VerticalAlignment = VerticalAlignment.Center
                    });
                    line.Child = dock;
                    introHost.Children.Add(line);
                }
                root.Children.Add(introHost);
            }

            card.Child = root;
            return card;
        }

        void OnIntroduce(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            var btn = sender as Button;
            var row = btn == null ? null : btn.Tag as SampleTitle;
            if (row == null)
                return;

            string organization;
            string note;
            if (!PromptIntroduction(row, out organization, out note))
                return;

            var err = SessionContext.SampleTitles.AddIntroduction(
                row.Id, organization, note, CurrentUsername());
            if (err != null)
            {
                MessageBox.Show(err, AppConstants.AppNameFa);
                return;
            }
            if (SessionContext.FieldSuggestions != null)
                SessionContext.FieldSuggestions.Remember(FieldSuggestionKeys.SampleOrganization, organization);
            Audit("sample_intro_add", row.EmployeeId);
            RebuildCards();
        }

        bool PromptIntroduction(SampleTitle row, out string organization, out string note)
        {
            organization = null;
            note = null;

            var owner = Window.GetWindow(this);
            var dlg = new Window
            {
                Title = "معرفی فراسازمانی",
                Width = 460,
                SizeToContent = SizeToContent.Height,
                MaxHeight = Math.Max(320, (owner != null ? owner.ActualHeight : 700) * 0.85),
                WindowStartupLocation = owner != null
                    ? WindowStartupLocation.CenterOwner
                    : WindowStartupLocation.CenterScreen,
                Owner = owner,
                ResizeMode = ResizeMode.CanResize,
                MinWidth = 380,
                MinHeight = 260,
                ShowInTaskbar = false,
                FlowDirection = FlowDirection.RightToLeft,
                Background = TryFindResource("BgBrush") as Brush ?? Brushes.White
            };

            var root = new DockPanel { Margin = new Thickness(16) };

            var buttons = new StackPanel
            {
                Orientation = Orientation.Horizontal,
                HorizontalAlignment = HorizontalAlignment.Left,
                Margin = new Thickness(0, 12, 0, 0)
            };
            DockPanel.SetDock(buttons, Dock.Bottom);
            var ok = new Button
            {
                Content = "ثبت معرفی",
                Style = TryFindResource("PrimaryButton") as Style,
                IsDefault = true,
                MinHeight = 34,
                Padding = new Thickness(16, 6, 16, 6)
            };
            var cancel = new Button
            {
                Content = "انصراف",
                Style = TryFindResource("GhostButton") as Style,
                IsCancel = true,
                Margin = new Thickness(8, 0, 0, 0),
                MinHeight = 34,
                Padding = new Thickness(16, 6, 16, 6)
            };
            buttons.Children.Add(ok);
            buttons.Children.Add(cancel);
            root.Children.Add(buttons);

            var scroll = new ScrollViewer
            {
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                HorizontalScrollBarVisibility = ScrollBarVisibility.Disabled,
                CanContentScroll = false
            };
            var form = new StackPanel();
            form.Children.Add(new TextBlock
            {
                Text = (row.EmployeeName ?? "") + " — " + row.KindFa
                    + " سال " + PersianDate.DigitsFa(row.Year.ToString()),
                FontWeight = FontWeights.SemiBold,
                FontSize = 14,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 0, 0, 8)
            });
            form.Children.Add(new TextBlock
            {
                Text = "این نمونه را به کدام سازمان یا اداره بالاتر معرفی می‌کنید؟",
                Style = TryFindResource("MutedText") as Style,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 0, 0, 14)
            });
            form.Children.Add(new TextBlock
            {
                Text = "نام سازمان / اداره",
                Style = TryFindResource("FieldLabel") as Style
            });
            var orgBox = new ComboBox
            {
                IsEditable = true,
                IsTextSearchEnabled = true,
                StaysOpenOnEdit = true,
                Margin = new Thickness(0, 4, 0, 12),
                MinHeight = 32
            };
            var orgs = new HashSet<string>(StringComparer.CurrentCultureIgnoreCase);
            foreach (var o in SessionContext.SampleTitles.ListOrganizations())
                if (!string.IsNullOrWhiteSpace(o)) orgs.Add(o.Trim());
            if (SessionContext.FieldSuggestions != null)
            {
                foreach (var o in SessionContext.FieldSuggestions.List(FieldSuggestionKeys.SampleOrganization))
                    if (!string.IsNullOrWhiteSpace(o)) orgs.Add(o.Trim());
            }
            orgBox.ItemsSource = orgs.OrderBy(x => x).ToList();
            form.Children.Add(orgBox);

            form.Children.Add(new TextBlock
            {
                Text = "یادداشت معرفی (اختیاری)",
                Style = TryFindResource("FieldLabel") as Style
            });
            var noteBox = new TextBox
            {
                MinHeight = 72,
                MaxHeight = 140,
                TextWrapping = TextWrapping.Wrap,
                AcceptsReturn = true,
                VerticalScrollBarVisibility = ScrollBarVisibility.Auto,
                Margin = new Thickness(0, 4, 0, 0)
            };
            form.Children.Add(noteBox);
            scroll.Content = form;
            root.Children.Add(scroll);
            dlg.Content = root;

            // اطمینان از اینکه پنجره داخل صفحه دیده شود
            dlg.Loaded += (s, ev) =>
            {
                if (owner == null)
                    return;
                try
                {
                    var maxH = Math.Max(280, owner.ActualHeight * 0.9);
                    if (dlg.ActualHeight > maxH)
                        dlg.Height = maxH;
                    if (dlg.Top < owner.Top + 8)
                        dlg.Top = owner.Top + 20;
                    if (dlg.Left < 0)
                        dlg.Left = 20;
                }
                catch
                {
                    // ignore layout edge cases
                }
            };

            string orgResult = null;
            string noteResult = null;
            ok.Click += (s, ev) =>
            {
                orgResult = (orgBox.Text ?? "").Trim();
                if (orgResult.Length == 0)
                {
                    MessageBox.Show("نام سازمان را وارد کنید.", AppConstants.AppNameFa);
                    return;
                }
                noteResult = noteBox.Text;
                dlg.DialogResult = true;
            };
            cancel.Click += (s, ev) => dlg.DialogResult = false;

            if (dlg.ShowDialog() != true)
                return false;
            organization = orgResult;
            note = noteResult;
            return true;
        }

        void OnDeleteIntro(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            var btn = sender as Button;
            var intro = btn == null ? null : btn.Tag as SampleIntroduction;
            if (intro == null)
                return;
            if (MessageBox.Show(
                    "معرفی به «" + intro.Organization + "» حذف شود؟",
                    AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            SessionContext.SampleTitles.DeleteIntroduction(intro.Id);
            RebuildCards();
        }

        void OnDeleteCard(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            var btn = sender as Button;
            var row = btn == null ? null : btn.Tag as SampleTitle;
            if (row == null)
                return;
            var msg = "عنوان «" + row.KindFa + "» برای " + row.EmployeeName + " حذف شود؟";
            if (row.HasIntroduction || row.ReportCount > 0)
                msg += "\nمعرفی‌ها و گزارش‌های وابسته نیز حذف می‌شوند.";
            if (MessageBox.Show(msg, AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Question)
                != MessageBoxResult.Yes)
                return;
            SessionContext.SampleTitles.Delete(row.Id);
            RebuildCards();
        }

        void OnViewReports(object sender, RoutedEventArgs e)
        {
            e.Handled = true;
            var btn = sender as Button;
            var row = btn == null ? null : btn.Tag as SampleTitle;
            if (row == null)
                return;
            var w = new SampleReportsWindow(row) { Owner = Window.GetWindow(this) };
            w.ShowDialog();
            RebuildCards();
        }

        void OpenEmployee(string id)
        {
            if (string.IsNullOrEmpty(id))
                return;
            var w = new EmployeeEditWindow(id) { Owner = Window.GetWindow(this) };
            w.ShowDialog();
            LoadPeople();
            RebuildCards();
        }

        static string CurrentUsername()
        {
            return SessionContext.Current == null || SessionContext.Current.User == null
                ? null
                : SessionContext.Current.User.Username;
        }

        static void Audit(string action, string targetId)
        {
            if (SessionContext.Current == null || SessionContext.Current.User == null || SessionContext.Audit == null)
                return;
            SessionContext.Audit.Add(
                SessionContext.Current.User.Id, SessionContext.Current.User.Username,
                action, "sample_title", targetId);
        }

        static string Initials(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                return "؟";
            var parts = name.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length == 1)
                return parts[0].Substring(0, 1);
            return parts[0].Substring(0, 1) + parts[parts.Length - 1].Substring(0, 1);
        }
    }
}
