using System;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Windows.Threading;
using Qaemshahr.App.Pages;
using Qaemshahr.App.Services;
using Qaemshahr.Core;

namespace Qaemshahr.App.Views
{
    public partial class ShellWindow : Window
    {
        const double ExpandedWidth = 228;
        const double CollapsedWidth = 72;
        const string MenuPath = "M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z";
        // منو سمت راست است؛ فلش باز کردن به سمت محتوا (چپ) اشاره می‌کند
        const string ExpandPath = "M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z";

        static readonly NavSpec[] Items =
        {
            new NavSpec("dashboard", "داشبورد", null,
                "M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"),
            new NavSpec("employees", "پرسنل", PermissionCodes.EmployeesView,
                "M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"),
            new NavSpec("samples", "عناوین نمونه", PermissionCodes.EmployeesView,
                "M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"),
            new NavSpec("search", "جستجو", PermissionCodes.SearchAdvanced,
                "M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"),
            new NavSpec("groups", "گروه‌ها", PermissionCodes.GroupsView,
                "M16 11c1.66 0 2.99-1.34 2.99-3S17.66 5 16 5c-1.66 0-3 1.34-3 3s1.34 3 3 3zm-8 0c1.66 0 2.99-1.34 2.99-3S9.66 5 8 5C6.34 5 5 6.34 5 8s1.34 3 3 3zm0 2c-2.33 0-7 1.17-7 3.5V19h14v-2.5c0-2.33-4.67-3.5-7-3.5zm8 0c-.29 0-.62.02-.97.05 1.16.84 1.97 1.97 1.97 3.45V19h6v-2.5c0-2.33-4.67-3.5-7-3.5z"),
            new NavSpec("documents", "اسناد", PermissionCodes.DocumentsView,
                "M10 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V8c0-1.1-.9-2-2-2h-8l-2-2z"),
            new NavSpec("reports", "گزارش‌ها", PermissionCodes.ReportsView,
                "M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"),
            new NavSpec("settings", "تنظیمات", null,
                "M19.14,12.94c0.04-0.31,0.06-0.63,0.06-0.94c0-0.31-0.02-0.63-0.06-0.94l2.03-1.58c0.18-0.14,0.23-0.41,0.12-0.61 l-1.92-3.32c-0.12-0.22-0.37-0.29-0.59-0.22l-2.39,0.96c-0.5-0.38-1.03-0.7-1.62-0.94L14.4,2.81c-0.04-0.24-0.24-0.41-0.48-0.41 h-3.84c-0.24,0-0.43,0.17-0.47,0.41L9.25,5.35C8.66,5.59,8.12,5.92,7.63,6.29L5.24,5.33c-0.22-0.08-0.47,0-0.59,0.22L2.74,8.87 C2.62,9.08,2.66,9.34,2.86,9.48l2.03,1.58C4.84,11.37,4.8,11.69,4.8,12s0.02,0.63,0.06,0.94l-2.03,1.58 c-0.18,0.14-0.23,0.41-0.12,0.61l1.92,3.32c0.12,0.22,0.37,0.29,0.59,0.22l2.39-0.96c0.5,0.38,1.03,0.7,1.62,0.94l0.36,2.54 c0.05,0.24,0.24,0.41,0.48,0.41h3.84c0.24,0,0.44-0.17,0.47-0.41l0.36-2.54c0.59-0.24,1.13-0.56,1.62-0.94l2.39,0.96 c0.22,0.08,0.47,0,0.59-0.22l1.92-3.32c0.12-0.22,0.07-0.47-0.12-0.61L19.14,12.94z M12,15.6c-1.98,0-3.6-1.62-3.6-3.6 s1.62-3.6,3.6-3.6s3.6,1.62,3.6,3.6S13.98,15.6,12,15.6z")
        };

        readonly DispatcherTimer _idleTimer = new DispatcherTimer();
        bool _locking;
        bool _navExpanded = true;
        string _currentKey = "dashboard";
        string _pendingEmployeeFilter;
        string _pendingEmployeeValue;
        string _pendingSettingsTab;

        public ShellWindow()
        {
            InitializeComponent();
            var user = SessionContext.Current.User;
            UserLabel.Text = string.IsNullOrWhiteSpace(user.DisplayName) ? user.Username : user.DisplayName;
            _navExpanded = SessionContext.Settings.Get("ui.nav_expanded", "1") != "0";
            RebuildNav();
            ApplyNavMode(false);
            Navigate("dashboard");
            _idleTimer.Interval = TimeSpan.FromSeconds(15);
            _idleTimer.Tick += (s, e) => CheckIdle();
            _idleTimer.Start();
        }

        void RebuildNav()
        {
            NavPanel.Children.Clear();
            foreach (var item in Items)
            {
                if (item.Key == "settings")
                {
                    if (!CanOpenSettings())
                        continue;
                }
                else if (item.Permission != null && !SessionContext.Can(item.Permission))
                    continue;
                NavPanel.Children.Add(MakeNavButton(item));
            }
        }

        static bool CanOpenSettings()
        {
            return SessionContext.Can(PermissionCodes.SystemSettings)
                || SessionContext.Can(PermissionCodes.UsersView)
                || SessionContext.Can(PermissionCodes.SystemAuditView)
                || SessionContext.Can(PermissionCodes.SystemBackup)
                || SessionContext.Can(PermissionCodes.SystemRestore);
        }

        Button MakeNavButton(NavSpec item)
        {
            // DockPanel LTR: اولین Dock=Right می‌شود راست‌ترین عنصر.
            // ترتیب: اول آیکون (لب راست)، بعد متن (چسبیده به آیکون) — بدون فضای خالی وسط.
            var icon = new Viewbox
            {
                Width = 20,
                Height = 20,
                Stretch = Stretch.Uniform,
                FlowDirection = FlowDirection.LeftToRight,
                VerticalAlignment = VerticalAlignment.Center,
                Margin = new Thickness(8, 0, 0, 0)
            };
            icon.Child = new Path
            {
                Data = Geometry.Parse(item.Icon),
                Fill = TryFindResource("PrimaryBrush") as Brush ?? Brushes.SteelBlue,
                Stretch = Stretch.Uniform,
                FlowDirection = FlowDirection.LeftToRight
            };
            var label = new TextBlock
            {
                Text = item.Title,
                VerticalAlignment = VerticalAlignment.Center,
                TextAlignment = TextAlignment.Right,
                Foreground = TryFindResource("NavItemFgBrush") as Brush ?? Brushes.SteelBlue,
                FontFamily = (FontFamily)FindResource("AppFont"),
                FlowDirection = FlowDirection.RightToLeft
            };

            var panel = new DockPanel
            {
                LastChildFill = true,
                FlowDirection = FlowDirection.LeftToRight
            };
            DockPanel.SetDock(icon, Dock.Right);
            panel.Children.Add(icon);
            DockPanel.SetDock(label, Dock.Right);
            panel.Children.Add(label);
            panel.Children.Add(new Border()); // فضای باقی‌مانده فقط سمت چپ

            var btn = new Button
            {
                Tag = item.Key,
                Content = panel,
                Style = (Style)FindResource("NavButton"),
                ToolTip = item.Title,
                FlowDirection = FlowDirection.LeftToRight,
                HorizontalContentAlignment = HorizontalAlignment.Stretch
            };
            btn.Click += OnNav;
            ToolTipService.SetInitialShowDelay(btn, 400);
            return btn;
        }

        void OnToggleNav(object sender, RoutedEventArgs e)
        {
            _navExpanded = !_navExpanded;
            SessionContext.Settings.Set("ui.nav_expanded", _navExpanded ? "1" : "0");
            ApplyNavMode(true);
        }

        void ApplyNavMode(bool animate)
        {
            var width = _navExpanded ? ExpandedWidth : CollapsedWidth;
            if (animate)
            {
                var anim = new DoubleAnimation(width, TimeSpan.FromMilliseconds(180));
                anim.FillBehavior = FillBehavior.Stop;
                anim.Completed += (s, e) =>
                {
                    NavBorder.BeginAnimation(WidthProperty, null);
                    NavBorder.Width = width;
                };
                NavBorder.BeginAnimation(WidthProperty, anim);
            }
            else
            {
                NavBorder.BeginAnimation(WidthProperty, null);
                NavBorder.Width = width;
            }

            NavToggleLabel.Visibility = _navExpanded ? Visibility.Visible : Visibility.Collapsed;
            NavToggle.FlowDirection = FlowDirection.LeftToRight;
            NavToggle.HorizontalContentAlignment = HorizontalAlignment.Stretch;
            NavToggle.ToolTip = _navExpanded ? "جمع کردن منو" : "باز کردن منو";
            NavTogglePath.Data = Geometry.Parse(_navExpanded ? MenuPath : ExpandPath);
            if (_navExpanded)
            {
                DockPanel.SetDock(NavToggleIconHost, Dock.Right);
                DockPanel.SetDock(NavToggleLabel, Dock.Right);
                NavToggleIconHost.HorizontalAlignment = HorizontalAlignment.Right;
                NavToggleIconHost.Margin = new Thickness(8, 0, 0, 0);
                NavToggleFiller.Visibility = Visibility.Visible;
            }
            else
            {
                DockPanel.SetDock(NavToggleIconHost, Dock.Right);
                NavToggleIconHost.HorizontalAlignment = HorizontalAlignment.Center;
                NavToggleIconHost.Margin = new Thickness(0);
                NavToggleFiller.Visibility = Visibility.Collapsed;
                // وسط‌چین وقتی فقط آیکون است
                NavToggle.HorizontalContentAlignment = HorizontalAlignment.Center;
            }

            foreach (var child in NavPanel.Children)
            {
                var button = child as Button;
                if (button == null)
                    continue;
                button.FlowDirection = FlowDirection.LeftToRight;
                button.HorizontalContentAlignment = _navExpanded
                    ? HorizontalAlignment.Stretch
                    : HorizontalAlignment.Center;
                // padding راست کم تا به لبهٔ راست منو نزدیک باشد
                button.Padding = _navExpanded ? new Thickness(8, 10, 4, 10) : new Thickness(10, 12, 10, 12);
                button.Margin = _navExpanded ? new Thickness(6, 3, 4, 3) : new Thickness(10, 4, 10, 4);

                var panel = button.Content as DockPanel;
                if (panel == null || panel.Children.Count < 2)
                    continue;

                var icon = panel.Children[0] as FrameworkElement;
                var label = panel.Children[1] as FrameworkElement;
                if (icon == null || label == null)
                    continue;

                label.Visibility = _navExpanded ? Visibility.Visible : Visibility.Collapsed;
                if (panel.Children.Count > 2)
                    panel.Children[2].Visibility = _navExpanded ? Visibility.Visible : Visibility.Collapsed;

                if (_navExpanded)
                {
                    DockPanel.SetDock(icon, Dock.Right);
                    DockPanel.SetDock(label, Dock.Right);
                    icon.HorizontalAlignment = HorizontalAlignment.Right;
                    icon.Margin = new Thickness(8, 0, 0, 0);
                }
                else
                {
                    icon.ClearValue(DockPanel.DockProperty);
                    icon.HorizontalAlignment = HorizontalAlignment.Center;
                    icon.Margin = new Thickness(0);
                }
            }
        }

        void CheckIdle()
        {
            if (_locking || SessionContext.Current == null || SessionContext.Settings == null || SessionContext.Database == null)
                return;
            var minutes = SessionContext.Settings.GetInt("security.auto_lock_minutes", AppConstants.DefaultAutoLockMinutes);
            if (minutes <= 0)
                return;
            var idle = GetIdleTime();
            if (idle.TotalMinutes >= minutes)
                ShowLock();
        }

        void ShowLock()
        {
            _locking = true;
            try
            {
                var w = new LockWindow { Owner = this };
                if (w.ShowDialog() != true)
                    Close();
                else
                    UserLabel.Text = string.IsNullOrWhiteSpace(SessionContext.Current.User.DisplayName)
                        ? SessionContext.Current.User.Username
                        : SessionContext.Current.User.DisplayName;
            }
            finally
            {
                _locking = false;
            }
        }

        void HighlightNav(string key)
        {
            var selected = (Style)FindResource("NavButtonSelected");
            var normal = (Style)FindResource("NavButton");
            foreach (var child in NavPanel.Children)
            {
                var button = child as Button;
                if (button == null)
                    continue;
                button.Style = (button.Tag as string) == key ? selected : normal;
            }
        }

        void OnNav(object sender, RoutedEventArgs e)
        {
            Navigate(((Button)sender).Tag as string);
        }

        public void OpenEmployees(string filter, string value)
        {
            _pendingEmployeeFilter = filter;
            _pendingEmployeeValue = value;
            Navigate("employees");
        }

        void Navigate(string key)
        {
            if (key == "users" || key == "audit" || key == "backup")
            {
                if (key == "users")
                    _pendingSettingsTab = "users";
                else if (key == "audit")
                    _pendingSettingsTab = "log";
                else
                    _pendingSettingsTab = "backup";
                key = "settings";
            }
            if (key == "settings")
            {
                if (!CanOpenSettings())
                {
                    MessageBox.Show("شما به این بخش دسترسی ندارید.", AppConstants.AppNameFa);
                    return;
                }
            }
            else
            {
                var required = Required(key);
                if (required != null && !SessionContext.Can(required))
                {
                    MessageBox.Show("شما به این بخش دسترسی ندارید.", AppConstants.AppNameFa);
                    return;
                }
            }
            Page page;
            switch (key)
            {
                case "dashboard": page = new DashboardPage(); break;
                case "employees":
                    page = new EmployeeListPage(_pendingEmployeeFilter, _pendingEmployeeValue);
                    _pendingEmployeeFilter = null;
                    _pendingEmployeeValue = null;
                    break;
                case "samples": page = new SampleTitlesPage(); break;
                case "search": page = new SearchPage(); break;
                case "groups": page = new GroupsPage(); break;
                case "documents": page = new DocumentsPage(); break;
                case "reports": page = new ReportsPage(); break;
                case "settings":
                    page = new SettingsPage(_pendingSettingsTab);
                    _pendingSettingsTab = null;
                    break;
                default: page = new PlaceholderPage(key); break;
            }
            _currentKey = key;
            HighlightNav(key);
            ApplyNavMode(false);
            ContentFrame.Navigate(page);
        }

        static string Required(string key)
        {
            switch (key)
            {
                case "employees": return PermissionCodes.EmployeesView;
                case "samples": return PermissionCodes.EmployeesView;
                case "search": return PermissionCodes.SearchAdvanced;
                case "groups": return PermissionCodes.GroupsView;
                case "documents": return PermissionCodes.DocumentsView;
                case "reports": return PermissionCodes.ReportsView;
                default: return null;
            }
        }

        void OnLogout(object sender, RoutedEventArgs e)
        {
            _idleTimer.Stop();
            if (SessionContext.Current != null)
                SessionContext.Auth.Logout(SessionContext.Current.SessionId);
            SessionContext.Current = null;
            var login = new LoginWindow();
            Hide();
            var ok = login.ShowDialog();
            if (ok == true && SessionContext.Current != null)
            {
                if (SessionContext.Current.User.MustChangePassword)
                {
                    var change = new ChangePasswordWindow { Owner = this };
                    if (change.ShowDialog() != true)
                    {
                        Close();
                        return;
                    }
                }
                UserLabel.Text = string.IsNullOrWhiteSpace(SessionContext.Current.User.DisplayName)
                    ? SessionContext.Current.User.Username
                    : SessionContext.Current.User.DisplayName;
                RebuildNav();
                ApplyNavMode(false);
                Navigate("dashboard");
                _idleTimer.Start();
                Show();
            }
            else
                Close();
        }

        [DllImport("user32.dll")]
        static extern bool GetLastInputInfo(ref LastInputInfo plii);

        struct LastInputInfo
        {
            public uint Size;
            public uint Time;
        }

        static TimeSpan GetIdleTime()
        {
            var info = new LastInputInfo();
            info.Size = (uint)Marshal.SizeOf(info);
            if (!GetLastInputInfo(ref info))
                return TimeSpan.Zero;
            var idle = unchecked(Environment.TickCount - (int)info.Time);
            if (idle < 0)
                idle = 0;
            return TimeSpan.FromMilliseconds(idle);
        }

        sealed class NavSpec
        {
            public readonly string Key;
            public readonly string Title;
            public readonly string Permission;
            public readonly string Icon;

            public NavSpec(string key, string title, string permission, string icon)
            {
                Key = key;
                Title = title;
                Permission = permission;
                Icon = icon;
            }
        }
    }
}
