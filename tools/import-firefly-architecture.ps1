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

$zips = Get-ChildItem -Path $DropZone -Filter "*.zip" -File |
    Where-Object {
        $_.Name -match "architecture|architectural|detail|trim|ceiling|lighting|floor|material" -and
        $_.Name -notmatch "door|doors|room|scene"
    } |
    Sort-Object LastWriteTime

if (-not $zips) {
    throw "No Firefly architectural-detail ZIPs found in $DropZone. Put the architecture/detail pack ZIPs in the Drop Zone root and run again."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$sessionRoot = Join-Path $extractDir $stamp
New-Item -ItemType Directory -Force -Path $sessionRoot | Out-Null

$assetExts = @('.png','.jpg','.jpeg','.webp','.svg','.pdf')
$allFiles = @()

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

foreach ($zip in $zips) {
    Write-Host "Using Firefly architectural pack: $($zip.Name)" -ForegroundColor Cyan

    $archiveCopy = Join-Path $archiveDir $zip.Name
    if (-not (Test-Path $archiveCopy)) {
        Copy-Item $zip.FullName $archiveCopy
    }

    $packName = [System.IO.Path]::GetFileNameWithoutExtension($zip.Name)
    $safePackName = ($packName -replace '[^A-Za-z0-9._-]','_')
    $sessionDir = Join-Path $sessionRoot $safePackName
    New-Item -ItemType Directory -Force -Path $sessionDir | Out-Null
    Expand-Archive -Path $zip.FullName -DestinationPath $sessionDir -Force

    $files = Get-ChildItem -Path $sessionDir -Recurse -File | Where-Object { $assetExts -contains $_.Extension.ToLower() }

    foreach ($f in $files) {
        $allFiles += [pscustomobject]@{
            source_pack = $zip.Name
            pack_key = $safePackName
            file = $f
            category = Classify-ArchitectureAsset $f.Name
        }
    }
}

$manifest = foreach ($item in $allFiles) {
    $f = $item.file
    $packRoot = Join-Path $sessionRoot $item.pack_key
    [pscustomobject]@{
        source_pack = $item.source_pack
        file_name = $f.Name
        relative_path = $f.FullName.Substring($packRoot.Length + 1)
        extension = $f.Extension.ToLower()
        size_bytes = $f.Length
        category = $item.category
        runtime_status = 'review-required'
        godot_role = ''
        photoshop_cleanup = ''
    }
}

$manifestPath = Join-Path $manifestDir "firefly-architecture-assets-$stamp.csv"
$manifest | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $manifestPath

foreach ($item in $allFiles | Where-Object { @('.png','.jpg','.jpeg','.webp') -contains $_.file.Extension.ToLower() }) {
    $f = $item.file
    $safeName = ($f.Name -replace '[^A-Za-z0-9._-]','_')
    $destName = "$($item.pack_key)__${safeName}"
    $dest = Join-Path $localRefs $destName
    if (-not (Test-Path $dest)) {
        Copy-Item $f.FullName $dest
    }
}

Write-Host "Imported $($zips.Count) architectural pack(s)." -ForegroundColor Green
Write-Host "Archived masters: $archiveDir" -ForegroundColor Green
Write-Host "Extracted working copies: $sessionRoot" -ForegroundColor Green
Write-Host "Combined manifest: $manifestPath" -ForegroundColor Green
Write-Host "Local Codex/Godot references: $localRefs" -ForegroundColor Green
Write-Host "Next: review/classify both packs together, then promote only approved assets into Godot runtime folders." -ForegroundColor Yellow
