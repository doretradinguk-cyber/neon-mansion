param(
    [string]$DropZone = "C:\GitHub\the-drop-zone",
    [string]$NeonMansion = "C:\GitHub\neon-mansion"
)

$ErrorActionPreference = "Stop"

$fireflyRoot = Join-Path $DropZone "retro-game-assets\firefly\neon-mansion\architecture"
$archiveDir = Join-Path $fireflyRoot "master-archives"
$extractDir = Join-Path $fireflyRoot "extracted"
$manifestDir = Join-Path $fireflyRoot "manifests"
$localRefs = Join-Path $NeonMansion "firefly\architecture-references\raw"

New-Item -ItemType Directory -Force -Path $archiveDir,$extractDir,$manifestDir,$localRefs | Out-Null

$zip = Get-ChildItem -Path $DropZone -Filter "*.zip" -File |
    Where-Object {
        $_.Name -match "architecture|architectural|detail|trim|ceiling|lighting|floor|material" -and
        $_.Name -notmatch "door|doors|room|scene"
    } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $zip) {
    throw "No Firefly architectural-detail ZIP found in $DropZone. Put the latest architecture/detail pack ZIP in the Drop Zone root and run again."
}

Write-Host "Using Firefly architectural pack: $($zip.Name)" -ForegroundColor Cyan

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

function Classify-ArchitectureAsset([string]$name) {
    $n = $name.ToLower()
    if ($n -match 'wall|mould|molding|wainscot|arch|trim|skirting|baseboard|crown') { return 'wall-trim' }
    if ($n -match 'floor|tile|marble|parquet|carpet|paving') { return 'floor' }
    if ($n -match 'ceiling|coffer|recess') { return 'ceiling' }
    if ($n -match 'window|glass|stained|frosted|smoked') { return 'window-glass' }
    if ($n -match 'light|sconce|chandelier|lamp|fixture|strip') { return 'lighting-fixture' }
    if ($n -match 'leather|velvet|fabric|wood|walnut|brass|metal|lacquer|chrome|plastic') { return 'furniture-material' }
    if ($n -match 'sign|access|cctv|arrow|warning|number|plaque') { return 'signage-access' }
    if ($n -match 'scratch|chip|crack|leak|stain|grime|scuff|wear|damage') { return 'damage-aging' }
    if ($n -match 'nightmare|corrupt|glitch|jester|code|signal|fracture|vein') { return 'nightmare-overlay' }
    if ($n -match 'exterior|driveway|garden|terrace|garage|shed|gate|railing') { return 'exterior' }
    return 'reference-unclassified'
}

$manifest = foreach ($f in $files) {
    [pscustomobject]@{
        file_name = $f.Name
        relative_path = $f.FullName.Substring($sessionDir.Length + 1)
        extension = $f.Extension.ToLower()
        size_bytes = $f.Length
        category = Classify-ArchitectureAsset $f.Name
        runtime_status = 'review-required'
        godot_role = ''
        photoshop_cleanup = ''
    }
}

$manifestPath = Join-Path $manifestDir "firefly-architecture-assets-$stamp.csv"
$manifest | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $manifestPath

foreach ($f in $files | Where-Object { @('.png','.jpg','.jpeg','.webp') -contains $_.Extension.ToLower() }) {
    $safeName = ($f.Name -replace '[^A-Za-z0-9._-]','_')
    $dest = Join-Path $localRefs $safeName
    if (-not (Test-Path $dest)) {
        Copy-Item $f.FullName $dest
    }
}

Write-Host "Architectural pack archived to: $archiveCopy" -ForegroundColor Green
Write-Host "Extracted working copy: $sessionDir" -ForegroundColor Green
Write-Host "Manifest: $manifestPath" -ForegroundColor Green
Write-Host "Local Codex/Godot references: $localRefs" -ForegroundColor Green
Write-Host "Next: review/classify the pack, then promote only approved assets into Godot runtime folders." -ForegroundColor Yellow
