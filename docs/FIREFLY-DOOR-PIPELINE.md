# Firefly Door Pipeline — Neon Mansion

Updated: 5 October 2026.

## Purpose
The Firefly Neon Mansion door pack is a visual/modeling reference source for reusable Godot door scenes. Generated images are not automatically treated as final runtime textures.

## Source-of-truth split
- `the-drop-zone`: master Firefly door ZIPs, extracted working copies and manifests.
- `neon-mansion/firefly/door-references/raw`: local review copies for Codex/Godot; intentionally ignored by Git.
- `neon-mansion/godot/assets/neon-mansion/`: approved reusable Godot-owned door scenes/materials.
- KayKit/vendor source folders remain untouched.

## Import command
From `C:\GitHub\neon-mansion` run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\import-firefly-doors.ps1
```

If automatic matching cannot find the correct ZIP, use:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\import-firefly-doors.ps1 -DoorZip "C:\GitHub\the-drop-zone\YOUR-DOOR-PACK.zip"
```

The importer only auto-selects ZIP names containing door/doors; it will not deliberately fall back to unrelated room/texture exports.

## Review classifications
Each source image should be classified before use as one of:
- modeling reference
- frame/profile reference
- handle/hardware reference
- emissive-trim reference
- access-panel / room-number reference
- decal / screen asset
- Nightmare Frequency variant reference
- unsuitable / reference-only

## Target reusable Godot door variants
1. Standard single door
2. Luxury single door
3. Grand double door
4. Bedroom / bathroom / en-suite family
5. Kitchen / service door
6. Library / study door
7. Games / arcade / theatre door
8. Security / CCTV door
9. Cyber mainframe high-security door
10. Exterior / garden / terrace door

## Locked behavior rules
- Preserve door IDs and room-connection IDs.
- Preserve interaction, collision and open/closed behavior.
- Normal doors and Nightmare Frequency corruption are separate visual states.
- Exact labels/numbers should be added in-engine rather than baked into generated art where possible.
- Keep geometry modular and low-poly enough to reuse across the mansion.
- Do not modify third-party vendor/KayKit files directly.

## Visual language
Near-black door surfaces, dark teal/charcoal frames, hot-magenta emissive trim, small cyan/acid-green access indicators, restrained brass/dark-metal hardware, retro 80s/90s cyber styling with subtle gothic proportions.

## Test rule
Before expanding door variants across the full mansion, validate the approved reusable door scene in the current four-room foundation and confirm scale, collision, opening clearance, lighting, readability and access-panel placement.
