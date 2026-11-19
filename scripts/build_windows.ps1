# Build Windows release package
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..

flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build windows --release --dart-define=use_arabic=true

$src = "build\windows\x64\runner\Release"
$dst = "dist\windows\gaz_hrms"
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Copy-Item -Recurse -Force "$src\*" $dst
Write-Host "Windows build staged at $dst"
