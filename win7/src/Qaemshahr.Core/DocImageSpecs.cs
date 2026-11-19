using Qaemshahr.Core;

namespace Qaemshahr.Core
{
    /// <summary>ابعاد پیشنهادی برش/چاپ تصویر مدارک شناسایی.</summary>
    public static class DocImageSpecs
    {
        // شناسنامه: صفحه A4 عمودی ≈ 150dpi
        public const int BirthWidth = 1240;
        public const int BirthHeight = 1754;
        public const double BirthAspect = 210.0 / 297.0; // ≈ 0.707

        // کارت ملی: نسبت کارت بانکی/ملی افقی
        public const int NationalWidth = 1000;
        public const int NationalHeight = 630;
        public const double NationalAspect = 85.6 / 54.0; // ≈ 1.585

        // عکس پرسنلی ۴×۳
        public const int PhotoWidth = 360;
        public const int PhotoHeight = 480;
        public const double PhotoAspect = 3.0 / 4.0;

        public static string HintForKind(string kind)
        {
            kind = DocumentKinds.Normalize(kind);
            if (kind == DocumentKinds.Birth)
                return "پیشنهاد چاپ شناسنامه: نسبت A4 عمودی — حدود "
                    + BirthWidth + "×" + BirthHeight
                    + " پیکسل. داخل کادر فقط همان صفحه‌ای که باید چاپ شود را بگذارید.";
            if (kind == DocumentKinds.National)
                return "پیشنهاد چاپ کارت ملی: نسبت کارت افقی — حدود "
                    + NationalWidth + "×" + NationalHeight
                    + " پیکسل. دو طرف کارت را داخل کادر نگه دارید.";
            return "برای سایر اسناد نسبت آزاد است؛ پیشنهاد حداقل ضلع بلند ۱۰۰۰ پیکسل برای چاپ واضح.";
        }

        public static double? AspectForKind(string kind)
        {
            kind = DocumentKinds.Normalize(kind);
            if (kind == DocumentKinds.Birth)
                return BirthAspect;
            if (kind == DocumentKinds.National)
                return NationalAspect;
            return null;
        }

        public static void OutputSizeForKind(string kind, out int width, out int height)
        {
            kind = DocumentKinds.Normalize(kind);
            if (kind == DocumentKinds.Birth)
            {
                width = BirthWidth;
                height = BirthHeight;
                return;
            }
            if (kind == DocumentKinds.National)
            {
                width = NationalWidth;
                height = NationalHeight;
                return;
            }
            width = 1200;
            height = 1600;
        }
    }
}
