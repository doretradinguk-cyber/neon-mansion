# Firefly Room Pipeline — Neon Mansion

## Purpose
The 30 Firefly mansion scenes are the visual target for the 3D Godot mansion. They are not literal 3D geometry. Godot should reproduce their room identity, palette, lighting, major props, door logic and landmarks using modular architecture and reusable assets.

## Source-of-truth split
- `the-drop-zone`: master Firefly archives, extracted working copies and generated manifests.
- `neon-mansion/firefly/room-references/raw`: local working reference images for Codex/Godot. This folder is intentionally not meant for normal Git commits.
- `neon-mansion/design`: room metadata and gameplay/layout rules.
- `neon-mansion/godot`: playable 3D implementation.

## Benchmark visual language
- dark teal / charcoal architecture
- near-black doors
- hot-magenta emissive trims
- acid-green / cyan room indicators
- simple graphic low-poly / cel-shaded materials
- restrained retro 80s/90s neon-horror atmosphere
- Nightmare Frequency corruption remains a separate dynamic layer

## Per-room conversion checklist
For every Firefly room identify:
1. Room ID and name.
2. Anchor, generated, exterior or special room.
3. Required doors/exits and where they connect.
4. Major 3D geometry: walls, arches, stairs, railings, windows, raised floors.
5. Major 3D props: furniture, terminals, beds, kitchen units, arcade units, theatre seating, etc.
6. Material palette: wall, floor, trim, door, glass, wood/metal/marble.
7. Lighting: magenta/cyan/green practicals and ambient mood.
8. 2D-only/fakeable details: paintings, signs, monitor images, window views, skyline/garden backdrops, holograms and decals.
9. Gameplay hooks: clue positions, pickups, puzzles, encounters, safe zones.
10. Nightmare-state changes kept separate from the normal room scene.

## 3D matching rule
Match the Firefly room's visual identity, not every pixel. Preserve the recognizable silhouette, main furniture placement, important door relationships and signature lighting while keeping geometry modular and reusable.

## Shared kit first
Before making 30 unique scenes, build reusable:
- wall/corner/ceiling/floor modules
- door and emissive-frame modules
- stairs and landing modules
- railings/arches
- furniture wrappers
- standard Neon Mansion materials
- standard light rigs
- decal/screen/backdrop helpers

## Import command
After pulling the latest repo, run from `C:\GitHub\neon-mansion`:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\import-firefly-rooms.ps1
```

The script finds the latest relevant Firefly ZIP in `C:\GitHub\the-drop-zone`, archives it, extracts a working copy, creates a CSV manifest and makes local reference copies available inside the Neon Mansion project.

## Codex rule
Codex may inspect local Firefly references to understand style and room composition. It must not invent unavailable asset paths and must not modify vendor KayKit source assets. Build reusable Godot scenes and materials around the references instead.
