using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Threading;
using Microsoft.Win32;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Pages
{
    public partial class DocumentsPage : Page
    {
        List<Employee> _people = new List<Employee>();
        readonly Dictionary<string, HashSet<string>> _groupMembers =
            new Dictionary<string, HashSet<string>>(StringComparer.Ordinal);
        readonly HashSet<string> _selectedIds = new HashSet<string>(StringComparer.Ordinal);
        List<DocEmployeeRow> _rows = new List<DocEmployeeRow>();
        bool _suppressSelectEvents;
        readonly DispatcherTimer _filterDebounce = new DispatcherTimer { Interval = TimeSpan.FromMilliseconds(220) };
        int _filterGen;

        public DocumentsPage()
        {
            InitializeComponent();
            BuildEmploymentTypeChecks();
            _filterDebounce.Tick += (s, e) =>
            {
                _filterDebounce.Stop();
                ApplyFilter();
            };
            SearchBox.TextChanged += (s, e) => ScheduleFilter();
            Loaded += (s, e) => Reload();
        }

        void ScheduleFilter()
        {
            _filterDebounce.Stop();
            _filterDebounce.Start();
        }

        void BuildEmploymentTypeChecks()
        {
            EmploymentTypeHost.Children.Clear();
            foreach (var opt in ReportFilterDefs.EmploymentTypes)
            {
                var cb = new CheckBox
                {
                    Content = opt,
                    Style = TryFindResource("FilterCheck") as Style,
                    Margin = new Thickness(0, 0, 14, 6)
                };
                cb.Checked += OnFilterChanged;
                cb.Unchecked += OnFilterChanged;
                EmploymentTypeHost.Children.Add(cb);
            }
        }

        void ReloadGroupsUi()
        {
            GroupsHost.Children.Clear();
            _groupMembers.Clear();
            var groups = SessionContext.Groups != null
                ? SessionContext.Groups.List(null, null) ?? new List<EmployeeGroup>()
                : new List<EmployeeGroup>();
            if (groups.Count == 0)
            {
                GroupsHost.Children.Add(new TextBlock
                {
                    Text = "گروهی تعریف نشده است.",
                    Style = TryFindResource("MutedText") as Style
                });
                return;
            }
            foreach (var g in groups)
            {
                var ids = SessionContext.Groups.MemberIds(g.Id) ?? new List<string>();
                _groupMembers[g.Id] = new HashSet<string>(ids, StringComparer.Ordinal);
                var label = (g.Name ?? "بدون نام").Trim();
                if (g.Status == "archived")
                    label += " (بایگانی)";
                var cb = new CheckBox
                {
                    Content = label,
                    Tag = g.Id,
                    Style = TryFindResource("FilterCheck") as Style,
                    Margin = new Thickness(0, 0, 14, 6),
                    ToolTip = string.IsNullOrWhiteSpace(g.Description) ? label : g.Description
                };
                cb.Checked += OnFilterChanged;
                cb.Unchecked += OnFilterChanged;
                GroupsHost.Children.Add(cb);
            }
        }

        void Reload()
        {
            ReloadGroupsUi();
            _people = SessionContext.Employees.Search(new ParsedQuery(), null, 5000, false)
                ?? new List<Employee>();
            DocumentRepository.AttachTo(_people, SessionContext.Documents, false);
            ApplyFilter();
        }

        void OnFilterChanged(object sender, RoutedEventArgs e)
        {
            if (!IsLoaded)
                return;
            ScheduleFilter();
        }

        void OnCategoryChanged(object sender, RoutedEventArgs e)
        {
            if (!IsLoaded)
                return;
            UpdateCategoryColumns();
            ScheduleFilter();
        }

        void UpdateCategoryColumns()
        {
            BirthColumn.Visibility = CatBirthBox.IsChecked == true ? Visibility.Visible : Visibility.Collapsed;
            NationalColumn.Visibility = CatNationalBox.IsChecked == true ? Visibility.Visible : Visibility.Collapsed;
            OtherColumn.Visibility = CatOtherBox.IsChecked == true ? Visibility.Visible : Visibility.Collapsed;
        }

        HashSet<string> SelectedCategories()
        {
            var set = new HashSet<string>(StringComparer.Ordinal);
            if (CatBirthBox.IsChecked == true)
                set.Add(DocumentKinds.Birth);
            if (CatNationalBox.IsChecked == true)
                set.Add(DocumentKinds.National);
            if (CatOtherBox.IsChecked == true)
                set.Add(DocumentKinds.Other);
            return set;
        }

        ReportEmployeeFilter BuildPeopleFilter()
        {
            var f = ReportEmployeeFilter.CreateDefault();
            f.SearchText = SearchBox.Text ?? "";

            var statuses = new List<string>();
            if (StatusActiveBox.IsChecked == true)
                statuses.Add("فعال");
            if (StatusInactiveBox.IsChecked == true)
                statuses.Add("غیرفعال");
            f.Statuses = statuses.Count == 0
                ? new List<string>()
                : statuses;

            var personTypes = new List<string>();
            if (PersonEmployeeBox.IsChecked == true)
                personTypes.Add("کارمند");
            if (PersonWorkerBox.IsChecked == true)
                personTypes.Add("کارگر");
            f.PersonTypes = personTypes;

            var employment = new List<string>();
            foreach (CheckBox cb in EmploymentTypeHost.Children.OfType<CheckBox>())
            {
                if (cb.IsChecked == true && cb.Content != null)
                    employment.Add(cb.Content.ToString());
            }
            f.EmploymentTypes = employment;
            return f;
        }

        HashSet<string> SelectedGroupMemberUnion()
        {
            var selected = GroupsHost.Children.OfType<CheckBox>()
                .Where(c => c.IsChecked == true && c.Tag is string)
                .Select(c => (string)c.Tag)
                .ToList();
            if (selected.Count == 0)
                return null;

            var union = new HashSet<string>(StringComparer.Ordinal);
            foreach (var gid in selected)
            {
                HashSet<string> members;
                if (_groupMembers.TryGetValue(gid, out members))
                {
                    foreach (var id in members)
                        union.Add(id);
                }
            }
            return union;
        }

        void ApplyFilter()
        {
            UpdateCategoryColumns();
            var gen = ++_filterGen;
            var cats = SelectedCategories();
            List<Employee> people;
            if (cats.Count == 0
                || (StatusActiveBox.IsChecked != true && StatusInactiveBox.IsChecked != true))
            {
                people = new List<Employee>();
            }
            else
            {
                people = BuildPeopleFilter().Apply(_people);
                var groupMembers = SelectedGroupMemberUnion();
                if (groupMembers != null)
                    people = people.Where(p => groupMembers.Contains(p.Id)).ToList();
            }

            // بدون رمزگشایی تصویر — فقط متادیتا؛ تصویر هنگام نمایش ردیف (lazy) لود می‌شود
            var rows = new List<DocEmployeeRow>();
            foreach (var p in people)
            {
                var docs = (p.Documents ?? new List<EmployeeDocument>())
                    .Where(d => cats.Contains(DocumentKinds.Normalize(d.Category)))
                    .ToList();
                if (docs.Count == 0)
                    continue;

                rows.Add(new DocEmployeeRow
                {
                    EmployeeId = p.Id,
                    EmployeeName = p.FullName,
                    NationalId = p.NationalId,
                    StatusFa = p.StatusFa,
                    IsSelected = _selectedIds.Contains(p.Id),
                    ExportDocs = docs,
                    BirthThumbs = BuildThumbs(docs, DocumentKinds.Birth),
                    NationalThumbs = BuildThumbs(docs, DocumentKinds.National),
                    OtherThumbs = BuildThumbs(docs, DocumentKinds.Other)
                });
            }

            if (gen != _filterGen)
                return;

            _rows = rows;
            _suppressSelectEvents = true;
            Grid.ItemsSource = _rows;
            _suppressSelectEvents = false;

            CountText.Text = "نمایش " + PersianDate.DigitsFa(_rows.Count.ToString())
                + " کارمند دارای مدرک در فیلتر فعلی";
            RefreshSelectCount();
        }

        static List<DocThumbItem> BuildThumbs(IEnumerable<EmployeeDocument> docs, string kind)
        {
            var list = new List<DocThumbItem>();
            foreach (var d in docs.Where(x => DocumentKinds.Normalize(x.Category) == kind))
                list.Add(DocThumbItem.FromDocument(d));
            return list;
        }

        void OnThumbLoaded(object sender, RoutedEventArgs e)
        {
            var btn = sender as Button;
            var thumb = btn != null ? btn.DataContext as DocThumbItem : null;
            if (thumb == null || thumb.Image != null || thumb.LoadStarted)
                return;
            if (thumb.Document == null || !DocumentKinds.IsImage(thumb.Document))
                return;
            thumb.LoadStarted = true;
            var doc = thumb.Document;
            Task.Run(() =>
            {
                byte[] bytes = null;
                try
                {
                    if (doc.PreviewBytes != null && doc.PreviewBytes.Length > 0)
                        bytes = doc.PreviewBytes;
                    else if (SessionContext.Documents != null)
                    {
                        bytes = SessionContext.Documents.ReadIfImage(doc);
                        doc.PreviewBytes = bytes;
                    }
                }
                catch
                {
                    bytes = null;
                }
                var jpeg = bytes;
                Dispatcher.BeginInvoke(new Action(() =>
                {
                    if (jpeg == null || jpeg.Length == 0)
                        return;
                    try { thumb.Image = PhotoImages.FromJpeg(jpeg, 72); }
                    catch { }
                }), DispatcherPriority.Background);
            });
        }

        void RefreshSelectCount()
        {
            var n = _rows.Count(r => r.IsSelected);
            SelectCountText.Text = "انتخاب‌شده برای ZIP: " + PersianDate.DigitsFa(n.ToString());
        }

        void OnRowCheckChanged(object sender, RoutedEventArgs e)
        {
            if (_suppressSelectEvents)
                return;
            var cb = sender as CheckBox;
            var row = cb != null ? cb.DataContext as DocEmployeeRow : null;
            if (row == null || string.IsNullOrEmpty(row.EmployeeId))
                return;
            if (row.IsSelected)
                _selectedIds.Add(row.EmployeeId);
            else
                _selectedIds.Remove(row.EmployeeId);
            RefreshSelectCount();
        }

        void OnSelectAll(object sender, RoutedEventArgs e)
        {
            _suppressSelectEvents = true;
            foreach (var row in _rows)
            {
                row.IsSelected = true;
                if (!string.IsNullOrEmpty(row.EmployeeId))
                    _selectedIds.Add(row.EmployeeId);
            }
            _suppressSelectEvents = false;
            RefreshSelectCount();
        }

        void OnClearSelection(object sender, RoutedEventArgs e)
        {
            _suppressSelectEvents = true;
            foreach (var row in _rows)
                row.IsSelected = false;
            _selectedIds.Clear();
            _suppressSelectEvents = false;
            RefreshSelectCount();
        }

        void OnThumbClick(object sender, RoutedEventArgs e)
        {
            var btn = sender as Button;
            var thumb = btn != null ? (btn.Tag as DocThumbItem ?? btn.DataContext as DocThumbItem) : null;
            if (thumb == null || thumb.Document == null)
                return;
            OpenDocument(thumb.Document);
        }

        void OpenDocument(EmployeeDocument doc)
        {
            try
            {
                var path = SessionContext.Documents.OpenToTemp(doc);
                Process.Start(new ProcessStartInfo { FileName = path, UseShellExecute = true });
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, AppConstants.AppNameFa);
            }
        }

        void OnExportZip(object sender, RoutedEventArgs e)
        {
            if (!SessionContext.Can(PermissionCodes.DocumentsDownload)
                && !SessionContext.Can(PermissionCodes.DocumentsView))
            {
                MessageBox.Show("دسترسی خروجی ندارید.", AppConstants.AppNameFa);
                return;
            }

            var cats = SelectedCategories();
            if (cats.Count == 0)
            {
                MessageBox.Show("حداقل یک دسته‌بندی را انتخاب کنید.", AppConstants.AppNameFa);
                return;
            }

            var selectedRows = _rows.Where(r => r.IsSelected).ToList();
            if (selectedRows.Count == 0)
            {
                MessageBox.Show("حداقل یک کارمند را برای خروجی انتخاب کنید.", AppConstants.AppNameFa);
                return;
            }

            var docs = new List<EmployeeDocument>();
            foreach (var row in selectedRows)
            {
                if (row.ExportDocs == null)
                    continue;
                foreach (var d in row.ExportDocs)
                {
                    if (cats.Contains(DocumentKinds.Normalize(d.Category)))
                        docs.Add(d);
                }
            }
            if (docs.Count == 0)
            {
                MessageBox.Show("برای کارمندان انتخاب‌شده سندی در دسته‌های فعلی نیست.", AppConstants.AppNameFa);
                return;
            }

            var dlg = new SaveFileDialog
            {
                Filter = "فایل ZIP|*.zip",
                FileName = "مدارک_پرسنل_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".zip"
            };
            if (dlg.ShowDialog() != true)
                return;

            int files, emps;
            var err = SessionContext.Documents.ExportZip(docs, dlg.FileName, out files, out emps);
            if (err != null)
            {
                MessageBox.Show(err, AppConstants.AppNameFa);
                return;
            }
            if (SessionContext.Audit != null && SessionContext.Current != null)
            {
                try
                {
                    SessionContext.Audit.Add(
                        SessionContext.Current.User.Id, SessionContext.Current.User.Username,
                        "document.export_zip", "document", dlg.FileName);
                }
                catch { }
            }
            MessageBox.Show(
                "خروجی ZIP آماده شد.\n"
                + PersianDate.DigitsFa(emps.ToString()) + " کارمند  ·  "
                + PersianDate.DigitsFa(files.ToString()) + " فایل\n"
                + dlg.FileName,
                AppConstants.AppNameFa);
        }

        sealed class DocEmployeeRow : INotifyPropertyChanged
        {
            bool _isSelected;

            public string EmployeeId { get; set; }
            public string EmployeeName { get; set; }
            public string NationalId { get; set; }
            public string StatusFa { get; set; }
            public List<EmployeeDocument> ExportDocs { get; set; }
            public List<DocThumbItem> BirthThumbs { get; set; }
            public List<DocThumbItem> NationalThumbs { get; set; }
            public List<DocThumbItem> OtherThumbs { get; set; }

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

        sealed class DocThumbItem : INotifyPropertyChanged
        {
            ImageSource _image;

            public EmployeeDocument Document { get; set; }
            public string Placeholder { get; set; }
            public string Tooltip { get; set; }
            public bool LoadStarted { get; set; }

            public ImageSource Image
            {
                get { return _image; }
                set
                {
                    if (ReferenceEquals(_image, value))
                        return;
                    _image = value;
                    Raise("Image");
                    Raise("ImageVisibility");
                    Raise("PlaceholderVisibility");
                }
            }

            public Visibility ImageVisibility
            {
                get { return Image != null ? Visibility.Visible : Visibility.Collapsed; }
            }

            public Visibility PlaceholderVisibility
            {
                get { return Image == null ? Visibility.Visible : Visibility.Collapsed; }
            }

            public event PropertyChangedEventHandler PropertyChanged;

            void Raise(string name)
            {
                var h = PropertyChanged;
                if (h != null)
                    h(this, new PropertyChangedEventArgs(name));
            }

            public static DocThumbItem FromDocument(EmployeeDocument d)
            {
                var title = string.IsNullOrWhiteSpace(d.Title) ? d.FileName : d.Title;
                var tip = (title ?? "سند") + " — " + DocumentKinds.Normalize(d.Category);
                if (!string.IsNullOrWhiteSpace(d.FileName) && !string.Equals(title, d.FileName, StringComparison.OrdinalIgnoreCase))
                    tip += "\n" + d.FileName;

                var ext = (Path.GetExtension(d.FileName ?? "") ?? "").TrimStart('.').ToUpperInvariant();
                if (string.IsNullOrEmpty(ext))
                    ext = DocumentKinds.IsImage(d) ? "IMG" : "فایل";

                ImageSource eager = null;
                if (d.PreviewBytes != null && d.PreviewBytes.Length > 0)
                {
                    try { eager = PhotoImages.FromJpeg(d.PreviewBytes, 72); }
                    catch { eager = null; }
                }

                return new DocThumbItem
                {
                    Document = d,
                    Image = eager,
                    LoadStarted = eager != null,
                    Placeholder = ext.Length > 5 ? ext.Substring(0, 5) : ext,
                    Tooltip = tip
                };
            }
        }
    }
}
