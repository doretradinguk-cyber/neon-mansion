param(
    [string]$DropZone = "C:\GitHub\the-drop-zone",
    [string]$NeonMansion = "C:\GitHub\neon-mansion"
)

$ErrorActionPreference = "Stop"

$fireflyRoot = Join-Path $DropZone "retro-game-assets\firefly\neon-mansion"
$archiveDir = Join-Path $fireflyRoot "master-archives"
$extractDir = Join-Path $fireflyRoot "extracted"
$manifestDir = Join-Path $fireflyRoot "manifests"
$localRefs = Join-Path $NeonMansion "firefly\room-references\raw"

New-Item -ItemType Directory -Force -Path $archiveDir,$extractDir,$manifestDir,$localRefs | Out-Null

$zip = Get-ChildItem -Path $DropZone -Filter "*.zip" -File |
    Where-Object { $_.Name -match "Retro Nightmare Frequency|Scene 1|Firefly" } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $zip) {
    throw "No Firefly room ZIP found in $DropZone. Put the latest Firefly export ZIP in the Drop Zone root and run again."
}

Write-Host "Using Firefly export: $($zip.Name)" -ForegroundColor Cyan

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

$manifest = foreach ($f in $files) {
    [pscustomobject]@{
        file_name = $f.Name
        relative_path = $f.FullName.Substring($sessionDir.Length + 1)
        extension = $f.Extension.ToLower()
        size_bytes = $f.Length
        room_id = ""
        room_name = ""
        role = "reference"
        status = "unreviewed"
    }
}

$manifestPath = Join-Path $manifestDir "firefly-room-assets-$stamp.csv"
$manifest | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $manifestPath

# Keep local working references available to Codex/Godot without committing them to Git.
foreach ($f in $files | Where-Object { @('.png','.jpg','.jpeg','.webp') -contains $_.Extension.ToLower() }) {
    $safeName = ($f.Name -replace '[^A-Za-z0-9._-]','_')
    $dest = Join-Path $localRefs $safeName
    if (-not (Test-Path $dest)) {
        Copy-Item $f.FullName $dest
    }
}

Write-Host "Firefly export archived to: $archiveCopy" -ForegroundColor Green
Write-Host "Extracted working copy: $sessionDir" -ForegroundColor Green
Write-Host "Manifest: $manifestPath" -ForegroundColor Green
Write-Host "Local Codex/Godot references: $localRefs" -ForegroundColor Green
Write-Host "Next: review the manifest and map each image to a room ID before 3D room dressing." -ForegroundColor Yellow
