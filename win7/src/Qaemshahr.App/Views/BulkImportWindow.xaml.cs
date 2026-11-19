using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Microsoft.Win32;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Views
{
    public partial class BulkImportWindow : Window
    {
        readonly Dictionary<string, CheckBox> _fieldBoxes = new Dictionary<string, CheckBox>(StringComparer.Ordinal);
        readonly List<DraftCard> _cards = new List<DraftCard>();
        readonly HashSet<string> _selectedFields = new HashSet<string>(StringComparer.Ordinal);
        bool _suppressFieldEvents;

        public BulkImportWindow()
        {
            InitializeComponent();
            foreach (var key in BulkImportCatalog.DefaultSelectedFieldKeys())
                _selectedFields.Add(key);
            BuildFieldPickers(SectionsHost, true);
            StatusText.Text = "فیلدها را انتخاب کنید، سپس ادامه دهید.";
        }

        void BuildFieldPickers(Panel host, bool expandIdentity)
        {
            host.Children.Clear();
            _fieldBoxes.Clear();
            _suppressFieldEvents = true;
            try
            {
                foreach (var section in BulkImportCatalog.AllSections())
                {
                    var body = new StackPanel { Margin = new Thickness(4, 4, 4, 2) };
                    var sectionKey = section.Key;
                    var sectionTools = new WrapPanel { Margin = new Thickness(0, 0, 0, 8) };
                    var allBtn = new Button
                    {
                        Content = "همهٔ این بخش",
                        Style = TryFindResource("ChipButton") as Style,
                        MinHeight = 28,
                        Padding = new Thickness(10, 2, 10, 2),
                        Margin = new Thickness(0, 0, 8, 0),
                        Tag = sectionKey
                    };
                    var noneBtn = new Button
                    {
                        Content = "هیچ‌کدام",
                        Style = TryFindResource("ChipButton") as Style,
                        MinHeight = 28,
                        Padding = new Thickness(10, 2, 10, 2),
                        Tag = sectionKey
                    };
                    allBtn.Click += OnSectionSelectAll;
                    noneBtn.Click += OnSectionSelectNone;
                    sectionTools.Children.Add(allBtn);
                    sectionTools.Children.Add(noneBtn);
                    body.Children.Add(sectionTools);
                    foreach (var field in section.Fields)
                    {
                        var box = new CheckBox
                        {
                            Content = field.TitleFa + (field.Required ? " *" : ""),
                            IsChecked = _selectedFields.Contains(field.Key) || field.Required,
                            IsEnabled = !field.Required,
                            Margin = new Thickness(0, 0, 0, 8),
                            Tag = field.Key
                        };
                        box.Checked += OnFieldCheckChanged;
                        box.Unchecked += OnFieldCheckChanged;
                        _fieldBoxes[field.Key] = box;
                        body.Children.Add(box);
                    }

                    var expander = new Expander
                    {
                        Header = section.TitleFa + (section.AlwaysOn ? " (الزامی)" : ""),
                        IsExpanded = expandIdentity
                            || section.Key == BulkImportCatalog.Identity
                            || section.Key == BulkImportCatalog.Org,
                        Margin = new Thickness(0, 0, 0, 10),
                        Content = body
                    };
                    host.Children.Add(expander);
                }
            }
            finally
            {
                _suppressFieldEvents = false;
            }
            SyncSelectedFromBoxes();
        }

        void OnSelectAllFields(object sender, RoutedEventArgs e)
        {
            foreach (var kv in _fieldBoxes)
                kv.Value.IsChecked = true;
            SyncSelectedFromBoxes();
        }

        void OnSelectRequiredFields(object sender, RoutedEventArgs e)
        {
            var req = new HashSet<string>(BulkImportCatalog.RequiredFieldKeys(), StringComparer.Ordinal);
            foreach (var kv in _fieldBoxes)
                kv.Value.IsChecked = req.Contains(kv.Key) || !kv.Value.IsEnabled;
            SyncSelectedFromBoxes();
        }

        void OnSelectDefaultFields(object sender, RoutedEventArgs e)
        {
            var def = new HashSet<string>(BulkImportCatalog.DefaultSelectedFieldKeys(), StringComparer.Ordinal);
            foreach (var kv in _fieldBoxes)
                kv.Value.IsChecked = def.Contains(kv.Key) || !kv.Value.IsEnabled;
            SyncSelectedFromBoxes();
        }

        void OnSectionSelectAll(object sender, RoutedEventArgs e)
        {
            var sectionKey = (sender as FrameworkElement)?.Tag as string;
            SetSectionChecks(sectionKey, true);
        }

        void OnSectionSelectNone(object sender, RoutedEventArgs e)
        {
            var sectionKey = (sender as FrameworkElement)?.Tag as string;
            SetSectionChecks(sectionKey, false);
        }

        void SetSectionChecks(string sectionKey, bool on)
        {
            if (string.IsNullOrEmpty(sectionKey))
                return;
            foreach (var s in BulkImportCatalog.AllSections())
            {
                if (s.Key != sectionKey)
                    continue;
                foreach (var f in s.Fields)
                {
                    CheckBox box;
                    if (!_fieldBoxes.TryGetValue(f.Key, out box) || !box.IsEnabled)
                        continue;
                    box.IsChecked = on;
                }
            }
            SyncSelectedFromBoxes();
        }

        void OnFieldCheckChanged(object sender, RoutedEventArgs e)
        {
            if (_suppressFieldEvents)
                return;
            SyncSelectedFromBoxes();
            if (EntryPanel.Visibility == Visibility.Visible)
            {
                SyncAllCardsFromUi();
                RebuildAllCards();
                UpdateSummary();
                UpdateStatus();
            }
        }

        void SyncSelectedFromBoxes()
        {
            _selectedFields.Clear();
            foreach (var kv in _fieldBoxes)
            {
                if (kv.Value.IsChecked == true)
                    _selectedFields.Add(kv.Key);
            }
            _selectedFields.Add("firstName");
            _selectedFields.Add("lastName");
            _selectedFields.Add("nationalId");
        }

        List<BulkImportCatalog.Field> ActiveFields()
        {
            return BulkImportCatalog.FieldsForKeys(_selectedFields);
        }

        void OnFieldsExpanded(object sender, RoutedEventArgs e)
        {
            if (EntryFieldsHost.Children.Count == 0)
                BuildFieldPickers(EntryFieldsHost, false);
        }

        void OnNext(object sender, RoutedEventArgs e)
        {
            SyncSelectedFromBoxes();
            SettingsPanel.Visibility = Visibility.Collapsed;
            EntryPanel.Visibility = Visibility.Visible;
            NextButton.Visibility = Visibility.Collapsed;
            BackButton.Visibility = Visibility.Visible;
            CommitButton.Visibility = Visibility.Visible;
            EntryFieldsHost.Children.Clear();
            UpdateSummary();
            if (_cards.Count == 0)
                AddCard(new Employee { EmploymentStatus = "active" });
            else
                RebuildAllCards();
            UpdateStatus();
        }

        void OnBack(object sender, RoutedEventArgs e)
        {
            SyncAllCardsFromUi();
            EntryPanel.Visibility = Visibility.Collapsed;
            SettingsPanel.Visibility = Visibility.Visible;
            NextButton.Visibility = Visibility.Visible;
            BackButton.Visibility = Visibility.Collapsed;
            CommitButton.Visibility = Visibility.Collapsed;
            BuildFieldPickers(SectionsHost, true);
            StatusText.Text = "فیلدها را تنظیم کنید.";
        }

        void UpdateSummary()
        {
            var fields = ActiveFields();
            SectionsSummary.Text = fields.Count + " فیلد فعال — قالب اکسل و کارت‌ها بر همین اساس به‌روز می‌شوند.";
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        void OnTemplate(object sender, RoutedEventArgs e)
        {
            SyncSelectedFromBoxes();
            var dlg = new SaveFileDialog { Filter = "Excel|*.xlsx", FileName = "qaemshahr_bulk_template.xlsx" };
            if (dlg.ShowDialog() != true)
                return;
            ExcelService.WriteTemplateForFields(dlg.FileName, ActiveFields());
            Process.Start(new ProcessStartInfo { FileName = dlg.FileName, UseShellExecute = true });
            StatusText.Text = "قالب با فیلدهای انتخاب‌شده ذخیره شد.";
        }

        void OnPick(object sender, RoutedEventArgs e)
        {
            var dlg = new OpenFileDialog { Filter = "Excel|*.xlsx;*.xls" };
            if (dlg.ShowDialog() != true)
                return;
            var parsed = ExcelService.ReadEmployees(dlg.FileName);
            SyncAllCardsFromUi();
            _cards.Clear();
            CardsHost.Children.Clear();
            foreach (var t in parsed)
            {
                if (t.Item1 == null)
                    continue;
                if (string.IsNullOrWhiteSpace(t.Item1.FirstName)
                    && string.IsNullOrWhiteSpace(t.Item1.LastName)
                    && string.IsNullOrWhiteSpace(t.Item1.NationalId))
                    continue;
                AddCard(t.Item1);
            }
            if (_cards.Count == 0)
                AddCard(new Employee { EmploymentStatus = "active" });
            UpdateStatus();
        }

        void OnAddCard(object sender, RoutedEventArgs e)
        {
            SyncAllCardsFromUi();
            AddCard(new Employee { EmploymentStatus = "active" });
            UpdateStatus();
        }

        void OnClearCards(object sender, RoutedEventArgs e)
        {
            if (_cards.Count == 0)
                return;
            if (MessageBox.Show("همه کارت‌ها پاک شوند؟", AppConstants.AppNameFa,
                    MessageBoxButton.YesNo, MessageBoxImage.Question) != MessageBoxResult.Yes)
                return;
            _cards.Clear();
            CardsHost.Children.Clear();
            AddCard(new Employee { EmploymentStatus = "active" });
            UpdateStatus();
        }

        void RebuildAllCards()
        {
            var snapshot = new List<DraftSnapshot>();
            foreach (var c in _cards)
            {
                ApplyUiToEmployee(c);
                snapshot.Add(new DraftSnapshot
                {
                    Employee = c.Employee ?? new Employee { EmploymentStatus = "active" },
                    PhotoJpeg = c.PhotoJpeg,
                    ClearExistingPhoto = c.ClearExistingPhoto,
                    PendingDocs = c.PendingDocs == null
                        ? new List<PendingDoc>()
                        : new List<PendingDoc>(c.PendingDocs)
                });
            }
            _cards.Clear();
            CardsHost.Children.Clear();
            foreach (var snap in snapshot)
                AddCard(snap.Employee, snap.PhotoJpeg, snap.ClearExistingPhoto, snap.PendingDocs);
        }

        void AddCard(Employee seed)
        {
            AddCard(seed, null, false, null);
        }

        void AddCard(Employee seed, byte[] photoJpeg, bool clearPhoto, List<PendingDoc> pendingDocs)
        {
            var emp = seed ?? new Employee { EmploymentStatus = "active" };
            if (string.IsNullOrWhiteSpace(emp.EmploymentStatus))
                emp.EmploymentStatus = "active";

            var fields = ActiveFields();
            var fieldMap = new Dictionary<string, FrameworkElement>(StringComparer.Ordinal);
            var body = new StackPanel { Margin = new Thickness(0) };

            var title = new TextBlock
            {
                FontWeight = FontWeights.SemiBold,
                FontSize = 15,
                Margin = new Thickness(0, 0, 0, 4),
                TextWrapping = TextWrapping.Wrap,
                Foreground = TryFindResource("PrimaryBrush") as Brush ?? Brushes.SteelBlue
            };
            var meta = new TextBlock
            {
                Style = TryFindResource("MutedText") as Style,
                FontSize = 12,
                Margin = new Thickness(0, 0, 0, 0),
                TextWrapping = TextWrapping.Wrap
            };

            var photo = new System.Windows.Controls.Image
            {
                Width = 56,
                Height = 72,
                Stretch = Stretch.UniformToFill,
                HorizontalAlignment = HorizontalAlignment.Center
            };
            var photoPh = new TextBlock
            {
                Text = "۴×۳",
                FontSize = 11,
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Center,
                Foreground = TryFindResource("MutedBrush") as Brush ?? Brushes.Gray
            };
            var photoFrame = new Border
            {
                Width = 60,
                Height = 76,
                BorderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.LightGray,
                BorderThickness = new Thickness(1),
                CornerRadius = new CornerRadius(6),
                Background = TryFindResource("SoftPanelBrush") as Brush ?? Brushes.WhiteSmoke,
                Margin = new Thickness(0, 0, 12, 0),
                Child = new Grid()
            };
            var photoGrid = (Grid)photoFrame.Child;
            photoGrid.Children.Add(photoPh);
            photoGrid.Children.Add(photo);

            var pickPhoto = new Button
            {
                Content = "تصویر",
                Style = TryFindResource("GhostButton") as Style,
                Padding = new Thickness(8, 4, 8, 4),
                MinHeight = 28,
                Margin = new Thickness(0, 0, 8, 0)
            };
            var clearPhotoBtn = new Button
            {
                Content = "حذف تصویر",
                Style = TryFindResource("GhostButton") as Style,
                Padding = new Thickness(8, 4, 8, 4),
                MinHeight = 28,
                Margin = new Thickness(0, 0, 8, 0)
            };
            var remove = new Button
            {
                Content = "حذف کارت",
                Style = TryFindResource("DangerButton") as Style,
                Padding = new Thickness(10, 4, 10, 4),
                MinHeight = 28
            };

            var titles = new StackPanel { Margin = new Thickness(0, 0, 0, 8) };
            titles.Children.Add(title);
            titles.Children.Add(meta);

            var headerRow = new DockPanel { LastChildFill = true, Margin = new Thickness(0, 0, 0, 10) };
            DockPanel.SetDock(photoFrame, Dock.Right);
            headerRow.Children.Add(photoFrame);
            headerRow.Children.Add(titles);
            body.Children.Add(headerRow);

            var actions = new WrapPanel { Margin = new Thickness(0, 0, 0, 12) };
            actions.Children.Add(pickPhoto);
            actions.Children.Add(clearPhotoBtn);
            actions.Children.Add(remove);
            body.Children.Add(actions);

            var errText = new TextBlock
            {
                Foreground = TryFindResource("DangerBrush") as Brush ?? Brushes.DarkRed,
                FontSize = 12,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 0, 0, 8),
                Visibility = Visibility.Collapsed
            };
            body.Children.Add(errText);

            string lastSection = null;
            foreach (var f in fields)
            {
                var sectionKey = SectionOf(f.Key);
                if (sectionKey != lastSection)
                {
                    lastSection = sectionKey;
                    body.Children.Add(new TextBlock
                    {
                        Text = SectionTitle(sectionKey),
                        FontWeight = FontWeights.SemiBold,
                        FontSize = 12,
                        Margin = new Thickness(0, 8, 0, 6),
                        Foreground = TryFindResource("MutedBrush") as Brush ?? Brushes.Gray
                    });
                }

                var row = new StackPanel { Margin = new Thickness(0, 0, 0, 10) };
                row.Children.Add(new TextBlock
                {
                    Text = f.TitleFa + (f.Required ? " *" : ""),
                    Margin = new Thickness(0, 0, 0, 4)
                });

                FrameworkElement editor;
                var current = ExcelService.GetField(emp, f.Key);
                var enumOpts = BulkImportCatalog.EnumOptions(f.Key);
                if (enumOpts != null)
                {
                    var combo = new ComboBox
                    {
                        IsEditable = true,
                        IsTextSearchEnabled = true,
                        StaysOpenOnEdit = true,
                        Text = current
                    };
                    foreach (var opt in enumOpts)
                        combo.Items.Add(opt);
                    editor = combo;
                }
                else if (FieldSuggestionKeys.IsSupported(f.Key))
                {
                    var combo = SuggestCombo.Create(f.Key, current);
                    editor = combo;
                }
                else
                {
                    var box = new TextBox
                    {
                        Text = current,
                        AcceptsReturn = f.Multiline,
                        MinHeight = f.Multiline ? 56 : 36,
                        TextWrapping = f.Multiline ? TextWrapping.Wrap : TextWrapping.NoWrap,
                        VerticalScrollBarVisibility = f.Multiline ? ScrollBarVisibility.Auto : ScrollBarVisibility.Disabled
                    };
                    if (f.Ltr)
                        box.Style = TryFindResource("LtrBox") as Style;
                    if (f.Key == "nationalId" || f.Key == "primaryPhone" || f.Key == "employeeNumber")
                        UiInput.UseEnglish(box);
                    editor = box;
                }
                fieldMap[f.Key] = editor;
                row.Children.Add(editor);
                body.Children.Add(row);
            }

            // اسناد مثل پرونده کارمند جدید
            body.Children.Add(new TextBlock
            {
                Text = "اسناد و مدارک",
                FontWeight = FontWeights.SemiBold,
                FontSize = 12,
                Margin = new Thickness(0, 10, 0, 6),
                Foreground = TryFindResource("MutedBrush") as Brush ?? Brushes.Gray
            });
            var otherTitle = new TextBox
            {
                Margin = new Thickness(0, 0, 0, 8),
                ToolTip = "عنوان ذخیره برای سایر اسناد"
            };
            body.Children.Add(new TextBlock
            {
                Text = "عنوان سایر اسناد (دستی)",
                Margin = new Thickness(0, 0, 0, 4),
                FontSize = 11
            });
            body.Children.Add(otherTitle);
            var docsList = new TextBlock
            {
                Style = TryFindResource("MutedText") as Style,
                FontSize = 11,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 0, 0, 8),
                Text = "سندی اضافه نشده است."
            };
            body.Children.Add(docsList);
            var docsActions = new WrapPanel { Margin = new Thickness(0, 0, 0, 4) };
            var addBirth = new Button { Content = "شناسنامه", Style = TryFindResource("ChipButton") as Style, MinHeight = 28, Margin = new Thickness(0, 0, 6, 4), Tag = DocumentKinds.Birth };
            var addNational = new Button { Content = "کارت ملی", Style = TryFindResource("ChipButton") as Style, MinHeight = 28, Margin = new Thickness(0, 0, 6, 4), Tag = DocumentKinds.National };
            var addOther = new Button { Content = "سایر سند", Style = TryFindResource("ChipButton") as Style, MinHeight = 28, Margin = new Thickness(0, 0, 6, 4), Tag = DocumentKinds.Other };
            var clearDocs = new Button { Content = "پاک اسناد", Style = TryFindResource("GhostButton") as Style, MinHeight = 28, Padding = new Thickness(8, 4, 8, 4) };
            docsActions.Children.Add(addBirth);
            docsActions.Children.Add(addNational);
            docsActions.Children.Add(addOther);
            docsActions.Children.Add(clearDocs);
            body.Children.Add(docsActions);

            var surface = TryFindResource("SurfaceBrush") as Brush ?? Brushes.White;
            var card = new Border
            {
                Width = 380,
                Padding = new Thickness(14, 14, 14, 14),
                Margin = new Thickness(0, 0, 16, 16),
                Background = surface,
                BorderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.LightGray,
                BorderThickness = new Thickness(1),
                CornerRadius = new CornerRadius(12),
                Child = body
            };

            var draft = new DraftCard
            {
                Root = card,
                Employee = emp,
                Fields = fieldMap,
                ErrorText = errText,
                TitleText = title,
                MetaText = meta,
                Body = body,
                PhotoImage = photo,
                PhotoPlaceholder = photoPh,
                PhotoJpeg = photoJpeg,
                ClearExistingPhoto = clearPhoto,
                PendingDocs = pendingDocs ?? new List<PendingDoc>(),
                OtherDocTitleBox = otherTitle,
                DocsSummary = docsList
            };
            if (draft.PhotoJpeg != null)
                ShowCardPhoto(draft, PhotoImages.FromJpeg(draft.PhotoJpeg, 120));
            else if (!string.IsNullOrWhiteSpace(emp.PhotoPath))
                ShowCardPhoto(draft, PhotoImages.FromEmployee(emp.PhotoPath, 120));
            RefreshDocsSummary(draft);

            foreach (var kv in fieldMap)
                WireFieldChanged(kv.Value, () => RefreshCardShape(draft));

            pickPhoto.Click += (s, e) =>
            {
                var dlg = new OpenFileDialog
                {
                    Filter = "تصویر|*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tif;*.tiff|همه فایل‌ها|*.*",
                    Title = "انتخاب عکس کارمند"
                };
                if (dlg.ShowDialog() != true)
                    return;
                try
                {
                    draft.PhotoJpeg = EmployeePhotoStore.FitFromFile(dlg.FileName);
                    draft.ClearExistingPhoto = false;
                    ShowCardPhoto(draft, PhotoImages.FromJpeg(draft.PhotoJpeg, 120));
                }
                catch (Exception ex)
                {
                    MessageBox.Show("خواندن عکس ناموفق بود.\n" + ex.Message, AppConstants.AppNameFa);
                }
            };
            clearPhotoBtn.Click += (s, e) =>
            {
                draft.PhotoJpeg = null;
                draft.ClearExistingPhoto = true;
                ShowCardPhoto(draft, null);
            };
            RoutedEventHandler addDoc = (s, e) =>
            {
                var kind = (s as FrameworkElement)?.Tag as string ?? DocumentKinds.Other;
                AddPendingDoc(draft, kind);
            };
            addBirth.Click += addDoc;
            addNational.Click += addDoc;
            addOther.Click += addDoc;
            clearDocs.Click += (s, e) =>
            {
                draft.PendingDocs.Clear();
                RefreshDocsSummary(draft);
            };
            remove.Click += (s, e) =>
            {
                if (_cards.Count <= 1)
                {
                    MessageBox.Show("حداقل یک کارت لازم است.", AppConstants.AppNameFa);
                    return;
                }
                _cards.Remove(draft);
                CardsHost.Children.Remove(card);
                UpdateStatus();
            };

            _cards.Add(draft);
            CardsHost.Children.Add(card);
            RefreshCardShape(draft);
        }

        void AddPendingDoc(DraftCard draft, string kind)
        {
            if (draft == null)
                return;
            ApplyUiToEmployee(draft);
            var emp = draft.Employee;
            string title;
            if (kind == DocumentKinds.Other)
            {
                title = (draft.OtherDocTitleBox != null ? draft.OtherDocTitleBox.Text : null) ?? "";
                title = title.Trim();
                if (title.Length == 0)
                {
                    MessageBox.Show("برای سایر اسناد ابتدا عنوان ذخیره را وارد کنید.", AppConstants.AppNameFa);
                    return;
                }
            }
            else
            {
                var name = (emp.FullName ?? "").Trim();
                var nid = (emp.NationalId ?? "").Trim();
                if (name.Length == 0 || nid.Length == 0)
                {
                    MessageBox.Show("ابتدا نام، نام خانوادگی و کد ملی را وارد کنید.", AppConstants.AppNameFa);
                    return;
                }
                title = kind + " " + name + " " + nid;
            }
            var dlg = new OpenFileDialog
            {
                Multiselect = false,
                Filter = "تصویر یا فایل|*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.pdf;*.*|همه|*.*"
            };
            if (dlg.ShowDialog() != true)
                return;
            var ext = System.IO.Path.GetExtension(dlg.FileName) ?? "";
            if (string.IsNullOrEmpty(ext))
                ext = ".jpg";
            var fileName = title + ext;
            draft.PendingDocs.Add(new PendingDoc
            {
                Kind = kind,
                SourcePath = dlg.FileName,
                Title = title,
                FileName = fileName
            });
            RefreshDocsSummary(draft);
        }

        static void RefreshDocsSummary(DraftCard draft)
        {
            if (draft == null || draft.DocsSummary == null)
                return;
            if (draft.PendingDocs == null || draft.PendingDocs.Count == 0)
            {
                draft.DocsSummary.Text = "سندی اضافه نشده است.";
                return;
            }
            var bits = new List<string>();
            foreach (var d in draft.PendingDocs)
                bits.Add(d.Kind + ": " + d.Title);
            draft.DocsSummary.Text = draft.PendingDocs.Count + " سند — " + string.Join(" · ", bits);
        }

        static void ShowCardPhoto(DraftCard card, System.Windows.Media.Imaging.BitmapImage image)
        {
            if (card == null || card.PhotoImage == null)
                return;
            card.PhotoImage.Source = image;
            if (card.PhotoPlaceholder != null)
                card.PhotoPlaceholder.Visibility = image == null ? Visibility.Visible : Visibility.Collapsed;
        }

        static string SectionOf(string fieldKey)
        {
            foreach (var s in BulkImportCatalog.AllSections())
            {
                foreach (var f in s.Fields)
                {
                    if (f.Key == fieldKey)
                        return s.Key;
                }
            }
            return BulkImportCatalog.Identity;
        }

        static string SectionTitle(string key)
        {
            foreach (var s in BulkImportCatalog.AllSections())
            {
                if (s.Key == key)
                    return s.TitleFa;
            }
            return key;
        }

        void RefreshCardShape(DraftCard card)
        {
            if (card == null)
                return;
            ApplyUiToEmployee(card);
            var emp = card.Employee;
            var name = (emp.FullName ?? "").Trim();
            card.TitleText.Text = string.IsNullOrEmpty(name) ? "کارمند جدید" : name;

            var bits = new List<string>();
            if (!string.IsNullOrWhiteSpace(emp.NationalId))
                bits.Add(emp.NationalId);
            if (!string.IsNullOrWhiteSpace(emp.CurrentPosition))
                bits.Add(emp.CurrentPosition);
            if (!string.IsNullOrWhiteSpace(emp.PrimaryPhone))
                bits.Add(emp.PrimaryPhone);
            if (!string.IsNullOrWhiteSpace(emp.EducationLevel))
                bits.Add(emp.EducationLevel);
            card.MetaText.Text = bits.Count == 0 ? "اطلاعات را پر کنید" : string.Join(" · ", bits);

            var filled = 0;
            foreach (var kv in card.Fields)
            {
                if (!string.IsNullOrWhiteSpace(ReadFieldText(kv.Value)))
                    filled++;
            }
            var total = Math.Max(1, card.Fields.Count);
            card.Root.MinHeight = 160;
            card.Root.Width = 380;
            if (filled == 0)
            {
                card.Root.BorderBrush = TryFindResource("BorderBrush") as Brush ?? Brushes.LightGray;
                card.Root.BorderThickness = new Thickness(1);
            }
            else if (filled >= total)
            {
                card.Root.BorderBrush = TryFindResource("PrimaryBrush") as Brush ?? Brushes.SteelBlue;
                card.Root.BorderThickness = new Thickness(2);
            }
            else
            {
                card.Root.BorderBrush = TryFindResource("PrimaryLightBrush") as Brush ?? Brushes.SteelBlue;
                card.Root.BorderThickness = new Thickness(1.5);
            }
        }

        void SyncAllCardsFromUi()
        {
            foreach (var c in _cards)
                ApplyUiToEmployee(c);
        }

        static void ApplyUiToEmployee(DraftCard card)
        {
            if (card == null)
                return;
            var emp = card.Employee ?? new Employee();
            emp.EmploymentStatus = string.IsNullOrWhiteSpace(emp.EmploymentStatus) ? "active" : emp.EmploymentStatus;
            foreach (var kv in card.Fields)
                ExcelService.SetField(emp, kv.Key, kv.Value == null ? "" : ReadFieldText(kv.Value));
            card.Employee = emp;
        }

        static string ReadFieldText(FrameworkElement el)
        {
            var tb = el as TextBox;
            if (tb != null)
                return tb.Text ?? "";
            var cb = el as ComboBox;
            if (cb != null)
                return cb.Text ?? "";
            return "";
        }

        static void WireFieldChanged(FrameworkElement el, Action onChanged)
        {
            if (el == null || onChanged == null)
                return;
            var tb = el as TextBox;
            if (tb != null)
            {
                tb.TextChanged += (s, e) => onChanged();
                return;
            }
            var cb = el as ComboBox;
            if (cb != null)
            {
                cb.AddHandler(TextBox.TextChangedEvent, new TextChangedEventHandler((s, e) => onChanged()), true);
                cb.SelectionChanged += (s, e) => onChanged();
                cb.LostKeyboardFocus += (s, e) => onChanged();
            }
        }

        void UpdateStatus()
        {
            var ok = 0;
            foreach (var c in _cards)
            {
                ApplyUiToEmployee(c);
                if (ExcelService.ValidateEmployee(c.Employee).Count == 0)
                    ok++;
            }
            StatusText.Text = ok + " کارت معتبر از " + _cards.Count + "  |  " + ActiveFields().Count + " فیلد";
        }

        void OnCommit(object sender, RoutedEventArgs e)
        {
            SyncSelectedFromBoxes();
            SyncAllCardsFromUi();
            var ready = new List<Employee>();
            var bad = 0;
            foreach (var c in _cards)
            {
                var errs = ExcelService.ValidateEmployee(c.Employee);
                if (errs.Count > 0)
                {
                    bad++;
                    c.ErrorText.Text = string.Join("، ", errs);
                    c.ErrorText.Visibility = Visibility.Visible;
                    c.Root.BorderBrush = TryFindResource("DangerBrush") as Brush ?? Brushes.DarkRed;
                    c.Root.BorderThickness = new Thickness(2);
                }
                else
                {
                    c.ErrorText.Visibility = Visibility.Collapsed;
                    ready.Add(c.Employee);
                }
            }
            if (ready.Count == 0)
            {
                MessageBox.Show("هیچ ردیف معتبری برای ثبت نیست.", AppConstants.AppNameFa);
                UpdateStatus();
                return;
            }
            if (bad > 0)
            {
                var ask = MessageBox.Show(
                    bad + " کارت نامعتبر است و ثبت نمی‌شود. " + ready.Count + " نفر ثبت شوند؟",
                    AppConstants.AppNameFa, MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (ask != MessageBoxResult.Yes)
                {
                    UpdateStatus();
                    return;
                }
            }

            var n = 0;
            foreach (var c in _cards)
            {
                if (!ready.Contains(c.Employee))
                    continue;
                var emp = c.Employee;
                if (SessionContext.Employees.Save(emp, true) == null)
                {
                    n++;
                    if (SessionContext.FieldSuggestions != null)
                        SessionContext.FieldSuggestions.RememberFromEmployee(emp);
                    if (c.PhotoJpeg != null)
                    {
                        var relative = EmployeePhotoStore.SaveJpeg(emp.Id, c.PhotoJpeg);
                        SessionContext.Employees.SetPhotoPath(emp.Id, relative);
                    }
                    if (c.PendingDocs != null && SessionContext.Documents != null)
                    {
                        foreach (var doc in c.PendingDocs)
                        {
                            var err = SessionContext.Documents.Store(
                                emp.Id, doc.Title, doc.Kind, doc.SourcePath,
                                SessionContext.Current.User.Username, doc.FileName);
                            if (err != null)
                                StatusText.Text = "هشدار سند: " + err;
                        }
                    }
                }
            }
            SessionContext.Audit.Add(SessionContext.Current.User.Id, SessionContext.Current.User.Username,
                "employee_import", "employee", n + " rows");
            MessageBox.Show(n + " کارمند ثبت شد.", AppConstants.AppNameFa);
            DialogResult = true;
            Close();
        }

        sealed class DraftSnapshot
        {
            public Employee Employee;
            public byte[] PhotoJpeg;
            public bool ClearExistingPhoto;
            public List<PendingDoc> PendingDocs;
        }

        sealed class PendingDoc
        {
            public string Kind;
            public string SourcePath;
            public string Title;
            public string FileName;
        }

        sealed class DraftCard
        {
            public Border Root;
            public Employee Employee;
            public Dictionary<string, FrameworkElement> Fields;
            public TextBlock ErrorText;
            public TextBlock TitleText;
            public TextBlock MetaText;
            public StackPanel Body;
            public System.Windows.Controls.Image PhotoImage;
            public TextBlock PhotoPlaceholder;
            public byte[] PhotoJpeg;
            public bool ClearExistingPhoto;
            public List<PendingDoc> PendingDocs;
            public TextBox OtherDocTitleBox;
            public TextBlock DocsSummary;
        }
    }
}
