#Requires -Version 3.0
$ErrorActionPreference = "Stop"
Add-Type -ReferencedAssemblies @("System.Drawing") -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;

public static class GazIcoWriter
{
    public static void Write(string pngPath, string icoPath)
    {
        int[] sizes = { 16, 24, 32, 48, 64, 256 };
        var parts = new List<byte[]>();
        using (var src = Image.FromFile(pngPath))
        {
            foreach (var size in sizes)
            {
                using (var bmp = new Bitmap(size, size, PixelFormat.Format32bppArgb))
                using (var g = Graphics.FromImage(bmp))
                {
                    g.Clear(Color.Transparent);
                    g.InterpolationMode = InterpolationMode.HighQualityBicubic;
                    g.SmoothingMode = SmoothingMode.HighQuality;
                    g.PixelOffsetMode = PixelOffsetMode.HighQuality;
                    g.CompositingQuality = CompositingQuality.HighQuality;
                    float scale = Math.Min((float)size / src.Width, (float)size / src.Height);
                    int nw = Math.Max(1, (int)Math.Round(src.Width * scale));
                    int nh = Math.Max(1, (int)Math.Round(src.Height * scale));
                    g.DrawImage(src, (size - nw) / 2, (size - nh) / 2, nw, nh);
                    parts.Add(EncodeDib(bmp));
                }
            }
        }
        using (var fs = File.Create(icoPath))
        using (var bw = new BinaryWriter(fs))
        {
            bw.Write((short)0);
            bw.Write((short)1);
            bw.Write((short)parts.Count);
            int offset = 6 + 16 * parts.Count;
            for (int i = 0; i < parts.Count; i++)
            {
                int dim = sizes[i];
                bw.Write((byte)(dim >= 256 ? 0 : dim));
                bw.Write((byte)(dim >= 256 ? 0 : dim));
                bw.Write((byte)0);
                bw.Write((byte)0);
                bw.Write((short)1);
                bw.Write((short)32);
                bw.Write(parts[i].Length);
                bw.Write(offset);
                offset += parts[i].Length;
            }
            foreach (var p in parts)
                bw.Write(p);
        }
    }

    static byte[] EncodeDib(Bitmap bmp)
    {
        int w = bmp.Width, h = bmp.Height;
        var data = bmp.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        int stride = data.Stride;
        var topDown = new byte[stride * h];
        Marshal.Copy(data.Scan0, topDown, 0, topDown.Length);
        bmp.UnlockBits(data);
        int row = w * 4;
        int maskStride = ((w + 31) / 32) * 4;
        using (var ms = new MemoryStream(40 + row * h + maskStride * h))
        using (var bw = new BinaryWriter(ms))
        {
            bw.Write(40);
            bw.Write(w);
            bw.Write(h * 2);
            bw.Write((short)1);
            bw.Write((short)32);
            bw.Write(0);
            bw.Write(0);
            bw.Write(0);
            bw.Write(0);
            bw.Write(0);
            bw.Write(0);
            for (int y = h - 1; y >= 0; y--)
                bw.Write(topDown, y * stride, row);
            bw.Write(new byte[maskStride * h]);
            return ms.ToArray();
        }
    }
}
"@

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Png = Join-Path $Root "src\Qaemshahr.App\Assets\organization_logo.png"
$Ico = Join-Path $Root "src\Qaemshahr.App\Assets\app.ico"
if (-not (Test-Path $Png)) { throw "Logo not found: $Png" }
[GazIcoWriter]::Write($Png, $Ico)
Write-Host "Wrote Win32 ICO: $Ico"
