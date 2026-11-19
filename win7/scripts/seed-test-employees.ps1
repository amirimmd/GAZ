param(
    [int]$Active = 300,
    [int]$Inactive = 60,
    [int]$Incomplete = 5,
    [string]$DbPath = "",
    [switch]$Keep,
    [switch]$PeopleOnly
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$Project = Join-Path $Root "tools\SeedTestData\SeedTestData.csproj"

if (-not $DbPath) {
    $candidates = Get-ChildItem (Join-Path $Root "dist") -Directory -Filter "QaemshahrPortable_*" -ErrorAction SilentlyContinue |
        Sort-Object Name
    if ($candidates) {
        $DbPath = Join-Path $candidates[-1].FullName "AppData\data\gaz_hrms.db"
    }
}

if (-not $DbPath -or -not (Test-Path $DbPath)) {
    throw "Database not found. Build portable first or pass -DbPath."
}

Get-Process -Name "Qaemshahr" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

Write-Host "Building seed tool..."
dotnet build $Project -c Release | Out-Host
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$argsList = @(
    "--db", $DbPath,
    "--active", "$Active",
    "--inactive", "$Inactive",
    "--incomplete", "$Incomplete"
)
if ($Keep) { $argsList += "--keep" }
if ($PeopleOnly) { $argsList += "--people-only" }

$exe = Join-Path $Root "tools\SeedTestData\bin\Release\net48\SeedTestData.exe"
Write-Host "Seeding full test scenario into $DbPath"
& $exe @argsList
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Done."
