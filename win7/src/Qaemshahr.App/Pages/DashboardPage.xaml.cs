using System;

using System.Collections.Generic;

using System.Windows;

using System.Windows.Controls;

using System.Windows.Input;

using System.Windows.Media;

using System.Windows.Media.Imaging;

using Qaemshahr.App.Controls;

using Qaemshahr.App.Services;

using Qaemshahr.App.Views;

using Qaemshahr.Core;

using Qaemshahr.Core.Models;



namespace Qaemshahr.App.Pages

{

    public partial class DashboardPage : Page

    {

        HrDashboardSnapshot _snap;



        public DashboardPage()

        {

            InitializeComponent();

            var user = SessionContext.Current == null ? null : SessionContext.Current.User;

            WelcomeText.Text = user == null ? "" : "خوش آمدید، " + user.DisplayName;

            VersionText.Text = AppConstants.AppVersion;

            DataPathText.Text = AppPaths.IsPortable
                ? AppPaths.DataRoot + "  (پرتابل)"
                : AppPaths.DataRoot;

            InstallPathText.Text = AppPaths.InstallDirectory;

            LoadSnapshot();

        }



        void LoadSnapshot()

        {

            try

            {

                _snap = SessionContext.Dashboard.Load();

            }

            catch (Exception ex)

            {

                AppLog.Error("dashboard.load", ex);

                TodayText.Text = "—";

                KpiHost.Children.Add(DashboardCharts.Empty(this, "بارگذاری داشبورد ممکن نشد."));

                return;

            }



            TodayText.Text = PersianDate.DigitsFa(PersianDate.Today());

            HeroSummaryText.Text = "فعال " + PersianDate.DigitsFa(_snap.Active.ToString())

                + "  ·  کارمند " + PersianDate.DigitsFa(_snap.StaffCount.ToString())

                + "  ·  کارگر " + PersianDate.DigitsFa(_snap.WorkerCount.ToString())

                + "  ·  عضو گروه " + PersianDate.DigitsFa(_snap.InGroupCount.ToString());



            BuildKpis();



            PersonTypeHost.Content = DashboardCharts.HorizontalBars(this, _snap.PersonTypes, _snap.Active,

                it => OpenEmployees(DashboardFilter.PersonType, it.Key), false);

            DocsCompleteHost.Content = DashboardCharts.Gauge(this, _snap.DocsCompleteCount, _snap.Active,

                () => OpenEmployees(DashboardFilter.Incomplete, null));

            GenderHost.Content = DashboardCharts.HorizontalBars(this, _snap.GenderBands, _snap.Active,

                it => OpenEmployees(DashboardFilter.Gender, it.Key), false);

            MaritalHost.Content = DashboardCharts.HorizontalBars(this, _snap.MaritalBands, _snap.Active,

                it => OpenEmployees(DashboardFilter.Marital, it.Key), false);

            TypeHost.Content = DashboardCharts.HorizontalBars(this, _snap.EmploymentTypes, _snap.Active,

                it => OpenEmployees(DashboardFilter.Type, it.Key), false);

            if (_snap.Groups == null || _snap.Groups.Count == 0)

                GroupsHost.Content = DashboardCharts.Empty(this, "گروه فعالی تعریف نشده است.");

            else

                GroupsHost.Content = DashboardCharts.HorizontalBars(this, _snap.Groups, _snap.Active,

                    it => OpenEmployees(DashboardFilter.Group, it.Key), false);

            AgeHost.Content = DashboardCharts.HorizontalBars(this, _snap.AgeBands, _snap.Active, null, false);

            TenureHost.Content = DashboardCharts.HorizontalBars(this, _snap.TenureBands, _snap.Active, null, false);

            EduHost.Content = DashboardCharts.HorizontalBars(this, _snap.EducationLevels, _snap.Active, null, false);

            if (_snap.Skills == null || _snap.Skills.Count == 0)

                SkillHost.Content = DashboardCharts.Empty(this, "مهارتی در پرونده‌ها ثبت نشده است.");

            else

                SkillHost.Content = DashboardCharts.HorizontalBars(this, _snap.Skills, _snap.Active, null, false);

            DocsHost.Content = DashboardCharts.DocumentBars(this, _snap.Documents, _snap.Active, OnDocBar);

            HireHost.Content = DashboardCharts.Columns(this, _snap.HireMonths, "نفر");

            ExemplaryCountText.Text = PersianDate.DigitsFa(_snap.Exemplary.ToString());

            ExtraOrgCountText.Text = PersianDate.DigitsFa(_snap.ExtraOrg.ToString());

            FillPeople(ExemplaryHost, _snap.ExemplaryPeople, DashboardFilter.Exemplary, true);

            FillPeople(ExtraOrgHost, _snap.ExtraOrgPeople, DashboardFilter.ExtraOrg, true);

            FillActions(ActionRiskHost, _snap.ContactActions, "تلفن یا سمت ناقصی در نیروی فعال نیست.");

            FillActions(ActionIncompleteHost, _snap.IncompleteActions, "پرونده ناقصی در نیروی فعال نیست.");

        }



        void BuildKpis()

        {

            KpiHost.Children.Clear();

            AddKpi("کل پرونده‌ها", _snap.Total.ToString(), "همهٔ پرسنل ثبت‌شده",

                _snap.Total > 0 ? 1 : 0, false, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F), null, null);

            AddKpi("نیروی فعال", _snap.Active.ToString(), "از " + _snap.Total + " پرونده",

                Ratio(_snap.Active, _snap.Total), true, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F), DashboardFilter.Active, null);

            AddKpi("غیرفعال", _snap.Inactive.ToString(), "خارج از خدمت جاری",

                Ratio(_snap.Inactive, _snap.Total), true, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74), DashboardFilter.Inactive, null);

            AddKpi("کارمند", _snap.StaffCount.ToString(), "نوع پرسنل کارمند",

                Ratio(_snap.StaffCount, _snap.Active), true, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F), DashboardFilter.PersonStaff, null);

            AddKpi("کارگر", _snap.WorkerCount.ToString(), "نوع پرسنل کارگر",

                Ratio(_snap.WorkerCount, _snap.Active), true, "PrimaryLightBrush", Color.FromRgb(0x1A, 0x6A, 0x96), DashboardFilter.PersonWorker, null);

            AddKpi("عضو گروه", _snap.InGroupCount.ToString(), "حداقل در یک گروه",

                Ratio(_snap.InGroupCount, _snap.Active), true, "SuccessTextBrush", Color.FromRgb(0x1B, 0x5E, 0x20), DashboardFilter.InGroup, null);

            AddKpi("بدون گروه", _snap.NotInGroupCount.ToString(), "عضو هیچ گروهی نیست",

                Ratio(_snap.NotInGroupCount, _snap.Active), true, "MutedBrush", Color.FromRgb(0x78, 0x90, 0x9C), DashboardFilter.NotInGroup, null);

            AddKpi("پرونده کامل", _snap.DocsCompleteCount.ToString(), "عکس + شناسنامه + کارت ملی",

                Ratio(_snap.DocsCompleteCount, _snap.Active), true, "SuccessTextBrush", Color.FromRgb(0x1B, 0x5E, 0x20), null, null);

            AddKpi("پرونده ناقص", _snap.Incomplete.ToString(), "مدارک هویتی ناقص",

                Ratio(_snap.Incomplete, _snap.Active), true, "AccentBrush", Color.FromRgb(0xC4, 0x1E, 0x3A), DashboardFilter.Incomplete, null);

            AddKpi("تلفن یا سمت خالی", _snap.MissingContact.ToString(), "چارت یا تماس ناقص",

                Ratio(_snap.MissingContact, _snap.Active), true, "PrimaryLightBrush", Color.FromRgb(0x1A, 0x6A, 0x96), DashboardFilter.Contact, null);

        }



        static double Ratio(int part, int whole)

        {

            return whole <= 0 ? 0 : Math.Max(0, Math.Min(1, (double)part / whole));

        }



        void AddKpi(string title, string value, string subtitle, double ratio, bool showPct,

            string brushKey, Color fallback, string filter, string filterValue)

        {

            var accent = string.IsNullOrEmpty(brushKey)

                ? (Brush)new SolidColorBrush(fallback)

                : DashboardCharts.BrushOf(this, brushKey, fallback);

            var card = new Border

            {

                Style = TryFindResource("Card") as Style,

                Width = 188,

                MinHeight = 128,

                Margin = new Thickness(0, 0, 10, 10),

                Padding = new Thickness(0),

                Cursor = filter == null ? Cursors.Arrow : Cursors.Hand,

                ToolTip = filter == null ? null : "برای مشاهده جزئیات کلیک کنید",

                SnapsToDevicePixels = true

            };

            var grid = new Grid { Margin = new Thickness(14, 12, 14, 12) };

            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });

            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });

            grid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });

            grid.RowDefinitions.Add(new RowDefinition { Height = GridLength.Auto });



            var top = new Grid();

            top.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });

            top.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

            top.Children.Add(new TextBlock

            {

                Text = title,

                FontSize = 12,

                Foreground = TryFindResource("MutedBrush") as Brush,

                TextWrapping = TextWrapping.Wrap,

                VerticalAlignment = VerticalAlignment.Center

            });

            var icon = new Border

            {

                Width = 10,

                Height = 10,

                CornerRadius = new CornerRadius(5),

                Background = accent,

                Margin = new Thickness(8, 0, 0, 0),

                VerticalAlignment = VerticalAlignment.Center

            };

            Grid.SetColumn(icon, 1);

            top.Children.Add(icon);

            grid.Children.Add(top);



            var num = new TextBlock

            {

                Text = PersianDate.DigitsFa(value),

                FontSize = 28,

                FontWeight = FontWeights.Bold,

                Foreground = accent,

                Margin = new Thickness(0, 8, 0, 2)

            };

            Grid.SetRow(num, 1);

            grid.Children.Add(num);



            var pctText = showPct

                ? "  ·  " + PersianDate.DigitsFa(((int)Math.Round(ratio * 100)).ToString()) + "٪"

                : "";

            var sub = new TextBlock

            {

                Text = subtitle + pctText,

                FontSize = 11,

                Foreground = TryFindResource("MutedBrush") as Brush,

                TextWrapping = TextWrapping.Wrap

            };

            Grid.SetRow(sub, 2);

            grid.Children.Add(sub);



            var bar = BuildRatioBar(ratio, accent);

            Grid.SetRow(bar, 3);

            grid.Children.Add(bar);



            card.Child = grid;

            if (filter != null)

            {

                card.MouseLeftButtonUp += (s, e) =>

                {

                    e.Handled = true;

                    OpenEmployees(filter, filterValue);

                };

            }

            KpiHost.Children.Add(card);

        }



        FrameworkElement BuildRatioBar(double ratio, Brush accent)

        {

            ratio = Math.Max(0, Math.Min(1, ratio));

            var g = new Grid { Height = 5, Margin = new Thickness(0, 10, 0, 0) };

            var track = new Border

            {

                Background = TryFindResource("SoftPanelBrush") as Brush,

                CornerRadius = new CornerRadius(3)

            };

            g.Children.Add(track);

            if (ratio <= 0.001)

                return g;

            g.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(ratio * 100, GridUnitType.Star) });

            g.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(Math.Max(0.01, (1 - ratio) * 100), GridUnitType.Star) });

            Grid.SetColumnSpan(track, 2);

            var fill = new Border { Background = accent, CornerRadius = new CornerRadius(3), Opacity = 0.95 };

            Grid.SetColumn(fill, 0);

            g.Children.Add(fill);

            return g;

        }



        void FillPeople(StackPanel host, List<DashboardActionRow> rows, string filter, bool withPhoto)

        {

            host.Children.Clear();

            if (rows == null || rows.Count == 0)

            {

                host.Children.Add(DashboardCharts.Empty(this, "موردی نیست."));

                return;

            }

            foreach (var row in rows)

                host.Children.Add(ActionLine(row, false, withPhoto));

            host.Children.Add(MoreLink("مشاهده همه", () => OpenEmployees(filter, null)));

        }



        void FillActions(StackPanel host, List<DashboardActionRow> rows, string empty)

        {

            host.Children.Clear();

            if (rows == null || rows.Count == 0)

            {

                host.Children.Add(DashboardCharts.Empty(this, empty));

                return;

            }

            foreach (var row in rows)

                host.Children.Add(ActionLine(row, true, false));

        }



        UIElement ActionLine(DashboardActionRow row, bool withButton, bool withPhoto)

        {

            var box = new Border

            {

                Style = TryFindResource("SoftPanel") as Style,

                Padding = new Thickness(10, 8, 10, 8),

                Margin = new Thickness(0, 0, 0, 8),

                Cursor = Cursors.Hand

            };

            var grid = new Grid();

            var col = 0;

            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(5) });

            col++;

            if (withPhoto)

            {

                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

                col++;

            }

            grid.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });

            var infoCol = col;

            col++;

            if (withButton)

                grid.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });



            var strip = new Border

            {

                Width = 5,

                CornerRadius = new CornerRadius(2),

                Background = new SolidColorBrush(DashboardCharts.LightColor(row.Light)),

                Margin = new Thickness(0, 0, 8, 0),

                VerticalAlignment = VerticalAlignment.Stretch

            };

            Grid.SetColumn(strip, 0);

            grid.Children.Add(strip);



            if (withPhoto)

            {

                var photoFrame = BuildPhotoThumb(row.PhotoPath);

                Grid.SetColumn(photoFrame, 1);

                grid.Children.Add(photoFrame);

            }



            var info = new StackPanel { Margin = new Thickness(withPhoto ? 10 : 0, 0, 0, 0) };

            info.Children.Add(new TextBlock

            {

                Text = row.Name,

                FontWeight = FontWeights.SemiBold,

                TextTrimming = TextTrimming.CharacterEllipsis

            });

            info.Children.Add(new TextBlock

            {

                Text = row.Position,

                Style = TryFindResource("MutedText") as Style,

                FontSize = 12,

                TextTrimming = TextTrimming.CharacterEllipsis

            });

            if (!string.IsNullOrWhiteSpace(row.Detail))

            {

                info.Children.Add(new TextBlock

                {

                    Text = row.Detail,

                    FontSize = 11,

                    Foreground = TryFindResource("MutedBrush") as Brush,

                    TextWrapping = TextWrapping.Wrap,

                    Margin = new Thickness(0, 2, 0, 0)

                });

            }

            Grid.SetColumn(info, infoCol);

            grid.Children.Add(info);



            if (withButton)

            {

                var btn = new Button

                {

                    Content = "پرونده",

                    Style = TryFindResource("GhostButton") as Style,

                    Padding = new Thickness(10, 4, 10, 4),

                    MinHeight = 28,

                    MinWidth = 64,

                    FontSize = 12,

                    Margin = new Thickness(8, 0, 0, 0),

                    VerticalAlignment = VerticalAlignment.Center

                };

                btn.Click += (s, e) =>

                {

                    e.Handled = true;

                    OpenFile(row.EmployeeId);

                };

                Grid.SetColumn(btn, infoCol + 1);

                grid.Children.Add(btn);

            }



            box.Child = grid;

            box.MouseLeftButtonUp += (s, e) =>

            {

                e.Handled = true;

                OpenFile(row.EmployeeId);

            };

            return box;

        }



        Border BuildPhotoThumb(string photoPath)

        {

            var frame = new Border

            {

                Width = 42,

                Height = 56,

                CornerRadius = new CornerRadius(6),

                BorderBrush = TryFindResource("BorderBrush") as Brush,

                BorderThickness = new Thickness(1),

                Background = TryFindResource("SoftPanelBrush") as Brush ?? Brushes.WhiteSmoke,

                ClipToBounds = true,

                VerticalAlignment = VerticalAlignment.Center

            };

            BitmapImage img = null;

            try

            {

                img = PhotoImages.FromEmployee(photoPath, 84);

            }

            catch

            {

            }

            if (img != null)

            {

                frame.Child = new Image

                {

                    Source = img,

                    Stretch = Stretch.UniformToFill,

                    HorizontalAlignment = HorizontalAlignment.Center,

                    VerticalAlignment = VerticalAlignment.Center

                };

            }

            else

            {

                frame.Child = new TextBlock

                {

                    Text = "۴×۳",

                    FontSize = 10,

                    Foreground = TryFindResource("MutedBrush") as Brush,

                    HorizontalAlignment = HorizontalAlignment.Center,

                    VerticalAlignment = VerticalAlignment.Center

                };

            }

            return frame;

        }



        Button MoreLink(string text, Action click)

        {

            var btn = new Button

            {

                Content = text,

                Style = TryFindResource("GhostButton") as Style,

                HorizontalAlignment = HorizontalAlignment.Right,

                Padding = new Thickness(10, 4, 10, 4),

                MinHeight = 28,

                FontSize = 12,

                Margin = new Thickness(0, 4, 0, 0)

            };

            btn.Click += (s, e) => { e.Handled = true; click(); };

            return btn;

        }



        void OnDocBar(NamedCount item)

        {

            OpenEmployees(item.Key, null);

        }



        void OpenEmployees(string filter, string value)

        {

            var shell = Window.GetWindow(this) as ShellWindow;

            if (shell == null)

                return;

            shell.OpenEmployees(filter, value);

        }



        void OpenFile(string employeeId)

        {

            if (string.IsNullOrEmpty(employeeId))

                return;

            if (!SessionContext.Can(PermissionCodes.EmployeesView))

            {

                MessageBox.Show("شما به این بخش دسترسی ندارید.", AppConstants.AppNameFa);

                return;

            }

            var w = new EmployeeEditWindow(employeeId) { Owner = Window.GetWindow(this) };

            if (w.ShowDialog() == true)

                LoadSnapshot();

        }

    }

}


