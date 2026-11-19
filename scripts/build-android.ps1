#Requires -Version 5.1
param(
    [switch]$SplitAbi
)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$jdk = Get-ChildItem "C:\Program Files\Microsoft" -Directory -Filter "jdk-17*" -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName
if (-not $jdk) {
    throw "JDK 17 not found. Install Microsoft OpenJDK 17 first."
}
$flutter = "C:\src\flutter\bin"
if (-not (Test-Path "$flutter\flutter.bat")) {
    throw "Flutter not found at $flutter"
}

$env:JAVA_HOME = $jdk
$env:ANDROID_HOME = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:Path = "$jdk\bin;$flutter;" + $env:Path

# file_picker 8.3.7 ships compileSdk 34; lifecycle needs 36.
$fpGradle = Join-Path $env:LOCALAPPDATA "Pub\Cache\hosted\pub.dev\file_picker-8.3.7\android\build.gradle"
if (Test-Path $fpGradle) {
    $txt = Get-Content $fpGradle -Raw
    if ($txt -match "compileSdk\s+34") {
        Set-Content -Path $fpGradle -Value ($txt -replace "compileSdk\s+34", "compileSdk 36") -NoNewline
        Write-Host "Patched file_picker compileSdk -> 36"
    }
}

Write-Host "Building release APK..."
if ($SplitAbi) {
    & flutter build apk --release --split-per-abi
} else {
    & flutter build apk --release
}
if ($LASTEXITCODE -ne 0) { throw "flutter build apk failed" }

$dist = Join-Path $Root "dist"
New-Item -ItemType Directory -Force -Path $dist | Out-Null
$src = Join-Path $Root "build\app\outputs\flutter-apk\app-release.apk"
$ver = (Select-String -Path (Join-Path $Root "pubspec.yaml") -Pattern "^version:\s*([^\+]+)").Matches.Groups[1].Value.Trim()
$dest = Join-Path $dist "Qaemshahr_Android_$ver.apk"
Copy-Item $src $dest -Force
Write-Host ""
Write-Host "Done."
Write-Host "APK: $dest"
