# Build release APK for Gas-Qaemshahr HRMS and copy to dist/android
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

$env:JAVA_HOME = if (Test-Path "C:\Users\Mostafa\AppData\Local\Java\jdk-17\bin\java.exe") {
  "C:\Users\Mostafa\AppData\Local\Java\jdk-17"
} elseif (Test-Path "C:\Program Files\Java\jdk-17\bin\java.exe") {
  "C:\Program Files\Java\jdk-17"
} else {
  $env:JAVA_HOME
}

$env:ANDROID_HOME = if (Test-Path "$env:LOCALAPPDATA\Android\Sdk") {
  "$env:LOCALAPPDATA\Android\Sdk"
} else {
  $env:ANDROID_HOME
}
$env:ANDROID_SDK_ROOT = $env:ANDROID_HOME
$env:PATH = "C:\src\flutter\bin;$env:JAVA_HOME\bin;$env:ANDROID_HOME\platform-tools;$env:ANDROID_HOME\cmdline-tools\latest\bin;" + $env:PATH
$env:FLUTTER_STORAGE_BASE_URL = "https://storage.flutter-io.cn"
$env:PUB_HOSTED_URL = "https://pub.flutter-io.cn"

Write-Host "JAVA_HOME=$env:JAVA_HOME"
Write-Host "ANDROID_HOME=$env:ANDROID_HOME"

C:\src\flutter\bin\flutter.bat config --android-sdk $env:ANDROID_HOME
C:\src\flutter\bin\flutter.bat pub get
C:\src\flutter\bin\flutter.bat test
C:\src\flutter\bin\flutter.bat build apk --release --dart-define=use_arabic=true
if ($LASTEXITCODE -ne 0) {
  throw "flutter build apk failed with exit code $LASTEXITCODE"
}

$src = "build\app\outputs\flutter-apk\app-release.apk"
if (-not (Test-Path $src)) {
  throw "APK build failed: output not found at $src"
}

$dstDir = "dist\android"
New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
$dst = Join-Path $dstDir "Gaz_Qaemshahr_v1.0.7.apk"
Copy-Item -Force $src $dst
Write-Host ""
Write-Host "APK ready:"
Write-Host (Resolve-Path $dst)
Get-Item $dst | Format-List FullName, Length, LastWriteTime
