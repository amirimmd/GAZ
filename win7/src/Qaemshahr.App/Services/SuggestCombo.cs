using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using Qaemshahr.Core;

namespace Qaemshahr.App.Services
{
    /// <summary>ComboBox قابل‌ویرایش با پیشنهادهای ذخیره‌شده و حذف با تأیید.</summary>
    public static class SuggestCombo
    {
        public static ComboBox Create(string category, string current = null, bool stretch = true)
        {
            var box = new ComboBox
            {
                IsEditable = true,
                IsTextSearchEnabled = true,
                StaysOpenOnEdit = true,
                HorizontalAlignment = stretch ? HorizontalAlignment.Stretch : HorizontalAlignment.Left,
                ToolTip = "بنویسید یا از پیشنهادها انتخاب کنید. برای حذف، روی مورد راست‌کلیک کنید."
            };
            Attach(box, category);
            Reload(box, category, current);
            return box;
        }

        public static void Attach(ComboBox box, string category)
        {
            if (box == null || string.IsNullOrWhiteSpace(category))
                return;
            box.Tag = category;
            box.ToolTip = "بنویسید یا از پیشنهادها انتخاب کنید. برای حذف، روی مورد راست‌کلیک کنید.";

            var style = new Style(typeof(ComboBoxItem));
            style.Setters.Add(new EventSetter(
                UIElement.MouseRightButtonUpEvent,
                new MouseButtonEventHandler(OnSuggestionRightClick)));
            box.ItemContainerStyle = style;

            var menu = new ContextMenu();
            var del = new MenuItem { Header = "حذف این مورد از پیشنهادها" };
            del.Click += (s, e) => TryDelete(box, category, box.Text);
            menu.Items.Add(del);
            box.ContextMenu = menu;
        }

        public static void Reload(ComboBox box, string category, string current = null)
        {
            if (box == null)
                return;
            var keep = (current ?? box.Text ?? string.Empty).Trim();
            var stored = SessionContext.FieldSuggestions == null
                ? new System.Collections.Generic.List<string>()
                : SessionContext.FieldSuggestions.List(category);
            var suggestions = FieldSuggestionKeys.Merge(stored, keep);
            box.Items.Clear();
            foreach (var g in suggestions)
                box.Items.Add(g);
            box.Text = keep;
        }

        static void OnSuggestionRightClick(object sender, MouseButtonEventArgs e)
        {
            var item = sender as ComboBoxItem;
            if (item == null)
                return;
            var box = ItemsControl.ItemsControlFromItemContainer(item) as ComboBox;
            if (box == null)
                return;
            var category = box.Tag as string;
            var value = item.Content as string;
            if (string.IsNullOrWhiteSpace(category) || string.IsNullOrWhiteSpace(value))
                return;
            e.Handled = true;
            TryDelete(box, category, value);
        }

        static void TryDelete(ComboBox box, string category, string value)
        {
            var v = (value ?? string.Empty).Trim();
            if (v.Length == 0 || SessionContext.FieldSuggestions == null)
                return;
            var title = FieldSuggestionKeys.TitleFa(category);
            var owner = Window.GetWindow(box);
            var result = MessageBox.Show(
                owner,
                "مورد «" + v + "» از پیشنهادهای «" + title + "» حذف شود؟",
                AppConstants.AppNameFa,
                MessageBoxButton.OKCancel,
                MessageBoxImage.Question,
                MessageBoxResult.Cancel);
            if (result != MessageBoxResult.OK)
                return;
            SessionContext.FieldSuggestions.Delete(category, v);
            var keep = string.Equals((box.Text ?? "").Trim(), v, System.StringComparison.CurrentCultureIgnoreCase)
                ? string.Empty
                : box.Text;
            Reload(box, category, keep);
        }

        public static string TextOf(ComboBox box)
        {
            return box == null ? null : (box.Text ?? string.Empty).Trim();
        }
    }
}
