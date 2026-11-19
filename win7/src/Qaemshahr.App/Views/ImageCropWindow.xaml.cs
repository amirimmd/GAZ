using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media.Imaging;
using Qaemshahr.Core;
using MediaPoint = System.Windows.Point;

namespace Qaemshahr.App.Views
{
    public partial class ImageCropWindow : Window
    {
        readonly string _sourcePath;
        readonly double? _aspect;
        readonly int _outW;
        readonly int _outH;
        BitmapSource _bitmap;
        double _imgLeft;
        double _imgTop;
        double _imgW;
        double _imgH;
        double _cropX;
        double _cropY;
        double _cropW;
        double _cropH;
        bool _dragging;
        string _dragMode;
        MediaPoint _last;

        public string ResultPath { get; private set; }

        public ImageCropWindow(string sourcePath, string kind)
        {
            InitializeComponent();
            _sourcePath = sourcePath;
            _aspect = DocImageSpecs.AspectForKind(kind);
            DocImageSpecs.OutputSizeForKind(kind, out _outW, out _outH);
            HintText.Text = DocImageSpecs.HintForKind(kind);
            Owner = Application.Current == null ? null : Application.Current.MainWindow;
            Loaded += (s, e) => LoadImage();
        }

        void LoadImage()
        {
            var bip = new BitmapImage();
            bip.BeginInit();
            bip.CacheOption = BitmapCacheOption.OnLoad;
            bip.UriSource = new Uri(_sourcePath);
            bip.EndInit();
            bip.Freeze();
            _bitmap = bip;
            PreviewImage.Source = bip;
            Dispatcher.BeginInvoke(new Action(ResetCrop), System.Windows.Threading.DispatcherPriority.Loaded);
        }

        void OnStageSizeChanged(object sender, SizeChangedEventArgs e)
        {
            LayoutImage();
            ClampCrop();
            DrawOverlay();
        }

        void LayoutImage()
        {
            if (_bitmap == null || Stage.ActualWidth < 2 || Stage.ActualHeight < 2)
                return;
            var sw = Stage.ActualWidth;
            var sh = Stage.ActualHeight;
            var bw = _bitmap.PixelWidth;
            var bh = _bitmap.PixelHeight;
            var scale = Math.Min(sw / bw, sh / bh);
            _imgW = bw * scale;
            _imgH = bh * scale;
            _imgLeft = (sw - _imgW) / 2.0;
            _imgTop = (sh - _imgH) / 2.0;
            PreviewImage.Width = _imgW;
            PreviewImage.Height = _imgH;
            Overlay.Width = sw;
            Overlay.Height = sh;
        }

        void ResetCrop()
        {
            LayoutImage();
            if (_imgW < 2 || _imgH < 2)
                return;
            if (_aspect == null || _aspect.Value <= 0)
            {
                _cropW = _imgW * 0.86;
                _cropH = _imgH * 0.86;
            }
            else
            {
                var a = _aspect.Value;
                if (_imgW / _imgH > a)
                {
                    _cropH = _imgH * 0.9;
                    _cropW = _cropH * a;
                }
                else
                {
                    _cropW = _imgW * 0.9;
                    _cropH = _cropW / a;
                }
            }
            _cropX = _imgLeft + (_imgW - _cropW) / 2.0;
            _cropY = _imgTop + (_imgH - _cropH) / 2.0;
            ClampCrop();
            DrawOverlay();
        }

        void ClampCrop()
        {
            if (_cropW > _imgW) _cropW = _imgW;
            if (_cropH > _imgH) _cropH = _imgH;
            if (_aspect != null && _aspect.Value > 0)
            {
                var a = _aspect.Value;
                if (_cropW / _cropH > a)
                    _cropW = _cropH * a;
                else
                    _cropH = _cropW / a;
                if (_cropW > _imgW)
                {
                    _cropW = _imgW;
                    _cropH = _cropW / a;
                }
                if (_cropH > _imgH)
                {
                    _cropH = _imgH;
                    _cropW = _cropH * a;
                }
            }
            if (_cropX < _imgLeft) _cropX = _imgLeft;
            if (_cropY < _imgTop) _cropY = _imgTop;
            if (_cropX + _cropW > _imgLeft + _imgW) _cropX = _imgLeft + _imgW - _cropW;
            if (_cropY + _cropH > _imgTop + _imgH) _cropY = _imgTop + _imgH - _cropH;
            SizeText.Text = "ناحیه انتخاب‌شده روی تصویر نمایشی: "
                + Math.Round(_cropW) + "×" + Math.Round(_cropH)
                + "  |  خروجی ذخیره‌شده حدود: " + _outW + "×" + _outH + " پیکسل";
        }

        void DrawOverlay()
        {
            var sw = Overlay.ActualWidth;
            var sh = Overlay.ActualHeight;
            SetRect(DimLeft, 0, 0, Math.Max(0, _cropX), sh);
            SetRect(DimTop, _cropX, 0, _cropW, Math.Max(0, _cropY));
            SetRect(DimRight, _cropX + _cropW, 0, Math.Max(0, sw - (_cropX + _cropW)), sh);
            SetRect(DimBottom, _cropX, _cropY + _cropH, _cropW, Math.Max(0, sh - (_cropY + _cropH)));
            SetRect(CropRect, _cropX, _cropY, _cropW, _cropH);
        }

        static void SetRect(System.Windows.Shapes.Rectangle rect, double x, double y, double w, double h)
        {
            System.Windows.Controls.Canvas.SetLeft(rect, x);
            System.Windows.Controls.Canvas.SetTop(rect, y);
            rect.Width = Math.Max(0, w);
            rect.Height = Math.Max(0, h);
        }

        void OnOverlayDown(object sender, MouseButtonEventArgs e)
        {
            _last = e.GetPosition(Overlay);
            _dragMode = HitMode(_last);
            _dragging = true;
            Overlay.CaptureMouse();
            e.Handled = true;
        }

        void OnOverlayMove(object sender, MouseEventArgs e)
        {
            var p = e.GetPosition(Overlay);
            if (!_dragging)
            {
                Overlay.Cursor = CursorFor(HitMode(p));
                return;
            }
            var dx = p.X - _last.X;
            var dy = p.Y - _last.Y;
            _last = p;
            ApplyDrag(dx, dy);
            ClampCrop();
            DrawOverlay();
        }

        void OnOverlayUp(object sender, MouseEventArgs e)
        {
            if (!_dragging)
                return;
            _dragging = false;
            Overlay.ReleaseMouseCapture();
        }

        string HitMode(MediaPoint p)
        {
            const double edge = 12;
            var inside = p.X >= _cropX && p.X <= _cropX + _cropW && p.Y >= _cropY && p.Y <= _cropY + _cropH;
            if (!inside)
                return "none";
            var nearL = Math.Abs(p.X - _cropX) <= edge;
            var nearR = Math.Abs(p.X - (_cropX + _cropW)) <= edge;
            var nearT = Math.Abs(p.Y - _cropY) <= edge;
            var nearB = Math.Abs(p.Y - (_cropY + _cropH)) <= edge;
            if (nearL && nearT) return "nw";
            if (nearR && nearT) return "ne";
            if (nearL && nearB) return "sw";
            if (nearR && nearB) return "se";
            if (nearL) return "w";
            if (nearR) return "e";
            if (nearT) return "n";
            if (nearB) return "s";
            return "move";
        }

        static Cursor CursorFor(string mode)
        {
            switch (mode)
            {
                case "nw":
                case "se": return Cursors.SizeNWSE;
                case "ne":
                case "sw": return Cursors.SizeNESW;
                case "n":
                case "s": return Cursors.SizeNS;
                case "e":
                case "w": return Cursors.SizeWE;
                case "move": return Cursors.SizeAll;
                default: return Cursors.Arrow;
            }
        }

        void ApplyDrag(double dx, double dy)
        {
            if (_dragMode == "move")
            {
                _cropX += dx;
                _cropY += dy;
                return;
            }
            if (_dragMode == "none")
                return;
            var a = _aspect;
            var left = _cropX;
            var top = _cropY;
            var right = _cropX + _cropW;
            var bottom = _cropY + _cropH;
            if (_dragMode.Contains("w")) left += dx;
            if (_dragMode.Contains("e")) right += dx;
            if (_dragMode.Contains("n")) top += dy;
            if (_dragMode.Contains("s")) bottom += dy;
            var w = Math.Max(40, right - left);
            var h = Math.Max(40, bottom - top);
            if (a != null && a.Value > 0)
            {
                if (_dragMode == "n" || _dragMode == "s" || _dragMode == "w" || _dragMode == "e")
                {
                    if (_dragMode == "n" || _dragMode == "s")
                        w = h * a.Value;
                    else
                        h = w / a.Value;
                }
                else
                {
                    if (w / h > a.Value)
                        w = h * a.Value;
                    else
                        h = w / a.Value;
                }
                if (_dragMode.Contains("w")) left = right - w;
                if (_dragMode.Contains("n")) top = bottom - h;
                if (!_dragMode.Contains("w") && !_dragMode.Contains("e")) left = _cropX + (_cropW - w) / 2;
                if (!_dragMode.Contains("n") && !_dragMode.Contains("s")) top = _cropY + (_cropH - h) / 2;
            }
            _cropX = left;
            _cropY = top;
            _cropW = w;
            _cropH = h;
        }

        void OnOk(object sender, RoutedEventArgs e)
        {
            try
            {
                ResultPath = ExportCropped();
                DialogResult = true;
                Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show("برش تصویر ناموفق بود.\n" + ex.Message, AppConstants.AppNameFa);
            }
        }

        void OnCancel(object sender, RoutedEventArgs e)
        {
            DialogResult = false;
            Close();
        }

        string ExportCropped()
        {
            using (var src = new Bitmap(_sourcePath))
            {
                var scaleX = src.Width / _imgW;
                var scaleY = src.Height / _imgH;
                var x = (int)Math.Round((_cropX - _imgLeft) * scaleX);
                var y = (int)Math.Round((_cropY - _imgTop) * scaleY);
                var w = (int)Math.Round(_cropW * scaleX);
                var h = (int)Math.Round(_cropH * scaleY);
                if (x < 0) x = 0;
                if (y < 0) y = 0;
                if (x + w > src.Width) w = src.Width - x;
                if (y + h > src.Height) h = src.Height - y;
                if (w < 2 || h < 2)
                    throw new InvalidOperationException("ناحیه برش خیلی کوچک است");

                using (var cropped = new Bitmap(w, h))
                using (var g = Graphics.FromImage(cropped))
                {
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.DrawImage(src, new Rectangle(0, 0, w, h), new Rectangle(x, y, w, h), GraphicsUnit.Pixel);

                    var targetW = _outW;
                    var targetH = _outH;
                    if (_aspect == null)
                    {
                        var maxSide = 1600.0;
                        var scale = Math.Min(1.0, maxSide / Math.Max(w, h));
                        targetW = Math.Max(1, (int)Math.Round(w * scale));
                        targetH = Math.Max(1, (int)Math.Round(h * scale));
                    }

                    using (var fitted = new Bitmap(targetW, targetH))
                    using (var g2 = Graphics.FromImage(fitted))
                    {
                        g2.Clear(Color.White);
                        g2.InterpolationMode = InterpolationMode.HighQualityBicubic;
                        g2.DrawImage(cropped, new Rectangle(0, 0, targetW, targetH));
                        var path = Path.Combine(Path.GetTempPath(),
                            "qaemshahr_crop_" + Guid.NewGuid().ToString("N") + ".jpg");
                        EncodeJpeg(fitted, path, 90L);
                        return path;
                    }
                }
            }
        }

        static void EncodeJpeg(Bitmap bmp, string path, long quality)
        {
            ImageCodecInfo jpeg = null;
            foreach (var c in ImageCodecInfo.GetImageEncoders())
            {
                if (c.MimeType == "image/jpeg")
                {
                    jpeg = c;
                    break;
                }
            }
            if (jpeg == null)
            {
                bmp.Save(path, ImageFormat.Jpeg);
                return;
            }
            using (var ep = new EncoderParameters(1))
            {
                ep.Param[0] = new EncoderParameter(Encoder.Quality, quality);
                bmp.Save(path, jpeg, ep);
            }
        }
    }
}
