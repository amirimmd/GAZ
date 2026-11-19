#Requires -Version 3.0
# Downloads offline Win7 prerequisites into installer\redist
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$RedistDir = Join-Path $Root "installer\redist"
New-Item -ItemType Directory -Force -Path $RedistDir | Out-Null

$files = @(
    @{
        Name = "ndp48-x86-x64-AllOS-ENU.exe"
        Url  = "https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe"
        AltUrl = "https://go.microsoft.com/fwlink/?linkid=2088631"
        MinBytes = 50000000
    },
    @{
        Name = "vc_redist.x86.exe"
        Url  = "https://aka.ms/vs/17/release/vc_redist.x86.exe"
        MinBytes = 5000000
    },
    @{
        Name = "windows6.1-kb4490628-x86.msu"
        Url  = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2019/03/windows6.1-kb4490628-x86_3cdb3df55b9cd7ef7fcb24fc4e237ea287ad0992.msu"
        MinBytes = 3000000
    },
    @{
        Name = "windows6.1-kb4490628-x64.msu"
        Url  = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2019/03/windows6.1-kb4490628-x64_d3de52d6987f7c8bdc2c015dca69eac96047c76e.msu"
        MinBytes = 5000000
    },
    @{
        Name = "windows6.1-kb4474419-v3-x86.msu"
        Url  = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2019/09/windows6.1-kb4474419-v3-x86_0f687d50402790f340087c576886501b3223bec6.msu"
        MinBytes = 10000000
    },
    @{
        Name = "windows6.1-kb4474419-v3-x64.msu"
        Url  = "https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/secu/2019/09/windows6.1-kb4474419-v3-x64_b5614c6cea5cb4e198717789633dca16308ef79c.msu"
        MinBytes = 10000000
    }
)

function Get-File([string]$Url, [string]$Dest, [long]$MinBytes, [string]$AltUrl = $null) {
    if ((Test-Path $Dest) -and ((Get-Item $Dest).Length -ge $MinBytes)) {
        Write-Host "OK (cached): $(Split-Path $Dest -Leaf)"
        return $true
    }
    $urls = @($Url)
    if (-not [string]::IsNullOrWhiteSpace($AltUrl)) { $urls += $AltUrl }
    foreach ($u in $urls) {
        Write-Host "Downloading: $(Split-Path $Dest -Leaf)"
        Write-Host "  from: $u"
        try {
            $tmp = $Dest + ".partial"
            if (Test-Path $tmp) { Remove-Item $tmp -Force }
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("User-Agent", "Mozilla/5.0 QaemshahrBuild")
            $wc.DownloadFile($u, $tmp)
            $len = (Get-Item $tmp).Length
            if ($len -lt $MinBytes) {
                Remove-Item $tmp -Force -ErrorAction SilentlyContinue
                throw "Downloaded file too small ($len bytes)"
            }
            Move-Item $tmp $Dest -Force
            Write-Host "Saved: $Dest ($len bytes)"
            return $true
        } catch {
            Write-Warning "Failed: $($_.Exception.Message)"
        }
    }
    return $false
}

$ok = $true
foreach ($f in $files) {
    $dest = Join-Path $RedistDir $f.Name
    $alt = $null
    if ($f.ContainsKey("AltUrl")) { $alt = $f.AltUrl }
    if (-not (Get-File -Url $f.Url -Dest $dest -MinBytes $f.MinBytes -AltUrl $alt)) {
        $ok = $false
    }
}

$readme = @"
پیش‌نیازهای آفلاین ویندوز ۷ (کنار فایل نصب کپی می‌شوند)

  ndp48-x86-x64-AllOS-ENU.exe     — .NET Framework 4.8
  vc_redist.x86.exe               — Visual C++ 2015-2022 (x86)
  windows6.1-kb4490628-x86.msu   — Servicing Stack (x86) برای Win7
  windows6.1-kb4490628-x64.msu   — Servicing Stack (x64) برای Win7
  windows6.1-kb4474419-v3-x86.msu — پشتیبانی SHA-2 (x86)
  windows6.1-kb4474419-v3-x64.msu — پشتیبانی SHA-2 (x64)

ستاپ هنگام نصب، از پوشه redist کنار خودش این‌ها را به‌ترتیب نصب می‌کند.
"@
Set-Content -Path (Join-Path $RedistDir "README.txt") -Value $readme -Encoding UTF8

if (-not $ok) {
    Write-Warning "Some redistributables are missing. Place them manually in: $RedistDir"
    exit 1
}
Write-Host "All redistributables ready in $RedistDir"
exit 0
