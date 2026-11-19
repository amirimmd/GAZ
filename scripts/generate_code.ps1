# Generate Drift + Riverpod code
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot\..
dart run build_runner build --delete-conflicting-outputs
