# Firefly Architectural Detail Pipeline — Neon Mansion

## Purpose
This pack supplies reusable visual references and candidate production assets for the 3D Godot mansion: wall treatments, floors, ceilings, windows/glass, lighting fixtures, furniture materials, signage/access panels, damage/ageing, Nightmare overlays and exterior surfaces.

The Firefly pack is not assumed to be runtime-ready. Composite boards, perspective renders and concept sheets remain reference material unless deliberately cleaned and promoted.

## Source of truth
- Master archives: `the-drop-zone/retro-game-assets/firefly/neon-mansion/architecture/master-archives/`
- Extracted working copies: `the-drop-zone/retro-game-assets/firefly/neon-mansion/architecture/extracted/`
- Manifests: `the-drop-zone/retro-game-assets/firefly/neon-mansion/architecture/manifests/`
- Local ignored references: `neon-mansion/firefly/architecture-references/raw/`
- Curated runtime assets only: `neon-mansion/godot/assets/neon-mansion/`

## Import command
From `C:\GitHub\neon-mansion`:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\import-firefly-architecture.ps1
```

The importer finds the newest architecture/detail-oriented ZIP in the Drop Zone root, archives it, extracts a working copy, creates a CSV manifest, and copies image references locally for Codex/Godot inspection.

## Classification targets
Each asset should be reviewed as one of:
- wall-trim
- floor
- ceiling
- window-glass
- lighting-fixture
- furniture-material
- signage-access
- damage-aging
- nightmare-overlay
- exterior
- reference-unclassified

## Runtime promotion rule
Only promote an asset into the Godot runtime tree after confirming:
1. It is useful at gameplay camera distance.
2. It is not merely a perspective concept render.
3. It has acceptable edge cleanup / alpha / tiling for its intended role.
4. Its style matches the Neon Mansion benchmark.
5. It does not replace a reusable 3D element that should instead be modeled once.
6. It does not mix Nightmare Frequency corruption into the normal-state material.

## Photoshop cleanup candidates
Common cleanup tasks:
- remove backgrounds
- straighten perspective
- create seamless/tileable versions
- isolate trim profiles
- produce transparent decal versions
- generate normal/roughness helpers where useful
- clean mask edges
- separate normal and Nightmare variants

## Architectural priority
Use the pack to make the first slice feel authored before expanding the mansion:
- Entrance / Reception Hall
- foyer transition
- Grand Stair Hall
- Long Gallery
- Drawing Room

The Grand Stair Hall must read as a fixed anchor room, not a random connector.
