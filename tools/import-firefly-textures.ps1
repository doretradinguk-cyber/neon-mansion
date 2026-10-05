param(
    [string]$DropZone = "C:\GitHub\the-drop-zone",
    [string]$NeonMansion = "C:\GitHub\neon-mansion",
    [string]$ZipPath = ""
)

$ErrorActionPreference = "Stop"

$fireflyRoot = Join-Path $DropZone "retro-game-assets\firefly\neon-mansion\textures"
$archiveDir = Join-Path $fireflyRoot "master-archives"
$extractDir = Join-Path $fireflyRoot "extracted"
$manifestDir = Join-Path $fireflyRoot "manifests"
$localRaw = Join-Path $NeonMansion "firefly\texture-references\raw"
$godotSource = Join-Path $NeonMansion "godot\assets\neon-mansion\materials\firefly-source"

New-Item -ItemType Directory -Force -Path $archiveDir,$extractDir,$manifestDir,$localRaw,$godotSource | Out-Null

if ([string]::IsNullOrWhiteSpace($ZipPath)) {
    $zip = Get-ChildItem -Path $DropZone -Filter "*.zip" -File |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
} else {
    $zip = Get-Item -LiteralPath $ZipPath
}

if (-not $zip) {
    throw "No texture ZIP found. Put the latest Firefly texture/material export ZIP in $DropZone or pass -ZipPath explicitly."
}

Write-Host "Using Firefly texture export: $($zip.FullName)" -ForegroundColor Cyan

$archiveCopy = Join-Path $archiveDir $zip.Name
if (-not (Test-Path $archiveCopy)) {
    Copy-Item $zip.FullName $archiveCopy
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$sessionDir = Join-Path $extractDir $stamp
New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null
Expand-Archive -Path $zip.FullName -DestinationPath $sessionDir -Force

$assetExts = @('.png','.jpg','.jpeg','.webp','.tif','.tiff','.svg')
$files = Get-ChildItem -Path $sessionDir -Recurse -File | Where-Object { $assetExts -contains $_.Extension.ToLower() }

if (-not $files) {
    throw "The ZIP was extracted, but no supported image assets were found."
}

function Get-Role([string]$name) {
    $n = $name.ToLower()
    if ($n -match 'mask|alpha') { return 'mask' }
    if ($n -match 'emiss|glow|neon|light') { return 'emissive' }
    if ($n -match 'decal|sign|label|warning|symbol') { return 'decal' }
    if ($n -match 'screen|monitor|terminal|cctv|arcade|theatre') { return 'screen-art' }
    if ($n -match 'backdrop|sky|garden|driveway|window|city') { return 'backdrop' }
    if ($n -match 'nightmare|jester|glitch|code|corrupt') { return 'nightmare-fx' }
    return 'surface-texture'
}

$manifest = foreach ($f in $files) {
    [pscustomobject]@{
        file_name = $f.Name
        relative_path = $f.FullName.Substring($sessionDir.Length + 1)
        extension = $f.Extension.ToLower()
        size_bytes = $f.Length
        role = Get-Role $f.Name
        status = 'unreviewed'
        target_material = ''
        notes = ''
    }
}

$manifestPath = Join-Path $manifestDir "firefly-texture-assets-$stamp.csv"
$manifest | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $manifestPath

foreach ($f in $files) {
    $relative = $f.FullName.Substring($sessionDir.Length + 1)
    $safeRelative = $relative -replace '[^A-Za-z0-9._\\/-]','_'

    $rawDest = Join-Path $localRaw $safeRelative
    $rawParent = Split-Path $rawDest -Parent
    New-Item -ItemType Directory -Force -Path $rawParent | Out-Null
    Copy-Item $f.FullName $rawDest -Force

    $role = Get-Role $f.Name
    $roleDir = Join-Path $godotSource $role
    New-Item -ItemType Directory -Force -Path $roleDir | Out-Null
    $safeName = ($f.Name -replace '[^A-Za-z0-9._-]','_')
    $dest = Join-Path $roleDir $safeName
    if (Test-Path $dest) {
        $base = [IO.Path]::GetFileNameWithoutExtension($safeName)
        $ext = [IO.Path]::GetExtension($safeName)
        $dest = Join-Path $roleDir ("{0}_{1}{2}" -f $base,$stamp,$ext)
    }
    Copy-Item $f.FullName $dest
}

Write-Host "Firefly texture archive: $archiveCopy" -ForegroundColor Green
Write-Host "Extracted working copy: $sessionDir" -ForegroundColor Green
Write-Host "Manifest: $manifestPath" -ForegroundColor Green
Write-Host "Local raw references: $localRaw" -ForegroundColor Green
Write-Host "Godot source textures: $godotSource" -ForegroundColor Green
Write-Host "Godot will import the copied image assets automatically. Review and curate before treating them as final materials." -ForegroundColor Yellow
