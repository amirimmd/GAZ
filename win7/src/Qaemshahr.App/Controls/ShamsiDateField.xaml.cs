using System.Globalization;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using Qaemshahr.Core;

namespace Qaemshahr.App.Controls
{
    public partial class ShamsiDateField : UserControl
    {
        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register(
            "Value", typeof(string), typeof(ShamsiDateField),
            new FrameworkPropertyMetadata(string.Empty, FrameworkPropertyMetadataOptions.BindsTwoWayByDefault, OnValueChanged));

        public static readonly RoutedEvent ValueChangedEvent = EventManager.RegisterRoutedEvent(
            "ValueChanged", RoutingStrategy.Bubble, typeof(RoutedEventHandler), typeof(ShamsiDateField));

        public event RoutedEventHandler ValueChanged
        {
            add { AddHandler(ValueChangedEvent, value); }
            remove { RemoveHandler(ValueChangedEvent, value); }
        }

        int _suppress;
        bool _ready;
        bool _committingEdit;

        public ShamsiDateField()
        {
            InitializeComponent();
            Loaded += OnLoaded;
            YearBox.PreviewMouseLeftButtonDown += OnComboPreviewClick;
            MonthBox.PreviewMouseLeftButtonDown += OnComboPreviewClick;
            DayBox.PreviewMouseLeftButtonDown += OnComboPreviewClick;
        }

        public string Value
        {
            get { return (string)GetValue(ValueProperty); }
            set { SetValue(ValueProperty, value ?? string.Empty); }
        }

        void OnLoaded(object sender, RoutedEventArgs e)
        {
            if (_ready)
                return;
            FillYearsAndMonths();
            _ready = true;
            ApplyToCombos(Value);
        }

        static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var field = (ShamsiDateField)d;
            if (field._suppress > 0 || !field._ready)
                return;
            field.ExitAllEditModes();
            field.ApplyToCombos(e.NewValue as string);
        }

        void FillYearsAndMonths()
        {
            _suppress++;
            YearBox.Items.Clear();
            YearBox.Items.Add(new ComboBoxItem { Content = "سال", Tag = 0 });
            var now = PersianDate.CurrentYear();
            for (var y = now; y >= 1201; y--)
                YearBox.Items.Add(new ComboBoxItem { Content = y.ToString(), Tag = y });

            MonthBox.Items.Clear();
            MonthBox.Items.Add(new ComboBoxItem { Content = "ماه", Tag = 0 });
            for (var m = 1; m <= 12; m++)
                MonthBox.Items.Add(new ComboBoxItem { Content = PersianDate.MonthNames[m - 1], Tag = m });

            FillDays();
            YearBox.SelectedIndex = 0;
            MonthBox.SelectedIndex = 0;
            _suppress--;
        }

        void FillDays()
        {
            _suppress++;
            var y = TagOf(YearBox);
            var m = TagOf(MonthBox);
            var keep = TagOf(DayBox);
            var max = (y > 0 && m > 0) ? PersianDate.DaysInMonth(y, m) : 31;
            DayBox.Items.Clear();
            DayBox.Items.Add(new ComboBoxItem { Content = "روز", Tag = 0 });
            for (var d = 1; d <= max; d++)
                DayBox.Items.Add(new ComboBoxItem { Content = d.ToString(), Tag = d });
            if (keep > max)
                keep = max;
            SelectTag(DayBox, keep);
            _suppress--;
        }

        void ApplyToCombos(string value)
        {
            _suppress++;
            int y, m, d;
            if (PersianDate.TryGetParts(value, out y, out m, out d))
            {
                EnsureYearItem(y);
                SelectTag(YearBox, y);
                SelectTag(MonthBox, m);
                FillDays();
                SelectTag(DayBox, d);
            }
            else
            {
                YearBox.SelectedIndex = 0;
                MonthBox.SelectedIndex = 0;
                FillDays();
                DayBox.SelectedIndex = 0;
            }
            _suppress--;
        }

        void OnPartChanged(object sender, SelectionChangedEventArgs e)
        {
            if (_suppress > 0 || !_ready)
                return;
            if (sender == YearBox || sender == MonthBox)
                FillDays();
            WriteValue();
        }

        void OnComboPreviewClick(object sender, MouseButtonEventArgs e)
        {
            if (e.ClickCount < 2)
                return;
            var box = sender as ComboBox;
            if (box == null)
                return;
            e.Handled = true;
            EnterEditMode(box);
        }

        void EnterEditMode(ComboBox box)
        {
            TextBox edit;
            if (ReferenceEquals(box, YearBox))
                edit = YearEdit;
            else if (ReferenceEquals(box, MonthBox))
                edit = MonthEdit;
            else if (ReferenceEquals(box, DayBox))
                edit = DayEdit;
            else
                return;

            ExitAllEditModes(box);
            var tag = TagOf(box);
            edit.Text = tag > 0 ? tag.ToString(CultureInfo.InvariantCulture) : string.Empty;
            // Hidden (نه Collapsed) تا عرض/ارتفاع سلول عوض نشود و چیدمان نپرد
            box.Visibility = Visibility.Hidden;
            edit.Visibility = Visibility.Visible;
            edit.Focus();
            edit.SelectAll();
        }

        void ExitAllEditModes(ComboBox keepOpenFor = null)
        {
            if (!ReferenceEquals(keepOpenFor, YearBox) && YearEdit.Visibility == Visibility.Visible)
                CommitEdit(YearBox, YearEdit, false);
            if (!ReferenceEquals(keepOpenFor, MonthBox) && MonthEdit.Visibility == Visibility.Visible)
                CommitEdit(MonthBox, MonthEdit, false);
            if (!ReferenceEquals(keepOpenFor, DayBox) && DayEdit.Visibility == Visibility.Visible)
                CommitEdit(DayBox, DayEdit, false);
        }

        void OnEditLostFocus(object sender, RoutedEventArgs e)
        {
            var edit = sender as TextBox;
            if (edit == null || edit.Visibility != Visibility.Visible)
                return;
            ComboBox box;
            if (ReferenceEquals(edit, YearEdit))
                box = YearBox;
            else if (ReferenceEquals(edit, MonthEdit))
                box = MonthBox;
            else
                box = DayBox;
            CommitEdit(box, edit, true);
        }

        void OnEditKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key != Key.Enter && e.Key != Key.Return && e.Key != Key.Escape)
                return;
            var edit = sender as TextBox;
            if (edit == null)
                return;
            ComboBox box;
            if (ReferenceEquals(edit, YearEdit))
                box = YearBox;
            else if (ReferenceEquals(edit, MonthEdit))
                box = MonthBox;
            else
                box = DayBox;
            if (e.Key == Key.Escape)
            {
                edit.Visibility = Visibility.Collapsed;
                box.Visibility = Visibility.Visible;
                e.Handled = true;
                return;
            }
            CommitEdit(box, edit, true);
            e.Handled = true;
        }

        void CommitEdit(ComboBox box, TextBox edit, bool write)
        {
            if (_committingEdit)
                return;
            _committingEdit = true;
            try
            {
                var raw = ToLatinDigits((edit.Text ?? string.Empty).Trim());
                int n;
                if (int.TryParse(raw, NumberStyles.Integer, CultureInfo.InvariantCulture, out n) && n > 0)
                {
                    _suppress++;
                    if (ReferenceEquals(box, YearBox))
                    {
                        if (n >= 1201 && n <= 1600)
                        {
                            EnsureYearItem(n);
                            SelectTag(YearBox, n);
                            FillDays();
                        }
                    }
                    else if (ReferenceEquals(box, MonthBox))
                    {
                        if (n >= 1 && n <= 12)
                        {
                            SelectTag(MonthBox, n);
                            FillDays();
                        }
                    }
                    else if (ReferenceEquals(box, DayBox))
                    {
                        var y = TagOf(YearBox);
                        var m = TagOf(MonthBox);
                        var max = (y > 0 && m > 0) ? PersianDate.DaysInMonth(y, m) : 31;
                        if (n >= 1 && n <= max)
                            SelectTag(DayBox, n);
                    }
                    _suppress--;
                }

                edit.Visibility = Visibility.Collapsed;
                box.Visibility = Visibility.Visible;
                if (write)
                    WriteValue();
            }
            finally
            {
                _committingEdit = false;
            }
        }

        void OnNumericPreview(object sender, TextCompositionEventArgs e)
        {
            e.Handled = !Regex.IsMatch(ToLatinDigits(e.Text ?? ""), "^[0-9]+$");
        }

        void OnNumericPaste(object sender, DataObjectPastingEventArgs e)
        {
            if (!e.DataObject.GetDataPresent(DataFormats.Text))
            {
                e.CancelCommand();
                return;
            }
            var text = ToLatinDigits(e.DataObject.GetData(DataFormats.Text) as string ?? "");
            if (!Regex.IsMatch(text, "^[0-9]+$"))
                e.CancelCommand();
        }

        static string ToLatinDigits(string text)
        {
            if (string.IsNullOrEmpty(text))
                return text ?? string.Empty;
            var chars = text.ToCharArray();
            for (var i = 0; i < chars.Length; i++)
            {
                if (chars[i] >= '\u06F0' && chars[i] <= '\u06F9')
                    chars[i] = (char)('0' + (chars[i] - '\u06F0'));
                else if (chars[i] >= '\u0660' && chars[i] <= '\u0669')
                    chars[i] = (char)('0' + (chars[i] - '\u0660'));
            }
            return new string(chars);
        }

        void WriteValue()
        {
            var y = TagOf(YearBox);
            var m = TagOf(MonthBox);
            var d = TagOf(DayBox);
            _suppress++;
            if (y > 0 && m > 0 && d > 0 && PersianDate.IsValid(y, m, d))
                Value = PersianDate.FormatParts(y, m, d);
            else
                Value = string.Empty;
            _suppress--;
            RaiseEvent(new RoutedEventArgs(ValueChangedEvent));
        }

        void OnToday(object sender, RoutedEventArgs e)
        {
            ExitAllEditModes();
            Value = PersianDate.Today();
            if (_ready)
                ApplyToCombos(Value);
            RaiseEvent(new RoutedEventArgs(ValueChangedEvent));
        }

        void OnClear(object sender, RoutedEventArgs e)
        {
            ExitAllEditModes();
            Value = string.Empty;
            if (_ready)
                ApplyToCombos(Value);
            RaiseEvent(new RoutedEventArgs(ValueChangedEvent));
        }

        void EnsureYearItem(int year)
        {
            if (year <= 0)
                return;
            foreach (ComboBoxItem item in YearBox.Items)
            {
                if (item.Tag is int && (int)item.Tag == year)
                    return;
            }
            var insertAt = 1;
            for (var i = 1; i < YearBox.Items.Count; i++)
            {
                var it = YearBox.Items[i] as ComboBoxItem;
                var t = it != null && it.Tag is int ? (int)it.Tag : 0;
                if (t < year)
                {
                    insertAt = i;
                    break;
                }
                insertAt = i + 1;
            }
            YearBox.Items.Insert(insertAt, new ComboBoxItem { Content = year.ToString(), Tag = year });
        }

        static int TagOf(ComboBox box)
        {
            var item = box.SelectedItem as ComboBoxItem;
            if (item == null || item.Tag == null)
                return 0;
            if (item.Tag is int)
                return (int)item.Tag;
            int n;
            return int.TryParse(item.Tag.ToString(), out n) ? n : 0;
        }

        static void SelectTag(ComboBox box, int tag)
        {
            foreach (ComboBoxItem item in box.Items)
            {
                var t = 0;
                if (item.Tag is int)
                    t = (int)item.Tag;
                if (t == tag)
                {
                    box.SelectedItem = item;
                    return;
                }
            }
            if (box.Items.Count > 0)
                box.SelectedIndex = 0;
        }
    }
}
