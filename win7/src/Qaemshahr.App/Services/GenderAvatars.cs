using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;
using Qaemshahr.Core;
using Qaemshahr.Core.Models;

namespace Qaemshahr.App.Services
{
    internal static class GenderAvatars
    {
        const string MalePath =
            "M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z";
        const string FemalePath =
            "M12,2A3.5,3.5 0 0,1 15.5,5.5A3.5,3.5 0 0,1 12,9A3.5,3.5 0 0,1 8.5,5.5A3.5,3.5 0 0,1 12,2M12,11C13.5,11 15.4,11.4 16.8,12.1L18.5,21H15.2L13.8,15H10.2L8.8,21H5.5L7.2,12.1C8.6,11.4 10.5,11 12,11Z";
        const string NeutralPath =
            "M12,4A4,4 0 0,1 16,8A4,4 0 0,1 12,12A4,4 0 0,1 8,8A4,4 0 0,1 12,4M12,14C16.42,14 20,15.79 20,18V20H4V18C4,15.79 7.58,14 12,14Z";

        public static FrameworkElement ForGender(string gender, double iconSize = 34)
        {
            string pathData;
            Color tint;
            Color icon;
            string tip;
            if (HrLookups.IsFemaleGender(gender))
            {
                pathData = FemalePath;
                tint = Color.FromRgb(0xF3, 0xE8, 0xEF);
                icon = Color.FromRgb(0x8E, 0x45, 0x6D);
                tip = "خانم — بدون عکس پرسنلی";
            }
            else if (HrLookups.IsMaleGender(gender))
            {
                pathData = MalePath;
                tint = Color.FromRgb(0xE4, 0xEE, 0xF5);
                icon = Color.FromRgb(0x0B, 0x4A, 0x6F);
                tip = "آقا — بدون عکس پرسنلی";
            }
            else
            {
                pathData = NeutralPath;
                tint = Color.FromRgb(0xEE, 0xF3, 0xF6);
                icon = Color.FromRgb(0x6B, 0x7C, 0x85);
                tip = "بدون عکس پرسنلی";
            }

            var path = new Path
            {
                Data = Geometry.Parse(pathData),
                Fill = new SolidColorBrush(icon),
                Stretch = Stretch.Uniform,
                Width = iconSize,
                Height = iconSize,
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Center
            };

            return new Border
            {
                Background = new SolidColorBrush(tint),
                ToolTip = tip,
                Child = new Viewbox
                {
                    Width = iconSize + 2,
                    Height = iconSize + 2,
                    Stretch = Stretch.Uniform,
                    Child = path
                }
            };
        }

        public static FrameworkElement ForEmployee(Employee emp, double iconSize = 34)
        {
            return ForGender(emp == null ? null : emp.Gender, iconSize);
        }
    }
}
