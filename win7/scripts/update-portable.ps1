#Requires -Version 3.0
<#
.SYNOPSIS
  Updates an existing Qaemshahr portable folder with a new build without touching AppData.

.EXAMPLE
  .\update-portable.ps1 -Source "C:\...\QaemshahrPortable_2.2.0" -Target "E:\QaemshahrPortable"
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Source,

    [Parameter(Mandatory = $true)]
    [string]$Target,

    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

function Resolve-Full([string]$p) {
    return [System.IO.Path]::GetFullPath((Resolve-Path $p).Path)
}

if (-not (Test-Path $Source)) { throw "Source not found: $Source" }
if (-not (Test-Path $Target)) { throw "Target not found: $Target" }

$Source = Resolve-Full $Source
$Target = Resolve-Full $Target

if ($Source -eq $Target) {
    throw "Source and Target must be different folders."
}

$srcExe = Join-Path $Source "Qaemshahr.exe"
$srcFlag = Join-Path $Source "portable.flag"
$dstExe = Join-Path $Target "Qaemshahr.exe"
$dstFlag = Join-Path $Target "portable.flag"
$dstAppData = Join-Path $Target "AppData"

if (-not (Test-Path $srcExe)) { throw "Source is not a portable package (Qaemshahr.exe missing)." }
if (-not (Test-Path $srcFlag)) { throw "Source is not a portable package (portable.flag missing)." }
if (-not (Test-Path $dstExe) -and -not (Test-Path $dstFlag)) {
    throw "Target does not look like an existing portable install."
}

if (-not (Test-Path $dstAppData)) {
    throw "Target has no AppData folder. Aborting to avoid a mistaken overwrite. Use a full copy for first install."
}

$running = Get-Process -Name "Qaemshahr" -ErrorAction SilentlyContinue
if ($running) {
    throw "Qaemshahr.exe is running. Close the app on the target machine, then retry."
}

Write-Host "Updating portable install"
Write-Host "  Source: $Source"
Write-Host "  Target: $Target"
Write-Host "  AppData will be preserved."

$copied = 0
Get-ChildItem $Source -Force | ForEach-Object {
    if ($_.Name -eq "AppData") {
        Write-Host "  skip  AppData (preserve client data)"
        return
    }
    if ($_.Name -like "AppData_PRESERVED_*") {
        Write-Host "  skip  $($_.Name)"
        return
    }

    $destPath = Join-Path $Target $_.Name
    if ($WhatIf) {
        Write-Host "  whatif copy $($_.Name)"
        return
    }

    if ($_.PSIsContainer) {
        if (Test-Path $destPath) { Remove-Item $destPath -Recurse -Force }
        Copy-Item $_.FullName $destPath -Recurse -Force
    }
    else {
        Copy-Item $_.FullName $destPath -Force
    }
    $copied++
    Write-Host "  copy  $($_.Name)"
}

if (-not $WhatIf) {
    if (-not (Test-Path $dstFlag)) {
        Copy-Item $srcFlag $dstFlag -Force
        Write-Host "  restored portable.flag"
    }
    if (-not (Test-Path $dstAppData)) {
        throw "AppData disappeared during update - abort. Restore from backup."
    }
}

Write-Host ""
Write-Host "Done. Files updated: $copied"
Write-Host "Verify: open Qaemshahr.exe from Target; employee data should still be present."
