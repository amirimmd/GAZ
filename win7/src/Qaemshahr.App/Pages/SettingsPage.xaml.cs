using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using Microsoft.Win32;
using Qaemshahr.App.Services;
using Qaemshahr.App.Views;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Pages
{
    public partial class SettingsPage : Page
    {
        readonly string _focusTab;
        List<AuditRow> _auditAll = new List<AuditRow>();

        public SettingsPage() : this(null)
        {
        }

        public SettingsPage(string focusTab)
        {
            _focusTab = focusTab;
            InitializeComponent();
            LoadGeneral();
            SetupTabsByPermission();
            if (UsersTab.Visibility == Visibility.Visible)
                LoadUsers();
            if (AuditTab.Visibility == Visibility.Visible)
            {
                LoadAudit();
                AuditSearchBox.TextChanged += (s, e) => ApplyAuditFilter();
            }
            if (BackupTab.Visibility == Visibility.Visible)
                UiInput.UseEnglishCredentials(BackupPassBox, BackupPass2Box, RestorePassBox);
            SelectFocusTab();
        }

        void SetupTabsByPermission()
        {
            var canGeneral = SessionContext.Can(PermissionCodes.SystemSettings);
            var canBackup = SessionContext.Can(PermissionCodes.SystemBackup)
                || SessionContext.Can(PermissionCodes.SystemRestore);
            var canUsers = SessionContext.Can(PermissionCodes.UsersView);
            var canAudit = SessionContext.Can(PermissionCodes.SystemAuditView);

            GeneralTab.Visibility = canGeneral ? Visibility.Visible : Visibility.Collapsed;
            BackupTab.Visibility = canBackup ? Visibility.Visible : Visibility.Collapsed;
            UsersTab.Visibility = canUsers ? Visibility.Visible : Visibility.Collapsed;
            AuditTab.Visibility = canAudit ? Visibility.Visible : Visibility.Collapsed;

            if (canGeneral)
                RootTabs.SelectedItem = GeneralTab;
            else if (canBackup)
                RootTabs.SelectedItem = BackupTab;
            else if (canUsers)
                RootTabs.SelectedItem = UsersTab;
            else if (canAudit)
                RootTabs.SelectedItem = AuditTab;
        }

        void SelectFocusTab()
        {
            if (string.IsNullOrWhiteSpace(_focusTab))
                return;
            switch (_focusTab.Trim().ToLowerInvariant())
            {
                case "backup":
                    if (BackupTab.Visibility == Visibility.Visible)
                        RootTabs.SelectedItem = BackupTab;
                    break;
                case "users":
                    if (UsersTab.Visibility == Visibility.Visible)
                        RootTabs.SelectedItem = UsersTab;
                    break;
                case "audit":
                case "log":
                    if (AuditTab.Visibility == Visibility.Visible)
                        RootTabs.SelectedItem = AuditTab;
                    break;
                case "general":
                    if (GeneralTab.Visibility == Visibility.Visible)
                        RootTabs.SelectedItem = GeneralTab;
                    break;
            }
        }

        void LoadGeneral()
        {
            OrgBox.Text = SessionContext.Settings.Get("organization.name.fa", AppConstants.OrganizationNameFa);
            SessionBox.Text = SessionContext.Settings.GetInt("security.session_timeout_minutes", AppConstants.DefaultSessionTimeoutMinutes).ToString();
            LockBox.Text = SessionContext.Settings.GetInt("security.auto_lock_minutes", AppConstants.DefaultAutoLockMinutes).ToString();
            DataPath.Text = AppPaths.IsPortable
                ? AppPaths.DataRoot + "  (حالت پرتابل — همراه همین پوشه)"
                : AppPaths.DataRoot;
            InstallPath.Text = AppPaths.InstallDirectory;
        }

        void LoadUsers()
        {
            UiInput.UseEnglish(UserBox, PassBox);
            RoleBox.ItemsSource = SessionContext.Users.Roles();
            UsersGrid.ItemsSource = SessionContext.Users.List();
        }

        void LoadAudit()
        {
            _auditAll = SessionContext.Audit.List(2000) ?? new List<AuditRow>();
            ApplyAuditFilter();
        }

        void ApplyAuditFilter()
        {
            var q = (AuditSearchBox.Text ?? "").Trim();
            IEnumerable<AuditRow> rows = _auditAll;
            if (q.Length > 0)
            {
                rows = _auditAll.Where(r =>
                    Contains(r.ActorUsername, q)
                    || Contains(r.Action, q)
                    || Contains(r.ActionFa, q)
                    || Contains(r.EntityType, q)
                    || Contains(r.EntityTypeFa, q)
                    || Contains(r.Details, q)
                    || Contains(r.DetailsFa, q)
                    || Contains(r.CreatedDateTimeFa, q));
            }
            var list = rows.ToList();
            AuditGrid.ItemsSource = list;
            AuditCountText.Text = PersianDate.DigitsFa(list.Count.ToString()) + " ردیف";
        }

        static bool Contains(string hay, string needle)
        {
            return !string.IsNullOrEmpty(hay)
                && hay.IndexOf(needle, StringComparison.OrdinalIgnoreCase) >= 0;
        }

        void OnRefreshAudit(object sender, RoutedEventArgs e)
        {
            LoadAudit();
        }

        void OnSaveGeneral(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.SystemSettings))
            {
                MessageBox.Show("دسترسی ندارید.");
                return;
            }
            // نام سازمان قفل است و ذخیره نمی‌شود
            int s, l;
            if (int.TryParse(SessionBox.Text, out s) && s > 0)
                SessionContext.Settings.Set("security.session_timeout_minutes", s.ToString());
            if (int.TryParse(LockBox.Text, out l) && l > 0)
                SessionContext.Settings.Set("security.auto_lock_minutes", l.ToString());
            MessageBox.Show("ذخیره شد. قفل خودکار از نشست بعدی اعمال می‌شود.");
        }

        void OnPassword(object sender, RoutedEventArgs e)
        {
            var w = new ChangePasswordWindow { Owner = Window.GetWindow(this) };
            w.ShowDialog();
        }

        void OnCreateUser(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.UsersCreate))
            {
                MessageBox.Show("دسترسی ندارید");
                return;
            }
            var roleId = RoleBox.SelectedValue as string;
            var err = SessionContext.Users.Create(UserBox.Text, NameBox.Text, PassBox.Password, roleId);
            if (err != null)
            {
                MessageBox.Show(err);
                return;
            }
            UsersGrid.ItemsSource = SessionContext.Users.List();
        }

        void OnResetUser(object sender, RoutedEventArgs e)
        {
            var u = UsersGrid.SelectedItem as UserSummary;
            if (u == null)
                return;
            var temp = PasswordPolicy.GenerateTemporaryPassword();
            var err = SessionContext.Users.ResetPassword(u.Id, temp);
            if (err != null)
            {
                MessageBox.Show(err);
                return;
            }
            MessageBox.Show(
                "رمز موقت برای «" + u.Username + "»:\n" + temp +
                "\n\nاین رمز را فقط یک‌بار نشان می‌دهیم. کاربر در ورود بعدی باید آن را عوض کند.",
                AppConstants.AppNameFa,
                MessageBoxButton.OK,
                MessageBoxImage.Information);
        }

        void OnToggleUser(object sender, RoutedEventArgs e)
        {
            var u = UsersGrid.SelectedItem as UserSummary;
            if (u == null)
                return;
            if (u.Username == "admin" && u.IsActive)
            {
                MessageBox.Show("admin را غیرفعال نکنید.");
                return;
            }
            SessionContext.Users.SetActive(u.Id, !u.IsActive);
            UsersGrid.ItemsSource = SessionContext.Users.List();
        }

        void OnBackup(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.SystemBackup))
            {
                BackupStatusText.Text = "شما اجازهٔ ساخت پشتیبان را ندارید.";
                return;
            }
            if (BackupPassBox.Password != BackupPass2Box.Password)
            {
                BackupStatusText.Text = "رمز و تکرار آن یکی نیست";
                return;
            }
            if (SessionContext.Database == null)
            {
                BackupStatusText.Text = "اتصال پایگاه داده برقرار نیست";
                return;
            }
            SessionContext.Database.Checkpoint();
            var dlg = new SaveFileDialog
            {
                Filter = "پشتیبان قائم‌شهر|*.gazbak",
                FileName = "gaz_backup_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".gazbak"
            };
            if (dlg.ShowDialog() != true)
                return;

            BackupStatusText.Text = "در حال ساخت پشتیبان… لطفاً صبر کنید.";
            string err = null;
            try
            {
                Mouse.OverrideCursor = Cursors.Wait;
                err = BackupService.Create(SessionContext.Database, BackupPassBox.Password, dlg.FileName);
            }
            catch (OutOfMemoryException ex)
            {
                AppLog.Error("Backup UI OOM", ex);
                err = "حافظه کافی برای ساخت پشتیبان نیست. چند برنامه را ببندید و دوباره تلاش کنید.";
            }
            catch (Exception ex)
            {
                AppLog.Error("Backup UI failed", ex);
                err = "ساخت پشتیبان ناموفق بود: " + ex.Message;
            }
            finally
            {
                Mouse.OverrideCursor = null;
            }

            if (err == null && SessionContext.Current != null && SessionContext.Audit != null)
            {
                try
                {
                    SessionContext.Audit.Add(SessionContext.Current.User.Id, SessionContext.Current.User.Username,
                        "backup.create", "backup", dlg.FileName);
                }
                catch { }
            }
            BackupStatusText.Text = err ?? "پشتیبان کامل ذخیره شد (داده، تنظیمات، اسناد، عکس‌ها و کلیدها):\n" + dlg.FileName;
        }

        void OnRestore(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.SystemRestore) && !SessionContext.Can(PermissionCodes.SystemBackup))
            {
                BackupStatusText.Text = "شما اجازهٔ بازیابی را ندارید.";
                return;
            }
            if (string.IsNullOrEmpty(RestorePassBox.Password))
            {
                BackupStatusText.Text = "رمز را وارد کنید";
                return;
            }
            var dlg = new OpenFileDialog { Filter = "پشتیبان|*.gazbak;*.json|همه|*.*" };
            if (dlg.ShowDialog() != true)
                return;
            if (MessageBox.Show("دادهٔ فعلی با این پشتیبان جایگزین می‌شود. ادامه؟", AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Warning) != MessageBoxResult.Yes)
                return;

            SessionContext.Current = null;
            SessionContext.Unbind(true);

            string err;
            try
            {
                err = BackupService.Restore(dlg.FileName, RestorePassBox.Password);
            }
            catch (Exception ex)
            {
                err = "بازیابی ناموفق بود: " + ex.Message;
                AppLog.Error("Backup restore failed", ex);
            }

            if (err != null)
            {
                try
                {
                    SessionContext.Bind(AppDatabase.OpenOrCreate());
                }
                catch (Exception ex)
                {
                    BackupStatusText.Text = err + "\nبازگشایی پایگاه هم ناموفق بود: " + ex.Message;
                    return;
                }
                BackupStatusText.Text = err;
                return;
            }

            MessageBox.Show(
                "بازیابی با موفقیت انجام شد.\nبرنامه الان بسته می‌شود؛ دوباره باز کنید تا با دادهٔ پشتیبان وارد شوید.",
                AppConstants.AppNameFa,
                MessageBoxButton.OK,
                MessageBoxImage.Information);
            Application.Current.Shutdown();
        }

        void OnWipeAll(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.SystemBackup) && !SessionContext.Can(PermissionCodes.SystemRestore))
            {
                BackupStatusText.Text = "شما اجازهٔ پاک‌سازی داده را ندارید.";
                return;
            }

            var dlg = new WipeDataWindow { Owner = Window.GetWindow(this) };
            if (dlg.ShowDialog() != true)
            {
                BackupStatusText.Text = "پاک‌سازی لغو شد.";
                return;
            }

            MessageBox.Show(
                "همه داده‌ها پاک شد.\nبرنامه بسته می‌شود. با ورود بعدی، حساب پیش‌فرض admin ساخته می‌شود.",
                AppConstants.AppNameFa,
                MessageBoxButton.OK,
                MessageBoxImage.Information);
            Application.Current.Shutdown();
        }
    }
}
