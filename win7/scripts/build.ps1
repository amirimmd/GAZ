#Requires -Version 3.0
param(
    [switch]$Light,
    [switch]$Portable
)
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$Iscc = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
$Configuration = "Release"
$OutApp = Join-Path $Root "dist\app"
$OutDist = Join-Path $Root "dist"
$RedistDir = Join-Path $Root "installer\redist"
$Version = "2.3.12"
$SetupName = "QaemshahrSetup_$Version.exe"
$PortableName = "QaemshahrPortable_$Version"

New-Item -ItemType Directory -Force -Path $OutApp | Out-Null
New-Item -ItemType Directory -Force -Path $OutDist | Out-Null

if ($Portable -or $Light) {
    Write-Host "Skipping redistributables download."
}
else {
    New-Item -ItemType Directory -Force -Path $RedistDir | Out-Null
    Write-Host "Preparing Windows 7 offline redistributables..."
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root "scripts\prepare-redist.ps1")
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Some redistributables missing - setup may fail on clean Win7. Continuing build."
    }
}

Write-Host "Building taskbar icon from organization logo..."
& powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root "scripts\make-app-icon.ps1")
if ($LASTEXITCODE -ne 0) { throw "icon generation failed" }

Write-Host "Restoring and publishing x86..."
dotnet restore (Join-Path $Root "Qaemshahr.sln")
if ($LASTEXITCODE -ne 0) { throw "restore failed" }

dotnet publish (Join-Path $Root "src\Qaemshahr.App\Qaemshahr.App.csproj") `
    -c $Configuration `
    -o $OutApp `
    -p:PlatformTarget=x86 `
    -p:Prefer32Bit=true `
    -p:DebugType=None `
    -p:DebugSymbols=false `
    --no-self-contained
if ($LASTEXITCODE -ne 0) { throw "publish failed" }

Get-ChildItem $OutApp -Filter "SQLite.Interop.dll" -Recurse | ForEach-Object {
    $dest = Join-Path $OutApp "SQLite.Interop.dll"
    if ($_.DirectoryName -match '\\x64\\') { return }
    if ($_.FullName -eq $dest) { return }
    Copy-Item $_.FullName $dest -Force
}

$x86Interop = Get-ChildItem $OutApp -Filter "SQLite.Interop.dll" -Recurse | Where-Object { $_.DirectoryName -match '\\x86\\' } | Select-Object -First 1
if ($x86Interop) {
    $dest = Join-Path $OutApp "SQLite.Interop.dll"
    if ($x86Interop.FullName -ne $dest) {
        Copy-Item $x86Interop.FullName $dest -Force
    }
}

function Remove-PublishJunk {
    param([string]$Dir)
    Get-ChildItem $Dir -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        $_.Extension -in @(".pdb", ".dylib", ".so")
    } | Remove-Item -Force -ErrorAction SilentlyContinue

    foreach ($junkDir in @("osx", "osx-arm64", "osx-x64", "linux-x64", "linux-arm64", "linux-arm", "browser-wasm", "arm64", "x64")) {
        Get-ChildItem $Dir -Directory -Recurse -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -eq $junkDir } |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Keep root SQLite.Interop.dll; nested platform folders for non-x86 are removed above.
    # Also drop empty runtimes tree if present.
    $runtimes = Join-Path $Dir "runtimes"
    if (Test-Path $runtimes) {
        Remove-Item $runtimes -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Remove-PublishJunk -Dir $OutApp

Copy-Item (Join-Path $Root "docs\INSTALL-WIN7.txt") (Join-Path $OutApp "INSTALL-WIN7.txt") -Force

function Reset-EmptyAppData {
    param([string]$AppDataRoot)
    if (Test-Path $AppDataRoot) {
        Remove-Item $AppDataRoot -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $AppDataRoot | Out-Null
    foreach ($sub in @("data", "secure_documents", "photos", "keys", "logs", "backups", "local")) {
        New-Item -ItemType Directory -Force -Path (Join-Path $AppDataRoot $sub) | Out-Null
    }
}

function Publish-PortablePackage {
    param([string]$SourceApp, [string]$DestRoot, [string]$Ver)

    # ساخت در پوشه موقت، سپس جایگزینی مقصد (AppData موجود جدا نگه داشته می‌شود).
    $staging = Join-Path $OutDist ("_staging_portable_" + [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $staging | Out-Null
    try {
        Copy-Item (Join-Path $SourceApp "*") $staging -Recurse -Force
        Set-Content -Path (Join-Path $staging "portable.flag") -Value "portable=1`r`nversion=$Ver`r`n" -Encoding ASCII
        Copy-Item (Join-Path $Root "docs\PORTABLE-WIN7.txt") (Join-Path $staging "README-PORTABLE.txt") -Force
        Copy-Item (Join-Path $Root "scripts\update-portable.ps1") (Join-Path $staging "update-portable.ps1") -Force

        $instDoc = Join-Path $staging "INSTALL-WIN7.txt"
        if (Test-Path $instDoc) { Remove-Item $instDoc -Force }

        Remove-PublishJunk -Dir $staging
        Reset-EmptyAppData -AppDataRoot (Join-Path $staging "AppData")

        if (Test-Path $DestRoot) {
            $existingAppData = Join-Path $DestRoot "AppData"
            if (Test-Path $existingAppData) {
                $backupName = "AppData_PRESERVED_" + (Get-Date -Format "yyyyMMdd_HHmmss")
                $backupPath = Join-Path $OutDist $backupName
                Write-Warning ("Existing AppData found in {0} - moved to {1} (not included in package)." -f $DestRoot, $backupPath)
                Move-Item $existingAppData $backupPath -Force
            }
            Remove-Item $DestRoot -Recurse -Force
        }

        New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null
        Copy-Item (Join-Path $staging "*") $DestRoot -Recurse -Force
        Reset-EmptyAppData -AppDataRoot (Join-Path $DestRoot "AppData")
    }
    finally {
        if (Test-Path $staging) { Remove-Item $staging -Recurse -Force -ErrorAction SilentlyContinue }
    }
}

$PortableDir = Join-Path $OutDist $PortableName
Publish-PortablePackage -SourceApp $OutApp -DestRoot $PortableDir -Ver $Version
Write-Host "Portable folder ready: $PortableDir"

if ($Portable) {
    Write-Host ""
    Write-Host "Done (portable package only)."
    Write-Host "Copy to USB: $PortableDir"
    Write-Host 'To update an existing USB: .\scripts\update-portable.ps1 -Source "NEW_PACKAGE" -Target "USB_FOLDER"'
    exit 0
}

if (-not (Test-Path $Iscc)) {
    Write-Warning "Inno Setup 6 not found - app published to dist\app ; portable also ready"
    exit 0
}

$issArgs = @((Join-Path $Root "installer\Qaemshahr.iss"))
if ($Light) {
    $issArgs = @("/DLightBuild=1") + $issArgs
}
& $Iscc @issArgs
if ($LASTEXITCODE -ne 0) { throw "Inno Setup failed" }

$DistRedist = Join-Path $OutDist "redist"
if ($Light) {
    if (Test-Path $DistRedist) { Remove-Item $DistRedist -Recurse -Force }
}
else {
    if (Test-Path $DistRedist) { Remove-Item $DistRedist -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $DistRedist | Out-Null
    Get-ChildItem $RedistDir -File | ForEach-Object {
        Copy-Item $_.FullName (Join-Path $DistRedist $_.Name) -Force
    }
    Copy-Item (Join-Path $Root "docs\INSTALL-WIN7.txt") (Join-Path $OutDist "INSTALL-WIN7.txt") -Force
}

$SetupPath = Join-Path $OutDist $SetupName
Write-Host ""
Write-Host "Done."
Write-Host "Installer: $SetupPath"
Write-Host "Portable:  $PortableDir"
if (-not $Light) {
    Write-Host "Redist:    $DistRedist"
}
