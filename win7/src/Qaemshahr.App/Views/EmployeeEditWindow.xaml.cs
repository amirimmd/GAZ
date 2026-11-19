using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using Microsoft.Win32;
using Qaemshahr.App.Services;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;
using Qaemshahr.Data;

namespace Qaemshahr.App.Views
{
    public partial class EmployeeEditWindow : Window
    {
        string _id;
        bool _isNew;
        byte[] _photoJpeg;
        bool _photoCleared;
        string _savedPhotoPath;
        bool _choiceSync;
        bool _didSave;
        bool _docSaveNameDirty;
        bool _docSaveNameSync;
        readonly List<PendingDoc> _pendingDocs = new List<PendingDoc>();
        int _pendingSeq;

        public EmployeeEditWindow(string id)
        {
            InitializeComponent();
            WireEnglishImeFields();
            WireDocSaveNameFields();
            RetirementDateBox.ValueChanged += OnRetirementDateChanged;
            _isNew = string.IsNullOrEmpty(id) || id == "new";
            _id = _isNew ? null : id;
            Title = _isNew ? "کارمند جدید" : "ویرایش کارمند";
            DocsTab.IsEnabled = true;
            if (_isNew)
                DocsHint.Text = "فایل‌ها تا زمان ذخیره پرونده نگه داشته می‌شوند و همراه ثبت کارمند ذخیره می‌گردند.";
            if (!_isNew)
                Load();
            else
            {
                ShowPhoto(null);
                ReloadDocs();
                ReloadJobGroupSuggestions(null);
                WireSuggestionFields();
                ReloadAllSuggestions();
                UpdateEmploymentExtraPanels();
                UpdateStatusPanels();
            }
            SyncDocSaveName(true);
            var canSave = SessionContext.Can(_isNew ? PermissionCodes.EmployeesCreate : PermissionCodes.EmployeesEdit);
            SaveButton.IsEnabled = canSave;
            UpdateNextButton();
        }

        void WireEnglishImeFields()
        {
            UiInput.UseEnglish(
                NationalIdBox, EmpNoBox, SubNoBox, ChildrenBox,
                PhoneBox, Phone2Box, Phone3Box, EmailBox, PostalBox,
                PositionBaseBox, PersonalBaseBox, InsNoBox,
                TelegramBox, WhatsappBox, InstagramBox, LinkedinBox);
        }

        void UpdateNextButton()
        {
            if (NextButton == null || MainTabs == null)
                return;
            var last = MainTabs.SelectedIndex >= MainTabs.Items.Count - 1;
            NextButton.Content = last ? "بستن" : "بعدی";
        }

        void OnTabChanged(object sender, SelectionChangedEventArgs e)
        {
            UpdateNextButton();
        }

        void OnNext(object sender, RoutedEventArgs e)
        {
            if (MainTabs.SelectedIndex < MainTabs.Items.Count - 1)
            {
                MainTabs.SelectedIndex++;
                return;
            }
            DialogResult = _didSave;
            Close();
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            if (DialogResult == null && _didSave)
                DialogResult = true;
            base.OnClosing(e);
        }

        void Load()
        {
            var e = SessionContext.Employees.GetById(_id);
            if (e == null)
                return;
            FirstNameBox.Text = e.FirstName;
            LastNameBox.Text = e.LastName;
            FatherBox.Text = e.FatherName;
            NationalIdBox.Text = e.NationalId;
            IdBookletBox.Text = e.IdBookletNumber;
            BirthDateBox.Value = e.BirthDate;
            WireSuggestionFields();
            SuggestCombo.Reload(BirthPlaceBox, FieldSuggestionKeys.BirthPlace, e.BirthPlace);
            SuggestCombo.Reload(VeteranBox, FieldSuggestionKeys.VeteranStatus, e.VeteranStatus);
            SuggestCombo.Reload(ServiceCityBox, FieldSuggestionKeys.ServiceCity, e.ServiceCity);
            GenderBox.Text = HrLookups.NormalizeGender(e.Gender) ?? e.Gender;
            MaritalBox.Text = e.MaritalStatus;
            ChildrenBox.Text = e.ChildrenCount.ToString();
            BloodBox.Text = e.BloodGroup;
            SetFixedOrOther(MilitaryBox, MilitaryOtherBox, HrLookups.MilitaryFa(e.MilitaryStatus));
            DescBox.Text = e.PersonalDescription;
            EmpNoBox.Text = e.EmployeeNumber;
            SubNoBox.Text = e.SubscriptionNumber;
            SuggestCombo.Reload(PosBox, FieldSuggestionKeys.CurrentPosition, e.CurrentPosition);
            SuggestCombo.Reload(PrevPosBox, FieldSuggestionKeys.PreviousPosition, e.PreviousPosition);
            SuggestCombo.Reload(DesiredPosBox, FieldSuggestionKeys.DesiredPosition, e.DesiredPosition);
            Iban1Box.Text = IranianIban.FormatDisplay(e.Iban1);
            Iban2Box.Text = IranianIban.FormatDisplay(e.Iban2);
            RefreshIbanBadge(Iban1Box.Text, Iban1Badge, Iban1BadgeText, Iban1BankLabel);
            RefreshIbanBadge(Iban2Box.Text, Iban2Badge, Iban2BadgeText, Iban2BankLabel);
            SetFixedOrOther(EmpTypeBox, EmpTypeOtherBox, HrLookups.NormalizeEmploymentType(e.EmploymentType) ?? e.EmploymentType);
            SelectPersonType(e.PersonType);
            ReloadJobGroupSuggestions(e.JobGroup);
            JobGroupBox.Text = e.JobGroup ?? string.Empty;
            PositionBaseBox.Text = e.PositionBase.HasValue ? e.PositionBase.Value.ToString(System.Globalization.CultureInfo.InvariantCulture) : string.Empty;
            PersonalBaseBox.Text = e.PersonalBase.HasValue ? e.PersonalBase.Value.ToString(System.Globalization.CultureInfo.InvariantCulture) : string.Empty;
            UpdateEmploymentExtraPanels();
            EmpDateBox.Value = e.EmploymentDate;
            RetirementDateBox.Value = e.RetirementDate;
            InactiveReasonBox.Text = e.InactiveReason ?? string.Empty;
            StatusBox.SelectedIndex = e.EmploymentStatus == "inactive" || PersianDate.IsOnOrBeforeToday(e.RetirementDate) ? 1 : 0;
            UpdateStatusPanels();
            PhoneBox.Text = e.PrimaryPhone;
            Phone2Box.Text = e.SecondaryPhone;
            Phone3Box.Text = e.EmergencyPhone;
            EmailBox.Text = e.Email;
            AddressBox.Text = e.HomeAddress;
            PostalBox.Text = e.PostalCode;
            TelegramBox.Text = e.Telegram;
            WhatsappBox.Text = e.Whatsapp;
            InstagramBox.Text = e.Instagram;
            LinkedinBox.Text = e.Linkedin;
            SuggestCombo.Reload(EduLevelBox, FieldSuggestionKeys.EducationLevel, e.EducationLevel);
            SuggestCombo.Reload(MajorBox, FieldSuggestionKeys.Major, e.Major);
            SuggestCombo.Reload(UniversityBox, FieldSuggestionKeys.University, e.University);
            SuggestCombo.Reload(SkillBox, FieldSuggestionKeys.SkillName, e.SkillName);
            SuggestCombo.Reload(SkillLevelBox, FieldSuggestionKeys.SkillLevel, e.SkillLevel);
            InsNoBox.Text = e.InsuranceNumber;
            SuggestCombo.Reload(InsTypeBox, FieldSuggestionKeys.InsuranceType, e.InsuranceType);
            _savedPhotoPath = e.PhotoPath;
            ShowPhoto(PhotoImages.FromEmployee(e.PhotoPath, 270));
            ReloadDocs();
            SyncDocSaveName(true);
        }

        void WireDocSaveNameFields()
        {
            FirstNameBox.TextChanged += OnIdentityForDocSaveName;
            LastNameBox.TextChanged += OnIdentityForDocSaveName;
            NationalIdBox.TextChanged += OnIdentityForDocSaveName;
        }

        void OnIdentityForDocSaveName(object sender, TextChangedEventArgs e)
        {
            SyncDocSaveName(false);
        }

        void OnDocSaveNameEdited(object sender, TextChangedEventArgs e)
        {
            if (_docSaveNameSync)
                return;
            _docSaveNameDirty = true;
        }

        void SyncDocSaveName(bool force)
        {
            // فیلد دستی فقط برای «سایر اسناد» است؛ پیشنهاد اولیه = نام کامل + کد ملی
            if (DocSaveNameBox == null)
                return;
            if (_docSaveNameDirty && !force)
                return;
            _docSaveNameSync = true;
            try
            {
                if (force || string.IsNullOrWhiteSpace(DocSaveNameBox.Text))
                    DocSaveNameBox.Text = BuildPersonLabel();
                if (force)
                    _docSaveNameDirty = false;
            }
            finally
            {
                _docSaveNameSync = false;
            }
        }

        string BuildPersonLabel()
        {
            var full = ((FirstNameBox.Text ?? "").Trim() + " " + (LastNameBox.Text ?? "").Trim()).Trim();
            var nid = PersianDate.DigitsEn((NationalIdBox.Text ?? "").Trim());
            if (full.Length == 0 && nid.Length == 0)
                return string.Empty;
            if (full.Length == 0)
                return nid;
            if (nid.Length == 0)
                return full;
            return full + " " + nid;
        }

        string BuildDefaultDocSaveName()
        {
            return BuildPersonLabel();
        }

        string ResolveDocTitle(string kind)
        {
            var person = BuildPersonLabel();
            if (kind == DocumentKinds.Birth)
            {
                if (string.IsNullOrWhiteSpace(person))
                    return null;
                return DocumentKinds.Birth + " " + person;
            }
            if (kind == DocumentKinds.National)
            {
                if (string.IsNullOrWhiteSpace(person))
                    return null;
                return DocumentKinds.National + " " + person;
            }
            var manual = ReadDocSaveName();
            return string.IsNullOrWhiteSpace(manual) ? null : manual;
        }

        string ReadDocSaveName()
        {
            var name = DocSaveNameBox == null ? null : DocSaveNameBox.Text;
            if (string.IsNullOrWhiteSpace(name))
                return null;
            return name.Trim();
        }

        void ReloadDocs()
        {
            if (!_isNew && _id != null)
            {
                var person = new Employee { Documents = SessionContext.Documents.List(_id) };
                BirthDocsBox.ItemsSource = DocumentKinds.Of(person, DocumentKinds.Birth);
                NationalDocsBox.ItemsSource = DocumentKinds.Of(person, DocumentKinds.National);
                OtherDocsBox.ItemsSource = DocumentKinds.Of(person, DocumentKinds.Other);
                return;
            }
            BirthDocsBox.ItemsSource = PendingOf(DocumentKinds.Birth);
            NationalDocsBox.ItemsSource = PendingOf(DocumentKinds.National);
            OtherDocsBox.ItemsSource = PendingOf(DocumentKinds.Other);
        }

        List<EmployeeDocument> PendingOf(string kind)
        {
            var list = new List<EmployeeDocument>();
            foreach (var p in _pendingDocs)
            {
                if (p.Kind == kind)
                    list.Add(p.View);
            }
            return list;
        }

        Employee Build()
        {
            int children;
            int.TryParse(ChildrenBox.Text, out children);
            var statusItem = StatusBox.SelectedItem as ComboBoxItem;
            var status = statusItem != null && (statusItem.Tag as string) == "inactive" ? "inactive" : "active";
            return new Employee
            {
                Id = _id,
                FirstName = FirstNameBox.Text,
                LastName = LastNameBox.Text,
                FatherName = NullIfEmpty(FatherBox.Text),
                NationalId = NationalIdBox.Text,
                IdBookletNumber = NullIfEmpty(IdBookletBox.Text),
                BirthDate = NullIfEmpty(BirthDateBox.Value),
                BirthPlace = NullIfEmpty(SuggestCombo.TextOf(BirthPlaceBox)),
                ServiceCity = NullIfEmpty(SuggestCombo.TextOf(ServiceCityBox)),
                VeteranStatus = NullIfEmpty(SuggestCombo.TextOf(VeteranBox)),
                Iban1 = IranianIban.Normalize(Iban1Box.Text),
                Iban2 = IranianIban.Normalize(Iban2Box.Text),
                Gender = HrLookups.NormalizeGender(ComboText(GenderBox)),
                MaritalStatus = NullIfEmpty(ComboText(MaritalBox)),
                ChildrenCount = children,
                BloodGroup = NullIfEmpty(ComboText(BloodBox)),
                MilitaryStatus = ReadFixedOrOther(MilitaryBox, MilitaryOtherBox),
                PersonalDescription = NullIfEmpty(DescBox.Text),
                EmployeeNumber = NullIfEmpty(EmpNoBox.Text),
                SubscriptionNumber = NullIfEmpty(SubNoBox.Text),
                CurrentPosition = NullIfEmpty(SuggestCombo.TextOf(PosBox)),
                PreviousPosition = NullIfEmpty(SuggestCombo.TextOf(PrevPosBox)),
                DesiredPosition = NullIfEmpty(SuggestCombo.TextOf(DesiredPosBox)),
                EmploymentType = HrLookups.NormalizeEmploymentType(ReadFixedOrOther(EmpTypeBox, EmpTypeOtherBox)),
                PersonType = ReadPersonType(),
                JobGroup = NullIfEmpty(JobGroupBox.Text),
                PositionBase = ParseBase(PositionBaseBox.Text),
                PersonalBase = ParseBase(PersonalBaseBox.Text),
                EmploymentDate = NullIfEmpty(EmpDateBox.Value),
                EmploymentStatus = status,
                RetirementDate = NullIfEmpty(RetirementDateBox.Value),
                InactiveReason = NullIfEmpty(InactiveReasonBox.Text),
                PrimaryPhone = NullIfEmpty(PhoneBox.Text),
                SecondaryPhone = NullIfEmpty(Phone2Box.Text),
                EmergencyPhone = NullIfEmpty(Phone3Box.Text),
                Email = NullIfEmpty(EmailBox.Text),
                HomeAddress = NullIfEmpty(AddressBox.Text),
                PostalCode = NullIfEmpty(PostalBox.Text),
                Telegram = NullIfEmpty(TelegramBox.Text),
                Whatsapp = NullIfEmpty(WhatsappBox.Text),
                Instagram = NullIfEmpty(InstagramBox.Text),
                Linkedin = NullIfEmpty(LinkedinBox.Text),
                EducationLevel = NullIfEmpty(SuggestCombo.TextOf(EduLevelBox)),
                Major = NullIfEmpty(SuggestCombo.TextOf(MajorBox)),
                University = NullIfEmpty(SuggestCombo.TextOf(UniversityBox)),
                SkillName = NullIfEmpty(SuggestCombo.TextOf(SkillBox)),
                SkillLevel = NullIfEmpty(SuggestCombo.TextOf(SkillLevelBox)),
                InsuranceNumber = NullIfEmpty(InsNoBox.Text),
                InsuranceType = NullIfEmpty(SuggestCombo.TextOf(InsTypeBox))
            };
        }

        static string ComboText(ComboBox box)
        {
            if (!string.IsNullOrWhiteSpace(box.Text))
                return box.Text.Trim();
            var item = box.SelectedItem as ComboBoxItem;
            return item == null ? null : (item.Content as string);
        }

        void SelectPersonType(string personType)
        {
            var tag = HrLookups.NormalizePersonType(personType);
            for (var i = 0; i < PersonTypeBox.Items.Count; i++)
            {
                var item = PersonTypeBox.Items[i] as ComboBoxItem;
                if (item != null && string.Equals(item.Tag as string, tag, StringComparison.OrdinalIgnoreCase))
                {
                    PersonTypeBox.SelectedIndex = i;
                    return;
                }
            }
            PersonTypeBox.SelectedIndex = 0;
        }

        string ReadPersonType()
        {
            var item = PersonTypeBox.SelectedItem as ComboBoxItem;
            return HrLookups.NormalizePersonType(item == null ? null : item.Tag as string);
        }

        void OnMilitaryChoice(object sender, SelectionChangedEventArgs e)
        {
            if (_choiceSync)
                return;
            ShowOther(MilitaryBox, MilitaryOtherBox);
        }

        void OnEmpTypeChoice(object sender, SelectionChangedEventArgs e)
        {
            if (_choiceSync)
                return;
            ShowOther(EmpTypeBox, EmpTypeOtherBox);
            UpdateEmploymentExtraPanels();
        }

        void UpdateEmploymentExtraPanels()
        {
            if (OfficialBasesPanel == null || ThirdPillarJobPanel == null)
                return;
            var type = HrLookups.NormalizeEmploymentType(ReadFixedOrOther(EmpTypeBox, EmpTypeOtherBox))
                ?? ReadFixedOrOther(EmpTypeBox, EmpTypeOtherBox);
            var official = HrLookups.IsOfficialEmployment(type);
            var third = HrLookups.IsThirdPillarEmployment(type);
            OfficialBasesPanel.Visibility = official ? Visibility.Visible : Visibility.Collapsed;
            ThirdPillarJobPanel.Visibility = third ? Visibility.Visible : Visibility.Collapsed;
            if (!_choiceSync)
            {
                if (!official)
                {
                    PositionBaseBox.Text = string.Empty;
                    PersonalBaseBox.Text = string.Empty;
                }
                if (!third)
                    JobGroupBox.Text = string.Empty;
            }
            if (third)
                ReloadJobGroupSuggestions(JobGroupBox.Text);
        }

        void WireSuggestionFields()
        {
            SuggestCombo.Attach(BirthPlaceBox, FieldSuggestionKeys.BirthPlace);
            SuggestCombo.Attach(ServiceCityBox, FieldSuggestionKeys.ServiceCity);
            SuggestCombo.Attach(VeteranBox, FieldSuggestionKeys.VeteranStatus);
            SuggestCombo.Attach(PosBox, FieldSuggestionKeys.CurrentPosition);
            SuggestCombo.Attach(PrevPosBox, FieldSuggestionKeys.PreviousPosition);
            SuggestCombo.Attach(DesiredPosBox, FieldSuggestionKeys.DesiredPosition);
            SuggestCombo.Attach(EduLevelBox, FieldSuggestionKeys.EducationLevel);
            SuggestCombo.Attach(MajorBox, FieldSuggestionKeys.Major);
            SuggestCombo.Attach(UniversityBox, FieldSuggestionKeys.University);
            SuggestCombo.Attach(SkillBox, FieldSuggestionKeys.SkillName);
            SuggestCombo.Attach(SkillLevelBox, FieldSuggestionKeys.SkillLevel);
            SuggestCombo.Attach(InsTypeBox, FieldSuggestionKeys.InsuranceType);
        }

        void ReloadAllSuggestions()
        {
            SuggestCombo.Reload(BirthPlaceBox, FieldSuggestionKeys.BirthPlace);
            SuggestCombo.Reload(ServiceCityBox, FieldSuggestionKeys.ServiceCity);
            SuggestCombo.Reload(VeteranBox, FieldSuggestionKeys.VeteranStatus);
            SuggestCombo.Reload(PosBox, FieldSuggestionKeys.CurrentPosition);
            SuggestCombo.Reload(PrevPosBox, FieldSuggestionKeys.PreviousPosition);
            SuggestCombo.Reload(DesiredPosBox, FieldSuggestionKeys.DesiredPosition);
            SuggestCombo.Reload(EduLevelBox, FieldSuggestionKeys.EducationLevel);
            SuggestCombo.Reload(MajorBox, FieldSuggestionKeys.Major);
            SuggestCombo.Reload(UniversityBox, FieldSuggestionKeys.University);
            SuggestCombo.Reload(SkillBox, FieldSuggestionKeys.SkillName);
            SuggestCombo.Reload(SkillLevelBox, FieldSuggestionKeys.SkillLevel);
            SuggestCombo.Reload(InsTypeBox, FieldSuggestionKeys.InsuranceType);
        }

        void OnIban1Changed(object sender, TextChangedEventArgs e)
        {
            RefreshIbanBadge(Iban1Box.Text, Iban1Badge, Iban1BadgeText, Iban1BankLabel);
        }

        void OnIban2Changed(object sender, TextChangedEventArgs e)
        {
            RefreshIbanBadge(Iban2Box.Text, Iban2Badge, Iban2BadgeText, Iban2BankLabel);
        }

        static void RefreshIbanBadge(string raw, Border badge, TextBlock badgeText, TextBlock label)
        {
            IranianIban.BankInfo bank;
            if (IranianIban.TryDetectBank(raw, out bank))
            {
                badge.Background = new System.Windows.Media.SolidColorBrush(
                    System.Windows.Media.Color.FromRgb(bank.R, bank.G, bank.B));
                badgeText.Text = bank.ShortFa ?? "بانک";
                label.Text = "بانک " + bank.NameFa;
                return;
            }
            badge.Background = new System.Windows.Media.SolidColorBrush(
                System.Windows.Media.Color.FromRgb(0x5A, 0x6A, 0x72));
            badgeText.Text = "شبا";
            var n = IranianIban.Normalize(raw);
            if (string.IsNullOrEmpty(n))
                label.Text = "بانک پس از وارد کردن شبا تشخیص داده می‌شود";
            else if (n.Length < 26)
                label.Text = "در حال ورود… (" + n.Length + "/۲۶)";
            else
                label.Text = "بانک شناسایی نشد — شبا را بررسی کنید";
        }

        void ReloadJobGroupSuggestions(string current)
        {
            if (JobGroupBox == null)
                return;
            var keep = (current ?? JobGroupBox.Text ?? string.Empty).Trim();
            var suggestions = HrLookups.MergeJobGroupSuggestions(
                SessionContext.Employees.ListDistinctJobGroups(), keep);
            JobGroupBox.Items.Clear();
            foreach (var g in suggestions)
                JobGroupBox.Items.Add(g);
            JobGroupBox.Text = keep;
        }

        static double? ParseBase(string raw)
        {
            if (string.IsNullOrWhiteSpace(raw))
                return null;
            double v;
            if (double.TryParse(raw.Trim().Replace(',', '.'), System.Globalization.NumberStyles.Any,
                System.Globalization.CultureInfo.InvariantCulture, out v))
                return v;
            if (double.TryParse(raw.Trim(), out v))
                return v;
            return null;
        }

        void SetFixedOrOther(ComboBox box, TextBox other, string value)
        {
            _choiceSync = true;
            try
            {
                var text = (value ?? string.Empty).Trim();
                if (text.Length == 0)
                {
                    box.SelectedIndex = -1;
                    other.Text = string.Empty;
                    other.Visibility = Visibility.Collapsed;
                    return;
                }
                ComboBoxItem otherItem = null;
                foreach (ComboBoxItem item in box.Items)
                {
                    if ((item.Tag as string) == "other")
                    {
                        otherItem = item;
                        continue;
                    }
                    var label = item.Content as string;
                    if (string.Equals(label, text, System.StringComparison.Ordinal))
                    {
                        box.SelectedItem = item;
                        other.Text = string.Empty;
                        other.Visibility = Visibility.Collapsed;
                        return;
                    }
                }
                if (otherItem != null)
                    box.SelectedItem = otherItem;
                other.Text = text;
                other.Visibility = Visibility.Visible;
            }
            finally
            {
                _choiceSync = false;
            }
        }

        static void ShowOther(ComboBox box, TextBox other)
        {
            var item = box.SelectedItem as ComboBoxItem;
            var isOther = item != null && (item.Tag as string) == "other";
            other.Visibility = isOther ? Visibility.Visible : Visibility.Collapsed;
            if (!isOther)
                other.Text = string.Empty;
        }

        static string ReadFixedOrOther(ComboBox box, TextBox other)
        {
            var item = box.SelectedItem as ComboBoxItem;
            if (item != null && (item.Tag as string) == "other")
                return NullIfEmpty(other.Text);
            var label = item == null ? null : item.Content as string;
            return NullIfEmpty(label);
        }

        static string NullIfEmpty(string s)
        {
            return string.IsNullOrWhiteSpace(s) ? null : s.Trim();
        }

        void OnStatusChanged(object sender, SelectionChangedEventArgs e)
        {
            if (!IsLoaded)
                return;
            UpdateStatusPanels();
        }

        void OnRetirementDateChanged(object sender, RoutedEventArgs e)
        {
            if (!IsLoaded)
                return;
            if (PersianDate.IsOnOrBeforeToday(RetirementDateBox.Value))
                StatusBox.SelectedIndex = 1;
            UpdateStatusPanels();
        }

        void UpdateStatusPanels()
        {
            if (InactiveReasonPanel == null)
                return;
            var retired = PersianDate.IsOnOrBeforeToday(RetirementDateBox.Value);
            var statusItem = StatusBox.SelectedItem as ComboBoxItem;
            var inactive = statusItem != null && (statusItem.Tag as string) == "inactive";

            if (retired && StatusBox.SelectedIndex != 1)
                StatusBox.SelectedIndex = 1;

            inactive = StatusBox.SelectedIndex == 1;
            InactiveReasonPanel.Visibility = inactive ? Visibility.Visible : Visibility.Collapsed;

            if (retired)
            {
                InactiveReasonLabel.Text = "دلیل غیرفعال‌سازی";
                InactiveReasonHint.Text = "تاریخ بازنشستگی گذشته است؛ وضعیت به‌صورت خودکار غیرفعال می‌شود.";
                InactiveReasonBox.IsReadOnly = true;
                InactiveReasonBox.Text = HrLookups.InactiveReasonRetirement;
            }
            else if (inactive)
            {
                InactiveReasonLabel.Text = "دلیل غیرفعال‌سازی *";
                InactiveReasonHint.Text = "چون غیرفعال‌سازی به‌خاطر بازنشستگی نیست، دلیل را حتماً بنویسید (مثلاً استعفا، انتقال، اخراج و …).";
                InactiveReasonBox.IsReadOnly = false;
                if (string.Equals((InactiveReasonBox.Text ?? "").Trim(), HrLookups.InactiveReasonRetirement, StringComparison.Ordinal))
                    InactiveReasonBox.Text = "";
            }
            else
            {
                InactiveReasonBox.IsReadOnly = false;
            }

            // وقتی بازنشسته است، انتخاب «فعال» بی‌اثر می‌ماند
            StatusBox.IsEnabled = !retired;
        }

        void OnSave(object sender, RoutedEventArgs e)
        {
            UpdateStatusPanels();
            var emp = Build();
            var iban1Err = IranianIban.ValidateOptional(Iban1Box.Text);
            if (iban1Err != null)
            {
                MessageBox.Show("شبا ۱: " + iban1Err, AppConstants.AppNameFa);
                return;
            }
            var iban2Err = IranianIban.ValidateOptional(Iban2Box.Text);
            if (iban2Err != null)
            {
                MessageBox.Show("شبا ۲: " + iban2Err, AppConstants.AppNameFa);
                return;
            }
            if (emp.EmploymentStatus == "inactive"
                && !PersianDate.IsOnOrBeforeToday(emp.RetirementDate)
                && string.IsNullOrWhiteSpace(emp.InactiveReason))
            {
                MessageBox.Show("برای غیرفعال‌سازی غیر از بازنشستگی، دلیل را وارد کنید.", AppConstants.AppNameFa);
                return;
            }
            if (HrLookups.IsOfficialEmployment(emp.EmploymentType))
            {
                if (!string.IsNullOrWhiteSpace(PositionBaseBox.Text) && emp.PositionBase == null)
                {
                    MessageBox.Show("پایه شماره سمت نامعتبر است.", AppConstants.AppNameFa);
                    return;
                }
                if (!string.IsNullOrWhiteSpace(PersonalBaseBox.Text) && emp.PersonalBase == null)
                {
                    MessageBox.Show("پایه شخصی نامعتبر است.", AppConstants.AppNameFa);
                    return;
                }
                var baseErr = HrLookups.ValidateOfficialBases(emp.EmploymentType, emp.PositionBase, emp.PersonalBase);
                if (baseErr != null)
                {
                    MessageBox.Show(baseErr, AppConstants.AppNameFa);
                    return;
                }
            }
            if (HrLookups.IsThirdPillarEmployment(emp.EmploymentType))
            {
                var jgErr = HrLookups.ValidateThirdPillarJobGroup(emp.EmploymentType, emp.JobGroup);
                if (jgErr != null)
                {
                    MessageBox.Show(jgErr, AppConstants.AppNameFa);
                    return;
                }
            }
            emp.PhotoPath = _photoCleared ? null : _savedPhotoPath;
            var wasNew = _isNew;
            if (!wasNew)
                emp.Id = _id;
            var err = SessionContext.Employees.Save(emp, _isNew);
            if (err != null)
            {
                MessageBox.Show(err, AppConstants.AppNameFa);
                return;
            }
            if (_photoCleared)
            {
                EmployeePhotoStore.Delete(_savedPhotoPath);
                SessionContext.Employees.SetPhotoPath(emp.Id, null);
                _savedPhotoPath = null;
            }
            if (_photoJpeg != null)
            {
                var relative = EmployeePhotoStore.SaveJpeg(emp.Id, _photoJpeg);
                SessionContext.Employees.SetPhotoPath(emp.Id, relative);
                _savedPhotoPath = relative;
                _photoJpeg = null;
            }
            if (wasNew && _pendingDocs.Count > 0)
            {
                foreach (var p in _pendingDocs)
                {
                    if (p == null || string.IsNullOrWhiteSpace(p.SourcePath) || !File.Exists(p.SourcePath))
                        continue;
                    var title = p.View == null ? null : p.View.Title;
                    if (string.IsNullOrWhiteSpace(title))
                        title = ResolveDocTitle(p.Kind);
                    var fileName = BuildDocFileName(title, p.SourcePath);
                    SessionContext.Documents.Store(emp.Id, title, p.Kind, p.SourcePath,
                        SessionContext.Current.User.Username, fileName);
                }
                _pendingDocs.Clear();
            }
            SessionContext.Audit.Add(SessionContext.Current.User.Id, SessionContext.Current.User.Username,
                wasNew ? "employee_create" : "employee_update", "employee", emp.Id);

            if (SessionContext.FieldSuggestions != null)
            {
                SessionContext.FieldSuggestions.RememberFromEmployee(emp);
                ReloadAllSuggestions();
                ReloadJobGroupSuggestions(emp.JobGroup);
            }

            _id = emp.Id;
            _isNew = false;
            _photoCleared = false;
            _didSave = true;
            Title = "ویرایش کارمند";
            DocsHint.Text = "شناسنامه و کارت ملی با نام خودکار ذخیره می‌شوند. برای سایر اسناد عنوان را خودتان بنویسید.";
            SaveButton.IsEnabled = SessionContext.Can(PermissionCodes.EmployeesEdit);
            ShowPhoto(PhotoImages.FromEmployee(_savedPhotoPath, 270));
            ReloadDocs();
            SaveStatusText.Text = "ذخیره شد";
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = _didSave;
            Close();
        }

        void OnPickPhoto(object sender, RoutedEventArgs e)
        {
            var dlg = new OpenFileDialog
            {
                Filter = "تصویر|*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tif;*.tiff|همه فایل‌ها|*.*",
                Title = "انتخاب عکس ۴×۳"
            };
            if (dlg.ShowDialog() != true)
                return;
            try
            {
                _photoJpeg = EmployeePhotoStore.FitFromFile(dlg.FileName);
                _photoCleared = false;
                ShowPhoto(PhotoImages.FromJpeg(_photoJpeg, 270));
            }
            catch (System.Exception ex)
            {
                MessageBox.Show("خواندن عکس ناموفق بود.\n" + ex.Message, AppConstants.AppNameFa);
            }
        }

        void OnClearPhoto(object sender, RoutedEventArgs e)
        {
            _photoJpeg = null;
            _photoCleared = true;
            ShowPhoto(null);
        }

        void ShowPhoto(System.Windows.Media.Imaging.BitmapImage image)
        {
            PhotoImage.Source = image;
            PhotoPlaceholder.Visibility = image == null ? Visibility.Visible : Visibility.Collapsed;
        }

        void OnAddDoc(object sender, RoutedEventArgs e)
        {
            var kind = KindFromSender(sender);
            var saveName = ResolveDocTitle(kind);
            if (string.IsNullOrWhiteSpace(saveName))
            {
                if (kind == DocumentKinds.Other)
                    MessageBox.Show("برای سایر اسناد ابتدا عنوان ذخیره را به‌صورت دستی وارد کنید.", AppConstants.AppNameFa);
                else
                    MessageBox.Show("ابتدا نام، نام خانوادگی و کد ملی را وارد کنید.", AppConstants.AppNameFa);
                return;
            }
            var dlg = new OpenFileDialog
            {
                Multiselect = false,
                Filter = "تصویر یا فایل|*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.pdf;*.*|همه|*.*"
            };
            if (dlg.ShowDialog() != true)
                return;
            var sourcePath = dlg.FileName;
            var fileName = BuildDocFileName(saveName, sourcePath);
            if (_isNew || _id == null)
            {
                _pendingSeq++;
                _pendingDocs.Add(new PendingDoc
                {
                    Kind = kind,
                    SourcePath = sourcePath,
                    View = new EmployeeDocument
                    {
                        Id = "pending:" + _pendingSeq,
                        Title = saveName,
                        FileName = fileName,
                        Category = kind
                    }
                });
                ReloadDocs();
                return;
            }
            var err = SessionContext.Documents.Store(_id, saveName, kind, sourcePath,
                SessionContext.Current.User.Username, fileName);
            if (err != null)
                MessageBox.Show(err);
            ReloadDocs();
        }

        static string BuildDocFileName(string title, string sourcePath)
        {
            var baseName = (title ?? "").Trim();
            if (string.IsNullOrWhiteSpace(baseName))
                baseName = "document";
            if (!string.IsNullOrEmpty(Path.GetExtension(baseName)))
                baseName = Path.GetFileNameWithoutExtension(baseName);
            var ext = Path.GetExtension(sourcePath) ?? "";
            if (string.IsNullOrEmpty(ext))
                ext = ".jpg";
            return baseName + ext;
        }

        void OnOpenDoc(object sender, RoutedEventArgs e)
        {
            OpenDoc(SelectedDoc(sender));
        }

        void OnDocsListWheel(object sender, MouseWheelEventArgs e)
        {
            if (DocsScroll == null || e.Handled)
                return;
            // ListBox چرخ‌ماوس را می‌گیرد؛ به ScrollViewer تب اسناد می‌دهیم تا گیر نکند
            DocsScroll.ScrollToVerticalOffset(DocsScroll.VerticalOffset - e.Delta);
            e.Handled = true;
        }

        void OnOpenDocList(object sender, MouseButtonEventArgs e)
        {
            var box = sender as ListBox;
            OpenDoc(box == null ? null : box.SelectedItem as EmployeeDocument);
        }

        void OnDeleteDoc(object sender, RoutedEventArgs e)
        {
            var doc = SelectedDoc(sender);
            if (doc == null)
                return;
            if (doc.Id != null && doc.Id.StartsWith("pending:", System.StringComparison.Ordinal))
            {
                _pendingDocs.RemoveAll(p => p.View != null && p.View.Id == doc.Id);
                ReloadDocs();
                return;
            }
            if (!SessionContext.Can(PermissionCodes.DocumentsDelete))
                return;
            SessionContext.Documents.SoftDelete(doc.Id);
            ReloadDocs();
        }

        void OpenDoc(EmployeeDocument doc)
        {
            if (doc == null)
                return;
            try
            {
                if (doc.Id != null && doc.Id.StartsWith("pending:", System.StringComparison.Ordinal))
                {
                    PendingDoc pending = null;
                    foreach (var p in _pendingDocs)
                    {
                        if (p.View != null && p.View.Id == doc.Id)
                        {
                            pending = p;
                            break;
                        }
                    }
                    if (pending == null || string.IsNullOrWhiteSpace(pending.SourcePath))
                        return;
                    Process.Start(new ProcessStartInfo { FileName = pending.SourcePath, UseShellExecute = true });
                    return;
                }
                var path = SessionContext.Documents.OpenToTemp(doc);
                Process.Start(new ProcessStartInfo { FileName = path, UseShellExecute = true });
            }
            catch (System.Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        sealed class PendingDoc
        {
            public string Kind;
            public string SourcePath;
            public EmployeeDocument View;
        }

        EmployeeDocument SelectedDoc(object sender)
        {
            return BoxForKind(KindFromSender(sender)).SelectedItem as EmployeeDocument;
        }

        static string KindFromSender(object sender)
        {
            var el = sender as FrameworkElement;
            return DocumentKinds.Normalize(el == null ? null : el.Tag as string);
        }

        ListBox BoxForKind(string kind)
        {
            if (kind == DocumentKinds.Birth)
                return BirthDocsBox;
            if (kind == DocumentKinds.National)
                return NationalDocsBox;
            return OtherDocsBox;
        }
    }
}
