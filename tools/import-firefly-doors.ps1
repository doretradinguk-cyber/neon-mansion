param(
    [string]$DropZone = "C:\GitHub\the-drop-zone",
    [string]$NeonMansion = "C:\GitHub\neon-mansion",
    [string]$DoorZip = ""
)

$ErrorActionPreference = "Stop"

$doorRoot = Join-Path $DropZone "retro-game-assets\firefly\neon-mansion\doors"
$archiveDir = Join-Path $doorRoot "master-archives"
$extractDir = Join-Path $doorRoot "extracted"
$manifestDir = Join-Path $doorRoot "manifests"
$localRefs = Join-Path $NeonMansion "firefly\door-references\raw"

New-Item -ItemType Directory -Force -Path $archiveDir,$extractDir,$manifestDir,$localRefs | Out-Null

if ($DoorZip) {
    if (-not (Test-Path $DoorZip)) {
        throw "Door ZIP not found: $DoorZip"
    }
    $zip = Get-Item $DoorZip
} else {
    $zip = Get-ChildItem -Path $DropZone -Filter "*.zip" -File |
        Where-Object { $_.Name -match "door|doors|Neon Mansion Door|Firefly Door" } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

if (-not $zip) {
    throw "No Firefly door ZIP found in $DropZone. Put the door export ZIP in the Drop Zone root, or run with -DoorZip 'C:\path\to\doors.zip'."
}

Write-Host "Using Firefly door export: $($zip.FullName)" -ForegroundColor Cyan

$archiveCopy = Join-Path $archiveDir $zip.Name
if (-not (Test-Path $archiveCopy)) {
    Copy-Item $zip.FullName $archiveCopy
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$sessionDir = Join-Path $extractDir $stamp
New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null
Expand-Archive -Path $zip.FullName -DestinationPath $sessionDir -Force

$assetExts = @('.png','.jpg','.jpeg','.webp','.svg','.pdf')
$files = Get-ChildItem -Path $sessionDir -Recurse -File | Where-Object { $assetExts -contains $_.Extension.ToLower() }

if (-not $files) {
    throw "Door ZIP extracted but no supported image/reference files were found."
}

$manifest = foreach ($f in $files) {
    [pscustomobject]@{
        file_name = $f.Name
        relative_path = $f.FullName.Substring($sessionDir.Length + 1)
        extension = $f.Extension.ToLower()
        size_bytes = $f.Length
        classification = "unreviewed"
        intended_role = "door-reference"
        door_variant = ""
        runtime_ready = $false
        notes = ""
    }
}

$manifestPath = Join-Path $manifestDir "firefly-door-assets-$stamp.csv"
$manifest | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $manifestPath

# Keep Firefly source art as local review material. Do not automatically treat it as runtime-ready.
foreach ($f in $files | Where-Object { @('.png','.jpg','.jpeg','.webp') -contains $_.Extension.ToLower() }) {
    $safeName = ($f.Name -replace '[^A-Za-z0-9._-]','_')
    $dest = Join-Path $localRefs $safeName
    if (-not (Test-Path $dest)) {
        Copy-Item $f.FullName $dest
    }
}

Write-Host "Door export archived to: $archiveCopy" -ForegroundColor Green
Write-Host "Extracted working copy: $sessionDir" -ForegroundColor Green
Write-Host "Door manifest: $manifestPath" -ForegroundColor Green
Write-Host "Local Codex/Godot door references: $localRefs" -ForegroundColor Green
Write-Host "Next: review/classify the door art, then build reusable Godot door scenes without modifying KayKit vendor assets." -ForegroundColor Yellow
