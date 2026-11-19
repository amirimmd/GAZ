using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace Qaemshahr.App.Services
{
    /// <summary>
    /// جهت خودکار ورودی: فارسی → راست؛ انگلیسی/عدد → چپ.
    /// با RegisterGlobalAutoDirection روی همهٔ TextBox و ComboBoxهای برنامه اعمال می‌شود.
    /// </summary>
    public static class UiInput
    {
        public static readonly DependencyProperty SkipAutoDirectionProperty =
            DependencyProperty.RegisterAttached(
                "SkipAutoDirection",
                typeof(bool),
                typeof(UiInput),
                new PropertyMetadata(false));

        public static void SetSkipAutoDirection(DependencyObject element, bool value)
        {
            element.SetValue(SkipAutoDirectionProperty, value);
        }

        public static bool GetSkipAutoDirection(DependencyObject element)
        {
            return element != null && (bool)element.GetValue(SkipAutoDirectionProperty);
        }

        static bool _globalRegistered;

        public static void RegisterGlobalAutoDirection()
        {
            if (_globalRegistered)
                return;
            _globalRegistered = true;

            EventManager.RegisterClassHandler(typeof(TextBox), FrameworkElement.LoadedEvent,
                new RoutedEventHandler(OnTextBoxLoaded));
            EventManager.RegisterClassHandler(typeof(TextBox), TextBox.TextChangedEvent,
                new TextChangedEventHandler(OnTextBoxTextChanged));
            EventManager.RegisterClassHandler(typeof(TextBox), UIElement.GotKeyboardFocusEvent,
                new KeyboardFocusChangedEventHandler(OnTextBoxFocus), true);

            EventManager.RegisterClassHandler(typeof(ComboBox), FrameworkElement.LoadedEvent,
                new RoutedEventHandler(OnComboBoxLoaded));
            EventManager.RegisterClassHandler(typeof(ComboBox), TextBox.TextChangedEvent,
                new TextChangedEventHandler(OnComboBoxTextChanged), true);
            EventManager.RegisterClassHandler(typeof(ComboBox), UIElement.GotKeyboardFocusEvent,
                new KeyboardFocusChangedEventHandler(OnComboBoxFocus), true);
            EventManager.RegisterClassHandler(typeof(ComboBox), System.Windows.Controls.Primitives.Selector.SelectionChangedEvent,
                new SelectionChangedEventHandler(OnComboBoxSelectionChanged));

            EventManager.RegisterClassHandler(typeof(PasswordBox), FrameworkElement.LoadedEvent,
                new RoutedEventHandler(OnPasswordBoxLoaded));
            EventManager.RegisterClassHandler(typeof(PasswordBox), PasswordBox.PasswordChangedEvent,
                new RoutedEventHandler(OnPasswordBoxChanged));
            EventManager.RegisterClassHandler(typeof(PasswordBox), UIElement.GotKeyboardFocusEvent,
                new KeyboardFocusChangedEventHandler(OnPasswordBoxFocus), true);
        }

        static void OnPasswordBoxLoaded(object sender, RoutedEventArgs e)
        {
            ApplyAutoDirection(sender as PasswordBox);
        }

        static void OnPasswordBoxChanged(object sender, RoutedEventArgs e)
        {
            ApplyAutoDirection(sender as PasswordBox);
        }

        static void OnPasswordBoxFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            ApplyAutoDirection(sender as PasswordBox);
        }

        static void OnTextBoxLoaded(object sender, RoutedEventArgs e)
        {
            ApplyAutoDirection(sender as TextBox);
        }

        static void OnTextBoxTextChanged(object sender, TextChangedEventArgs e)
        {
            ApplyAutoDirection(sender as TextBox);
        }

        static void OnTextBoxFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            ApplyAutoDirection(sender as TextBox);
        }

        static void OnComboBoxLoaded(object sender, RoutedEventArgs e)
        {
            ApplyAutoDirection(sender as ComboBox);
        }

        static void OnComboBoxTextChanged(object sender, TextChangedEventArgs e)
        {
            var combo = sender as ComboBox;
            if (combo == null)
                combo = FindParentCombo(e.OriginalSource as DependencyObject);
            ApplyAutoDirection(combo);
        }

        static void OnComboBoxFocus(object sender, KeyboardFocusChangedEventArgs e)
        {
            ApplyAutoDirection(sender as ComboBox);
        }

        static void OnComboBoxSelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            ApplyAutoDirection(sender as ComboBox);
        }

        static ComboBox FindParentCombo(DependencyObject child)
        {
            var current = child;
            while (current != null)
            {
                var combo = current as ComboBox;
                if (combo != null)
                    return combo;
                current = VisualTreeHelper.GetParent(current);
            }
            return null;
        }

        public static void UseEnglish(Control control)
        {
            if (control == null)
                return;
            InputMethod.SetIsInputMethodEnabled(control, false);
            InputMethod.SetPreferredImeState(control, InputMethodState.Off);
            control.GotKeyboardFocus += (s, e) =>
            {
                try
                {
                    InputLanguageManager.Current.CurrentInputLanguage = CultureInfo.GetCultureInfo("en-US");
                }
                catch
                {
                }
            };
        }

        public static void UseEnglish(params Control[] controls)
        {
            if (controls == null)
                return;
            for (var i = 0; i < controls.Length; i++)
            {
                if (controls[i] != null)
                    UseEnglish(controls[i]);
            }
        }

        /// <summary>
        /// فیلدهای ورود/رمز (مثل لاگین و بکاپ): همیشه انگلیسی و چپ‌چین؛
        /// جهت خودکار سراسری اعمال نمی‌شود تا فیلد خالی فارسی/RTL نشود.
        /// </summary>
        public static void UseEnglishCredentials(params Control[] controls)
        {
            if (controls == null)
                return;
            for (var i = 0; i < controls.Length; i++)
            {
                var control = controls[i];
                if (control == null)
                    continue;
                SetSkipAutoDirection(control, true);
                UseEnglish(control);
                ForceLtr(control);
            }
        }

        public static void ForceLtr(Control control)
        {
            if (control == null)
                return;
            SetDirection(control, true);
        }

        public static void UseAutoDirection(TextBox box)
        {
            ApplyAutoDirection(box);
        }

        public static void UseAutoDirection(params TextBox[] boxes)
        {
            if (boxes == null)
                return;
            for (var i = 0; i < boxes.Length; i++)
                ApplyAutoDirection(boxes[i]);
        }

        public static void UseAutoDirection(ComboBox box)
        {
            ApplyAutoDirection(box);
        }

        public static void UseAutoDirection(params ComboBox[] boxes)
        {
            if (boxes == null)
                return;
            for (var i = 0; i < boxes.Length; i++)
                ApplyAutoDirection(boxes[i]);
        }

        public static void ApplyAutoDirection(TextBox box)
        {
            if (box == null || GetSkipAutoDirection(box))
                return;
            // TextBox داخل قالب PasswordBox را دست نزن
            if (FindParentOfType<PasswordBox>(box) != null)
                return;

            var ltr = IsPrimarilyLatinOrDigits(box.Text);
            SetDirection(box, ltr);

            var parentCombo = FindParentCombo(box);
            if (parentCombo != null && !GetSkipAutoDirection(parentCombo))
                SetDirection(parentCombo, ltr);
        }

        public static void ApplyAutoDirection(ComboBox box)
        {
            if (box == null || GetSkipAutoDirection(box))
                return;

            var text = box.IsEditable ? box.Text : null;
            if (string.IsNullOrEmpty(text))
            {
                var item = box.SelectedItem as ComboBoxItem;
                if (item != null)
                    text = item.Content as string;
                else if (box.SelectedItem != null)
                    text = box.SelectedItem.ToString();
            }

            var ltr = IsPrimarilyLatinOrDigits(text);
            SetDirection(box, ltr);

            if (box.IsEditable)
            {
                var inner = FindEditableTextBox(box);
                if (inner != null && !GetSkipAutoDirection(inner))
                    SetDirection(inner, ltr);
            }
        }

        static void SetDirection(Control control, bool ltr)
        {
            // در WPF با FlowDirection=RTL، TextAlignment.Left یعنی لبهٔ شروع خواندن = سمت راست ظاهری.
            // TextAlignment.Right در حالت RTL نشانگر را به چپ می‌برد (باگ قبلی).
            if (ltr)
            {
                control.FlowDirection = FlowDirection.LeftToRight;
                control.HorizontalContentAlignment = HorizontalAlignment.Left;
                var tbLtr = control as TextBox;
                if (tbLtr != null)
                    tbLtr.TextAlignment = TextAlignment.Left;
            }
            else
            {
                control.FlowDirection = FlowDirection.RightToLeft;
                control.HorizontalContentAlignment = HorizontalAlignment.Left;
                var tbRtl = control as TextBox;
                if (tbRtl != null)
                    tbRtl.TextAlignment = TextAlignment.Left;
            }
            try
            {
                control.Language = System.Windows.Markup.XmlLanguage.GetLanguage(ltr ? "en-US" : "fa-IR");
            }
            catch
            {
            }
        }

        public static void ApplyAutoDirection(PasswordBox box)
        {
            if (box == null || GetSkipAutoDirection(box))
                return;
            var ltr = IsPrimarilyLatinOrDigits(box.Password);
            SetDirection(box, ltr);
        }

        static TextBox FindEditableTextBox(ComboBox combo)
        {
            if (combo == null)
                return null;
            if (!combo.IsLoaded)
                return null;
            return FindVisualChild<TextBox>(combo);
        }

        static T FindVisualChild<T>(DependencyObject parent) where T : DependencyObject
        {
            if (parent == null)
                return null;
            var count = VisualTreeHelper.GetChildrenCount(parent);
            for (var i = 0; i < count; i++)
            {
                var child = VisualTreeHelper.GetChild(parent, i);
                var match = child as T;
                if (match != null)
                    return match;
                var nested = FindVisualChild<T>(child);
                if (nested != null)
                    return nested;
            }
            return null;
        }

        static T FindParentOfType<T>(DependencyObject child) where T : DependencyObject
        {
            var current = child;
            while (current != null)
            {
                var match = current as T;
                if (match != null)
                    return match;
                current = VisualTreeHelper.GetParent(current);
            }
            return null;
        }

        /// <summary>
        /// خالی یا فارسی → راست؛ فقط انگلیسی/عدد → چپ.
        /// </summary>
        static bool IsPrimarilyLatinOrDigits(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
                return false;
            var hasLatinOrDigit = false;
            foreach (var ch in text.Trim())
            {
                if (char.IsWhiteSpace(ch) || IsNeutralPunctuation(ch))
                    continue;
                if (char.IsDigit(ch) || IsAsciiLetter(ch))
                {
                    hasLatinOrDigit = true;
                    continue;
                }
                // حرف فارسی/عربی یا هر نویسهٔ غیرلاتین → راست‌چین
                return false;
            }
            return hasLatinOrDigit;
        }

        static bool IsAsciiLetter(char ch)
        {
            return (ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z');
        }

        static bool IsNeutralPunctuation(char ch)
        {
            switch (ch)
            {
                case '-':
                case '_':
                case '.':
                case ':':
                case '/':
                case '\\':
                case '+':
                case '*':
                case '(':
                case ')':
                case '"':
                case '\'':
                case '@':
                case '#':
                case '%':
                case ',':
                case ';':
                case '=':
                case '?':
                case '!':
                case '[':
                case ']':
                case '{':
                case '}':
                case '<':
                case '>':
                case '|':
                case '&':
                    return true;
                default:
                    return false;
            }
        }
    }
}
