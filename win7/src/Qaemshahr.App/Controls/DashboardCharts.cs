using System;
using System.Collections.Generic;
using System.Globalization;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Shapes;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Controls
{
    static class DashboardCharts
    {
        public static Color LightColor(string light)
        {
            byte r, g, b;
            PerformanceLights.Rgb(light, out r, out g, out b);
            return Color.FromRgb(r, g, b);
        }

        public static Brush BrushOf(FrameworkElement owner, string key, Color fallback)
        {
            var b = owner.TryFindResource(key) as Brush;
            return b ?? new SolidColorBrush(fallback);
        }

        public static UIElement Donut(FrameworkElement owner, IList<NamedCount> items, Action<NamedCount> onClick)
        {
            var total = Sum(items);
            var root = new Grid();
            root.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(176) });
            root.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });

            var canvas = new Canvas
            {
                Width = 168,
                Height = 168,
                FlowDirection = FlowDirection.LeftToRight,
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Center
            };
            RenderOptions.SetEdgeMode(canvas, EdgeMode.Unspecified);
            const double cx = 84, cy = 84, outer = 74, inner = 44;
            if (total <= 0)
                canvas.Children.Add(DonutSlice(cx, cy, outer, inner, -90, 359.9, BrushOf(owner, "BorderBrush", Color.FromRgb(0xD5, 0xDE, 0xE4))));
            else
            {
                var angle = -90.0;
                var drawn = 0;
                foreach (var it in items)
                {
                    if (it.Count <= 0)
                        continue;
                    drawn += it.Count;
                    var sweep = 360.0 * it.Count / total;
                    if (drawn == total)
                        sweep = 270 - angle;
                    var slice = DonutSlice(cx, cy, outer, inner, angle, sweep, new SolidColorBrush(LightColor(it.Light ?? it.Key)));
                    var captured = it;
                    slice.Cursor = Cursors.Hand;
                    slice.ToolTip = it.Label + "  " + it.Count + " نفر  (" + Pct(it.Count, total) + "٪)";
                    slice.MouseLeftButtonUp += (s, e) => { e.Handled = true; if (onClick != null) onClick(captured); };
                    canvas.Children.Add(slice);
                    angle += sweep;
                }
            }
            AddCentered(canvas, cx, cy - 8, total.ToString(), 22, FontWeights.Bold, BrushOf(owner, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F)));
            AddCentered(canvas, cx, cy + 14, "نفر فعال", 11, FontWeights.Normal, BrushOf(owner, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74)));
            Grid.SetColumn(canvas, 0);
            root.Children.Add(canvas);

            var legend = new StackPanel { VerticalAlignment = VerticalAlignment.Center, Margin = new Thickness(12, 0, 0, 0) };
            if (items != null)
            {
                foreach (var it in items)
                {
                    var captured = it;
                    var row = new Grid { Margin = new Thickness(0, 0, 0, 8), Cursor = Cursors.Hand };
                    row.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(12) });
                    row.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                    row.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
                    row.Children.Add(new Border
                    {
                        Width = 10,
                        Height = 10,
                        CornerRadius = new CornerRadius(2),
                        Background = new SolidColorBrush(LightColor(it.Light ?? it.Key)),
                        VerticalAlignment = VerticalAlignment.Center
                    });
                    var name = new TextBlock { Text = it.Label, FontSize = 13, Margin = new Thickness(8, 0, 8, 0), TextTrimming = TextTrimming.CharacterEllipsis };
                    Grid.SetColumn(name, 1);
                    row.Children.Add(name);
                    var val = new TextBlock
                    {
                        Text = it.Count + "  ·  " + Pct(it.Count, total) + "٪",
                        FontSize = 12,
                        FontWeight = FontWeights.SemiBold,
                        Foreground = BrushOf(owner, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74))
                    };
                    Grid.SetColumn(val, 2);
                    row.Children.Add(val);
                    row.MouseLeftButtonUp += (s, e) => { e.Handled = true; if (onClick != null) onClick(captured); };
                    legend.Children.Add(row);
                }
            }
            Grid.SetColumn(legend, 1);
            root.Children.Add(legend);
            return root;
        }

        public static UIElement Gauge(FrameworkElement owner, int covered, int total, Action onClick)
        {
            var pct = total <= 0 ? 0 : Math.Max(0, Math.Min(100, 100.0 * covered / total));
            var fill = pct >= 80 ? Color.FromRgb(0x2E, 0x7D, 0x32)
                : pct >= 50 ? Color.FromRgb(0xF9, 0xA8, 0x25)
                : Color.FromRgb(0xC6, 0x28, 0x28);
            var root = new StackPanel { Cursor = Cursors.Hand };
            root.MouseLeftButtonUp += (s, e) => { e.Handled = true; if (onClick != null) onClick(); };

            var canvas = new Canvas
            {
                Width = 220,
                Height = 128,
                HorizontalAlignment = HorizontalAlignment.Center,
                FlowDirection = FlowDirection.LeftToRight
            };
            const double cx = 110, cy = 112, r = 88;
            canvas.Children.Add(Arc(cx, cy, r, 180, 180, BrushOf(owner, "SoftPanelBrush", Color.FromRgb(0xE8, 0xEE, 0xF2)), 14));
            if (pct > 0.05)
            {
                var sweep = Math.Max(0.8, 180.0 * pct / 100.0);
                canvas.Children.Add(Arc(cx, cy, r, 180, sweep, new SolidColorBrush(fill), 14));
            }
            AddCentered(canvas, cx, 78, pct.ToString("0", CultureInfo.InvariantCulture) + "٪", 28, FontWeights.Bold, new SolidColorBrush(fill));
            AddCentered(canvas, cx, 104, covered + " از " + total + " نفر", 12, FontWeights.Normal,
                BrushOf(owner, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74)));
            root.Children.Add(canvas);
            root.Children.Add(new TextBlock
            {
                Text = "درصد نیروی فعال با عکس، شناسنامه و کارت ملی کامل. کلیک برای فهرست ناقص‌ها.",
                Style = owner.TryFindResource("MutedText") as Style,
                TextWrapping = TextWrapping.Wrap,
                TextAlignment = TextAlignment.Center,
                Margin = new Thickness(0, 4, 0, 0)
            });
            return root;
        }

        public static UIElement HorizontalBars(FrameworkElement owner, IList<NamedCount> items, int totalForPct, Action<NamedCount> onClick, bool lightColors)
        {
            var panel = new StackPanel();
            if (items == null || items.Count == 0)
            {
                panel.Children.Add(Empty(owner, "داده‌ای برای نمایش نیست."));
                return panel;
            }
            var barBrush = BrushOf(owner, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F));
            var track = BrushOf(owner, "SoftPanelBrush", Color.FromRgb(0xEE, 0xF2, 0xF5));
            var denom = totalForPct > 0 ? totalForPct : Sum(items);
            if (denom <= 0)
                denom = 1;
            foreach (var it in items)
            {
                var captured = it;
                var block = new StackPanel { Margin = new Thickness(0, 0, 0, 12), Cursor = onClick == null ? Cursors.Arrow : Cursors.Hand };
                if (onClick != null)
                    block.MouseLeftButtonUp += (s, e) => { e.Handled = true; onClick(captured); };

                var head = new Grid { Margin = new Thickness(0, 0, 0, 5) };
                head.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                head.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
                head.Children.Add(new TextBlock
                {
                    Text = it.Label,
                    FontSize = 13,
                    TextTrimming = TextTrimming.CharacterEllipsis,
                    VerticalAlignment = VerticalAlignment.Center
                });
                var right = new TextBlock
                {
                    Text = it.Count + " نفر  (" + Pct(it.Count, denom) + "٪)",
                    FontSize = 12,
                    FontWeight = FontWeights.SemiBold,
                    Margin = new Thickness(10, 0, 0, 0),
                    VerticalAlignment = VerticalAlignment.Center,
                    Foreground = BrushOf(owner, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74))
                };
                Grid.SetColumn(right, 1);
                head.Children.Add(right);
                block.Children.Add(head);

                var pct = Math.Max(0, Math.Min(100, 100.0 * it.Count / denom));
                block.Children.Add(PercentTrack(pct,
                    lightColors ? new SolidColorBrush(LightColor(it.Light ?? it.Key)) : barBrush,
                    track, 10));
                block.ToolTip = it.Label + " — " + it.Count + " نفر (" + Pct(it.Count, denom) + "٪ از جامعه)";
                panel.Children.Add(block);
            }
            return panel;
        }

        public static UIElement DocumentBars(FrameworkElement owner, IList<NamedCount> items, int active, Action<NamedCount> onClick)
        {
            var panel = new StackPanel();
            if (items == null)
                return panel;
            var fillBrush = BrushOf(owner, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F));
            var track = BrushOf(owner, "SoftPanelBrush", Color.FromRgb(0xEE, 0xF2, 0xF5));
            foreach (var it in items)
            {
                var captured = it;
                var missing = active - it.Count;
                if (missing < 0) missing = 0;
                var pct = active <= 0 ? 0 : Math.Max(0, Math.Min(100, 100.0 * it.Count / active));
                var row = new StackPanel { Margin = new Thickness(0, 0, 0, 14), Cursor = Cursors.Hand };
                row.MouseLeftButtonUp += (s, e) => { e.Handled = true; if (onClick != null) onClick(captured); };

                var head = new Grid { Margin = new Thickness(0, 0, 0, 6) };
                head.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                head.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
                head.Children.Add(new TextBlock
                {
                    Text = it.Label,
                    FontWeight = FontWeights.SemiBold,
                    FontSize = 13,
                    VerticalAlignment = VerticalAlignment.Center
                });
                var right = new TextBlock
                {
                    Text = "تکمیل " + it.Count + "  ·  ناقص " + missing + "  (" + pct.ToString("0.0", CultureInfo.InvariantCulture) + "٪)",
                    FontSize = 12,
                    Margin = new Thickness(10, 0, 0, 0),
                    VerticalAlignment = VerticalAlignment.Center,
                    Foreground = BrushOf(owner, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74))
                };
                Grid.SetColumn(right, 1);
                head.Children.Add(right);
                row.Children.Add(head);
                row.Children.Add(PercentTrack(pct, fillBrush, track, 11));
                panel.Children.Add(row);
            }
            return panel;
        }

        /// <summary>نوار درصد واقعی: پر شدن متناسب با pct از ۰ تا ۱۰۰.</summary>
        static FrameworkElement PercentTrack(double pct, Brush fill, Brush track, double height)
        {
            pct = Math.Max(0, Math.Min(100, pct));
            var g = new Grid { Height = height };
            var trackBorder = new Border
            {
                Background = track,
                CornerRadius = new CornerRadius(height / 2.0),
                HorizontalAlignment = HorizontalAlignment.Stretch
            };
            g.Children.Add(trackBorder);
            if (pct <= 0.05)
                return g;

            // لایه پرشونده با عرض نسبی از کل
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(pct, GridUnitType.Star) });
            g.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(Math.Max(0.01, 100 - pct), GridUnitType.Star) });
            Grid.SetColumnSpan(trackBorder, 2);
            var bar = new Border
            {
                Background = fill,
                CornerRadius = new CornerRadius(height / 2.0),
                HorizontalAlignment = HorizontalAlignment.Stretch
            };
            Grid.SetColumn(bar, 0);
            g.Children.Add(bar);
            return g;
        }

        public static UIElement Columns(FrameworkElement owner, IList<NamedCount> items, string yTitle)
        {
            if (items == null || items.Count == 0)
                return Empty(owner, "روندی ثبت نشده است.");
            var max = 1;
            foreach (var it in items)
                if (it.Count > max) max = it.Count;
            var axisMax = NiceMax(max);
            var fill = BrushOf(owner, "PrimaryBrush", Color.FromRgb(0x0B, 0x4A, 0x6F));
            var muted = BrushOf(owner, "MutedBrush", Color.FromRgb(0x5C, 0x6B, 0x74));
            var gridLine = BrushOf(owner, "BorderBrush", Color.FromRgb(0xD5, 0xDE, 0xE4));

            var root = new Grid { Height = 196, FlowDirection = FlowDirection.LeftToRight };
            root.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(36) });
            root.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            root.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            root.RowDefinitions.Add(new RowDefinition { Height = new GridLength(28) });

            var axis = new Grid { Margin = new Thickness(0, 4, 4, 0) };
            axis.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            axis.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            axis.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            axis.Children.Add(AxisLabel(axisMax.ToString(), muted, VerticalAlignment.Top));
            var mid = new TextBlock { Text = (axisMax / 2).ToString(), FontSize = 10, Foreground = muted, HorizontalAlignment = HorizontalAlignment.Right, VerticalAlignment = VerticalAlignment.Center };
            Grid.SetRow(mid, 1);
            axis.Children.Add(mid);
            var zero = new TextBlock { Text = "0", FontSize = 10, Foreground = muted, HorizontalAlignment = HorizontalAlignment.Right, VerticalAlignment = VerticalAlignment.Bottom };
            Grid.SetRow(zero, 2);
            axis.Children.Add(zero);
            root.Children.Add(axis);

            var plot = new Grid { Margin = new Thickness(4, 8, 4, 0) };
            Grid.SetColumn(plot, 1);
            for (var g = 0; g < 3; g++)
            {
                plot.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
                var line = new Border { Height = 1, Background = gridLine, VerticalAlignment = VerticalAlignment.Top, Opacity = 0.85 };
                Grid.SetRow(line, g);
                plot.Children.Add(line);
            }
            var bars = new Grid { Margin = new Thickness(0, 0, 0, 0) };
            Grid.SetRowSpan(bars, 3);
            for (var i = 0; i < items.Count; i++)
                bars.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            for (var i = 0; i < items.Count; i++)
            {
                var it = items[i];
                var h = axisMax <= 0 ? 0 : 100.0 * it.Count / axisMax;
                var remain = Math.Max(0.5, 100 - h);
                var cell = new Grid { Margin = new Thickness(3, 0, 3, 0) };
                cell.RowDefinitions.Add(new RowDefinition { Height = new GridLength(remain, GridUnitType.Star) });
                cell.RowDefinitions.Add(new RowDefinition { Height = new GridLength(Math.Max(h, 0.01), GridUnitType.Star) });
                var bar = new Border
                {
                    Background = fill,
                    CornerRadius = new CornerRadius(4, 4, 0, 0),
                    Opacity = it.Count == 0 ? 0.18 : 1,
                    ToolTip = it.Label + " — " + it.Count + (string.IsNullOrEmpty(yTitle) ? " نفر" : " " + yTitle),
                    VerticalAlignment = VerticalAlignment.Stretch
                };
                Grid.SetRow(bar, 1);
                cell.Children.Add(bar);
                Grid.SetColumn(cell, i);
                bars.Children.Add(cell);
            }
            plot.Children.Add(bars);
            root.Children.Add(plot);

            var labels = new Grid { Margin = new Thickness(4, 4, 4, 0) };
            Grid.SetColumn(labels, 1);
            Grid.SetRow(labels, 1);
            for (var i = 0; i < items.Count; i++)
            {
                labels.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
                var lab = new TextBlock
                {
                    Text = ShortLabel(items[i].Label),
                    FontSize = 10,
                    Foreground = muted,
                    HorizontalAlignment = HorizontalAlignment.Center,
                    TextAlignment = TextAlignment.Center,
                    TextTrimming = TextTrimming.CharacterEllipsis
                };
                Grid.SetColumn(lab, i);
                labels.Children.Add(lab);
            }
            root.Children.Add(labels);
            return root;
        }

        public static TextBlock Empty(FrameworkElement owner, string text)
        {
            return new TextBlock
            {
                Text = text,
                Style = owner.TryFindResource("MutedText") as Style,
                TextWrapping = TextWrapping.Wrap,
                Margin = new Thickness(0, 8, 0, 0)
            };
        }

        static TextBlock AxisLabel(string text, Brush fg, VerticalAlignment va)
        {
            return new TextBlock
            {
                Text = text,
                FontSize = 10,
                Foreground = fg,
                HorizontalAlignment = HorizontalAlignment.Right,
                VerticalAlignment = va
            };
        }

        static int NiceMax(int max)
        {
            if (max <= 4) return 4;
            if (max <= 8) return 8;
            if (max <= 10) return 10;
            var step = 5;
            if (max > 40) step = 10;
            if (max > 100) step = 20;
            return ((max + step - 1) / step) * step;
        }

        static string ShortLabel(string label)
        {
            if (string.IsNullOrEmpty(label))
                return "";
            var sp = label.IndexOf(' ');
            var name = sp > 0 ? label.Substring(0, sp) : label;
            return name.Length <= 4 ? name : name.Substring(0, 3);
        }

        static string Pct(int n, int total)
        {
            if (total <= 0)
                return "0";
            return (100.0 * n / total).ToString("0.0", CultureInfo.InvariantCulture);
        }

        static int Sum(IList<NamedCount> items)
        {
            var n = 0;
            if (items == null)
                return 0;
            foreach (var it in items)
                n += it.Count;
            return n;
        }

        static void AddCentered(Canvas canvas, double cx, double cy, string text, double size, FontWeight weight, Brush fg)
        {
            var tb = new TextBlock { Text = text, FontSize = size, FontWeight = weight, Foreground = fg };
            tb.Measure(new Size(220, 80));
            Canvas.SetLeft(tb, cx - tb.DesiredSize.Width / 2);
            Canvas.SetTop(tb, cy - tb.DesiredSize.Height / 2);
            canvas.Children.Add(tb);
        }

        static Path Arc(double cx, double cy, double r, double start, double sweep, Brush stroke, double thickness)
        {
            if (sweep < 0.4) sweep = 0.4;
            if (sweep > 359.9) sweep = 359.9;
            var end = start + sweep;
            var geo = new PathGeometry();
            var fig = new PathFigure { StartPoint = Polar(cx, cy, r, start), IsFilled = false };
            fig.Segments.Add(new ArcSegment(Polar(cx, cy, r, end), new Size(r, r), 0, sweep > 180, SweepDirection.Clockwise, true));
            geo.Figures.Add(fig);
            return new Path { Data = geo, Stroke = stroke, StrokeThickness = thickness, StrokeStartLineCap = PenLineCap.Round, StrokeEndLineCap = PenLineCap.Round, Fill = Brushes.Transparent };
        }

        static Path DonutSlice(double cx, double cy, double outer, double inner, double start, double sweep, Brush fill)
        {
            if (sweep >= 359.9) sweep = 359.9;
            if (sweep < 0.2) sweep = 0.2;
            var end = start + sweep;
            var large = sweep > 180;
            var geo = new PathGeometry();
            var fig = new PathFigure { StartPoint = Polar(cx, cy, inner, start), IsClosed = true };
            fig.Segments.Add(new LineSegment(Polar(cx, cy, outer, start), true));
            fig.Segments.Add(new ArcSegment(Polar(cx, cy, outer, end), new Size(outer, outer), 0, large, SweepDirection.Clockwise, true));
            fig.Segments.Add(new LineSegment(Polar(cx, cy, inner, end), true));
            fig.Segments.Add(new ArcSegment(Polar(cx, cy, inner, start), new Size(inner, inner), 0, large, SweepDirection.Counterclockwise, true));
            geo.Figures.Add(fig);
            return new Path { Data = geo, Fill = fill, Stretch = Stretch.None };
        }

        static Point Polar(double cx, double cy, double r, double angleDeg)
        {
            var rad = angleDeg * Math.PI / 180.0;
            return new Point(cx + r * Math.Cos(rad), cy + r * Math.Sin(rad));
        }
    }
}
