using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using Microsoft.Win32;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Views
{
    public partial class GroupEditWindow : Window
    {
        static readonly HashSet<string> FixedPurposes = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "mission", "training", "committee", "project", "other"
        };

        readonly string _id;
        readonly List<MemberRow> _rows = new List<MemberRow>();
        readonly HashSet<string> _selectedIds = new HashSet<string>(StringComparer.Ordinal);
        bool _suppressSelectEvents;
        bool _ready;
        byte[] _photoJpeg;
        bool _clearPhoto;
        string _existingPhotoPath;

        public GroupEditWindow(string id, IList<string> preselect)
        {
            InitializeComponent();
            _id = id;
            SearchBox.TextChanged += (s, e) => ApplyMemberFilter();

            var people = SessionContext.Employees.Search(new ParsedQuery(), null, 5000, false)
                ?? new List<Employee>();
            foreach (var p in people)
            {
                _rows.Add(new MemberRow
                {
                    Id = p.Id,
                    FirstName = p.FirstName,
                    LastName = p.LastName,
                    FullName = p.FullName,
                    NationalId = p.NationalId,
                    EmployeeNumber = p.EmployeeNumber,
                    CurrentPosition = p.CurrentPosition,
                    EmploymentType = p.EmploymentType,
                    PersonTypeFa = p.PersonTypeFa,
                    StatusFa = p.StatusFa,
                    EmploymentStatus = p.EmploymentStatus,
                    PersonType = p.PersonType
                });
            }

            SuggestCombo.Attach(PurposeOtherBox, FieldSuggestionKeys.GroupPurpose);
            SuggestCombo.Reload(PurposeOtherBox, FieldSuggestionKeys.GroupPurpose, null);
            UpdatePurposeOtherVisibility();

            if (!string.IsNullOrEmpty(id))
            {
                var g = SessionContext.Groups.Get(id);
                if (g != null)
                {
                    NameBox.Text = g.Name;
                    DescBox.Text = g.Description;
                    ApplyPurpose(g.PurposeType);
                    SelectCombo(StatusBox, g.Status);
                    StartDateBox.Value = PersianDate.FromEpochMs(g.StartsAt);
                    EndDateBox.Value = PersianDate.FromEpochMs(g.EndsAt);
                    _existingPhotoPath = g.PhotoPath;
                    if (!string.IsNullOrWhiteSpace(g.PhotoPath))
                        ShowPhoto(PhotoImages.FromEmployee(g.PhotoPath, 160));
                    if (g.MemberIds != null)
                    {
                        foreach (var mid in g.MemberIds)
                            _selectedIds.Add(mid);
                    }
                }
            }
            else if (preselect != null)
            {
                foreach (var mid in preselect)
                    _selectedIds.Add(mid);
            }

            foreach (var row in _rows)
                row.IsSelected = _selectedIds.Contains(row.Id);

            _ready = true;
            ApplyMemberFilter();
        }

        void ApplyPurpose(string purposeType)
        {
            var raw = (purposeType ?? "").Trim();
            if (string.IsNullOrEmpty(raw) || string.Equals(raw, "other", StringComparison.OrdinalIgnoreCase))
            {
                SelectCombo(PurposeBox, "other");
                SuggestCombo.Reload(PurposeOtherBox, FieldSuggestionKeys.GroupPurpose, null);
                PurposeOtherBox.Text = "";
                UpdatePurposeOtherVisibility();
                return;
            }
            if (FixedPurposes.Contains(raw) && !string.Equals(raw, "other", StringComparison.OrdinalIgnoreCase))
            {
                SelectCombo(PurposeBox, raw);
                PurposeOtherBox.Text = "";
                UpdatePurposeOtherVisibility();
                return;
            }
            SelectCombo(PurposeBox, "other");
            SuggestCombo.Reload(PurposeOtherBox, FieldSuggestionKeys.GroupPurpose, raw);
            PurposeOtherBox.Text = raw;
            UpdatePurposeOtherVisibility();
        }

        void OnPurposeChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!_ready)
                return;
            UpdatePurposeOtherVisibility();
        }

        void UpdatePurposeOtherVisibility()
        {
            var item = PurposeBox.SelectedItem as ComboBoxItem;
            var isOther = item != null && (item.Tag as string) == "other";
            PurposeOtherPanel.Visibility = isOther ? Visibility.Visible : Visibility.Collapsed;
            if (!isOther)
                PurposeOtherBox.Text = "";
        }

        string ReadPurposeType()
        {
            var item = PurposeBox.SelectedItem as ComboBoxItem;
            var tag = item == null ? null : item.Tag as string;
            if (string.IsNullOrEmpty(tag))
                tag = "other";
            if (tag != "other")
                return tag;
            var custom = SuggestCombo.TextOf(PurposeOtherBox);
            if (string.IsNullOrWhiteSpace(custom))
                return "other";
            return custom.Trim();
        }

        void SelectCombo(ComboBox box, string tag)
        {
            foreach (ComboBoxItem item in box.Items)
            {
                if ((item.Tag as string) == tag)
                {
                    box.SelectedItem = item;
                    return;
                }
            }
        }

        static string TagOf(ComboBox box, string fallback)
        {
            var item = box.SelectedItem as ComboBoxItem;
            var t = item == null ? null : item.Tag as string;
            return string.IsNullOrEmpty(t) ? fallback : t;
        }

        void OnMemberFilterChanged(object sender, RoutedEventArgs e)
        {
            if (!_ready)
                return;
            ApplyMemberFilter();
        }

        void ApplyMemberFilter()
        {
            var f = ReportEmployeeFilter.CreateDefault();
            f.SearchText = SearchBox.Text ?? "";

            var statuses = new List<string>();
            if (StatusActiveBox.IsChecked == true)
                statuses.Add("فعال");
            if (StatusInactiveBox.IsChecked == true)
                statuses.Add("غیرفعال");
            f.Statuses = statuses;

            var personTypes = new List<string>();
            if (PersonEmployeeBox.IsChecked == true)
                personTypes.Add("کارمند");
            if (PersonWorkerBox.IsChecked == true)
                personTypes.Add("کارگر");
            f.PersonTypes = personTypes;

            List<MemberRow> visible;
            if (statuses.Count == 0)
            {
                visible = new List<MemberRow>();
            }
            else
            {
                var matched = new HashSet<string>(
                    f.Apply(_rows.Select(ToEmployee)).Select(e => e.Id),
                    StringComparer.Ordinal);
                visible = _rows.Where(r => matched.Contains(r.Id)).ToList();
            }

            _suppressSelectEvents = true;
            MembersGrid.ItemsSource = null;
            MembersGrid.ItemsSource = visible;
            _suppressSelectEvents = false;

            MemberCountText.Text = "نمایش " + PersianDate.DigitsFa(visible.Count.ToString())
                + " از " + PersianDate.DigitsFa(_rows.Count.ToString()) + " پرسنل";
            RefreshSelectedCount();
        }

        static Employee ToEmployee(MemberRow r)
        {
            return new Employee
            {
                Id = r.Id,
                FirstName = r.FirstName,
                LastName = r.LastName,
                NationalId = r.NationalId,
                EmployeeNumber = r.EmployeeNumber,
                CurrentPosition = r.CurrentPosition,
                EmploymentType = r.EmploymentType,
                PersonType = r.PersonType,
                EmploymentStatus = r.EmploymentStatus
            };
        }

        void RefreshSelectedCount()
        {
            SelectedCountText.Text = "انتخاب‌شده برای گروه: "
                + PersianDate.DigitsFa(_selectedIds.Count.ToString());
        }

        void OnRowCheckChanged(object sender, RoutedEventArgs e)
        {
            if (_suppressSelectEvents)
                return;
            var cb = sender as CheckBox;
            var row = cb != null ? cb.DataContext as MemberRow : null;
            if (row == null || string.IsNullOrEmpty(row.Id))
                return;
            if (row.IsSelected)
                _selectedIds.Add(row.Id);
            else
                _selectedIds.Remove(row.Id);
            RefreshSelectedCount();
        }

        void OnSelectFiltered(object sender, RoutedEventArgs e)
        {
            var visible = MembersGrid.ItemsSource as IEnumerable<MemberRow>;
            if (visible == null)
                return;
            foreach (var row in visible)
            {
                row.IsSelected = true;
                _selectedIds.Add(row.Id);
            }
            RefreshGridBinding();
        }

        void OnClearSelection(object sender, RoutedEventArgs e)
        {
            foreach (var row in _rows)
                row.IsSelected = false;
            _selectedIds.Clear();
            RefreshGridBinding();
        }

        void RefreshGridBinding()
        {
            var current = (MembersGrid.ItemsSource as IList<MemberRow>) ?? new List<MemberRow>();
            _suppressSelectEvents = true;
            MembersGrid.ItemsSource = null;
            MembersGrid.ItemsSource = current;
            _suppressSelectEvents = false;
            RefreshSelectedCount();
        }

        void OnSave(object sender, RoutedEventArgs e)
        {
            var purpose = ReadPurposeType();
            if (purpose != "mission" && purpose != "training" && purpose != "committee"
                && purpose != "project" && purpose != "other"
                && SessionContext.FieldSuggestions != null)
            {
                SessionContext.FieldSuggestions.Remember(FieldSuggestionKeys.GroupPurpose, purpose);
            }

            var g = new EmployeeGroup
            {
                Id = _id,
                Name = NameBox.Text,
                Description = string.IsNullOrWhiteSpace(DescBox.Text) ? null : DescBox.Text.Trim(),
                PurposeType = purpose,
                Status = TagOf(StatusBox, "active"),
                StartsAt = PersianDate.ToEpochMs(StartDateBox.Value),
                EndsAt = PersianDate.ToEpochMs(EndDateBox.Value),
                PhotoPath = _clearPhoto ? null : _existingPhotoPath
            };
            var ids = _selectedIds.ToList();
            var err = SessionContext.Groups.Save(g, ids, SessionContext.Current.User.Id);
            if (err != null)
            {
                MessageBox.Show(err, AppConstants.AppNameFa);
                return;
            }
            if (_photoJpeg != null)
            {
                var relative = EmployeePhotoStore.SaveGroupJpeg(g.Id, _photoJpeg);
                SessionContext.Groups.SetPhotoPath(g.Id, relative);
            }
            else if (_clearPhoto)
            {
                if (!string.IsNullOrWhiteSpace(_existingPhotoPath))
                    EmployeePhotoStore.Delete(_existingPhotoPath);
                SessionContext.Groups.SetPhotoPath(g.Id, null);
            }
            DialogResult = true;
            Close();
        }

        void OnPickPhoto(object sender, RoutedEventArgs e)
        {
            var dlg = new OpenFileDialog
            {
                Filter = "تصویر|*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tif;*.tiff|همه فایل‌ها|*.*",
                Title = "عکس پروفایل گروه"
            };
            if (dlg.ShowDialog() != true)
                return;
            try
            {
                _photoJpeg = EmployeePhotoStore.FitFromFile(dlg.FileName);
                _clearPhoto = false;
                ShowPhoto(PhotoImages.FromJpeg(_photoJpeg, 160));
            }
            catch (Exception ex)
            {
                MessageBox.Show("خواندن عکس ناموفق بود.\n" + ex.Message, AppConstants.AppNameFa);
            }
        }

        void OnClearPhoto(object sender, RoutedEventArgs e)
        {
            _photoJpeg = null;
            _clearPhoto = true;
            ShowPhoto(null);
        }

        void ShowPhoto(System.Windows.Media.Imaging.BitmapImage image)
        {
            PhotoImage.Source = image;
            PhotoPlaceholder.Visibility = image == null ? Visibility.Visible : Visibility.Collapsed;
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        sealed class MemberRow : INotifyPropertyChanged
        {
            bool _isSelected;

            public string Id { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string FullName { get; set; }
            public string NationalId { get; set; }
            public string EmployeeNumber { get; set; }
            public string CurrentPosition { get; set; }
            public string EmploymentType { get; set; }
            public string PersonTypeFa { get; set; }
            public string StatusFa { get; set; }
            public string EmploymentStatus { get; set; }
            public string PersonType { get; set; }

            public bool IsSelected
            {
                get { return _isSelected; }
                set
                {
                    if (_isSelected == value)
                        return;
                    _isSelected = value;
                    var h = PropertyChanged;
                    if (h != null)
                        h(this, new PropertyChangedEventArgs("IsSelected"));
                }
            }

            public event PropertyChangedEventHandler PropertyChanged;
        }
    }
}
