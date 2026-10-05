# Neon Mansion — handover

Updated: 5 October 2026.

## Purpose
Neon Mansion is the reusable 3D mansion / virtual-layer project for **Neo-Gothic Glitch**. The Book of Hosts Virtual Manor remains reference/rollback material only; Neon Mansion is now a clean Godot 4.7 project with its own modular architecture, materials, room rules and Firefly-assisted art pipeline.

## Current local development state
The active working copy is expected at:

`C:\GitHub\neon-mansion`

Important: the current playable Godot foundation and recent Codex polish/layout/door work have been developed as **local uncommitted work** while testing. Do not reset, clean, checkout over, delete or blindly replace the local working tree before reviewing it.

The remote `main` branch contains the asset/import/documentation pipeline, but the latest tested Godot scene changes may still only exist locally until the user approves the checkpoint.

## Current playable foundation
A working first-person four-room slice has been created and tested in Godot 4.7.2:

Entrance / Reception Hall -> Grand Stair Hall -> Long Gallery -> Drawing Room

Verified during local testing:
- first-person movement works
- mouse look works
- door interaction exists
- collision is present
- stair traversal works
- room/door IDs are visible and retained
- teal/charcoal base palette is present
- magenta emissive accents are present
- cyan/acid-green indicators are present
- no obvious missing-material pink/error surfaces were seen in the tested screenshots

## Current layout issue / required correction
The first tested layout placed the Grand Stair Hall too directly behind the first doorway. This makes the mansion feel cramped and abrupt.

Required flow:

Entrance Hall -> short reception/foyer transition -> Grand Stair Hall -> Long Gallery -> Drawing Room

Grand Stair Hall should become a true anchor room:
- wider and deeper
- staircase set back from the entrance
- meaningful lower-floor arrival space before the first step
- larger visible landing/balcony
- clear railing silhouette
- room for future left/right wing connections
- stronger mansion proportions and visual hierarchy

Do not expand to the full mansion until this anchor flow feels correct.

## Visual benchmark
The current geometry is structurally useful but still needs environmental dressing and lighting polish to match the Firefly benchmark.

Target language:
- dark teal / charcoal architecture
- near-black doors
- hot-magenta emissive trims
- restrained cyan and acid-green diagnostics
- dark tiled/polished flooring
- cel-shaded / graphic low-poly presentation
- controlled neon spill rather than neon on every surface
- readable architecture despite a dark horror mood
- 80s/90s retrowave + neo-gothic atmosphere

The Drawing Room should become the first quality-benchmark room before duplicating the style across the remaining mansion.

## Nightmare Frequency rule
Nightmare Frequency remains a **separate disabled visual state** during normal mansion testing. It may later add code rain, corrupted signage, Jester imagery, signal fractures, emissive cracks, glitch distortion and fog, but normal materials must remain intact and reusable.

## Firefly room pipeline
The 30 Firefly room concepts are visual targets, not literal 3D rooms.

Use them to define:
- room identity
- major prop priorities
- palette
- lighting
- door relationships
- backdrop/screen/decal opportunities

Source master stays in `the-drop-zone`. Local references are ignored by Git. See `docs/FIREFLY-ROOM-PIPELINE.md`.

## Firefly texture/material pipeline
Firefly texture/support packs are imported as working references first. Do not assume every composite board is a direct UV-ready texture.

Current runtime-facing material families include/target:
- teal wall
- charcoal wall
- near-black door
- dark tile
- dark marble
- walnut/dark wood
- brass/dark metal
- smoked glass
- magenta emissive trim
- cyan emissive trim
- acid-green indicator
- Nightmare corruption base/emissive variants

Raw source references remain uncommitted unless deliberately curated into final runtime assets.

## Firefly door pipeline
A dedicated door import workflow exists:

`tools/import-firefly-doors.ps1`

Documentation:

`docs/FIREFLY-DOOR-PIPELINE.md`

The door pack remains mastered in Drop Zone and is copied into ignored local reference storage for inspection. It must be classified before runtime use.

Target reusable door families:
- standard single
- luxury single
- grand double
- bedroom/bathroom/en-suite
- kitchen/service
- library/study
- games/arcade/theatre
- security/CCTV
- cyber mainframe high-security
- exterior/garden/terrace

Preserve door IDs, interaction behavior, collision and room connections. Nightmare-corrupted doors are optional visual variants, not replacements for the normal door scene.

Codex has completed the current door-system pass locally. Before committing, test the revised door scenes in Godot for scale, interaction, swing/clearance and collisions.

## Firefly architectural-detail pipeline — added
A new importer is ready for the upcoming Firefly architectural detail pack:

`tools/import-firefly-architecture.ps1`

Documentation:

`docs/FIREFLY-ARCHITECTURE-PIPELINE.md`

This pack covers:
- wall treatments / mouldings / trim
- floors
- ceilings
- windows / glass
- lighting fixtures
- furniture materials
- signage / access panels
- damage / ageing
- Nightmare overlays
- exterior materials

The usual rule applies: Drop Zone is the master archive; local working references are ignored; only reviewed assets are promoted into runtime Godot folders.

## Stable mansion map architecture — next major system
After the current first-slice visual/door test, create the permanent mansion map before building the remaining rooms.

The governing rule is:

**The mansion structural skeleton always stays the same. Random rooms attach to fixed authored sockets.**

This prevents sloppy procedural generation such as stairs in wrong places, impossible corridors, room overlap, blocked doors and misplaced furniture.

Fixed/authored structure should include:
- mansion exterior footprint
- driveway/front approach
- Entrance / Reception Hall
- foyer transition
- Grand Stair Hall
- all staircases
- upper landing/balcony
- main corridor spine
- Long Gallery
- fixed wing junctions
- service/kitchen hub
- pool/garden hub
- major exterior connections
- important exterior-facing walls/windows
- anchor doors and required story routes

Random/semi-random rooms only populate designated sockets. Each socket must define floor, wing, size class, orientation, allowed room categories, exterior-wall requirements, service/plumbing constraints and connection transform.

Every generated room must define safe doorway placement, prop/no-block zones and compatibility metadata before it can spawn. Once a random room is discovered, its socket assignment persists instead of rerolling on every visit.

See:

`docs/MANSION-MAP-ARCHITECTURE.md`

Before scaling up, test one socket with two interchangeable room templates and confirm both connect cleanly, keep furniture clear of exits and persist after reload.

## Source / vendor policy
KayKit and other third-party/vendor source assets remain under their vendor folders and must not be edited directly. Neon Mansion-owned wrappers, materials, scenes and variants belong under the Neon Mansion asset tree.

Current source packs include:
- KayKit Dungeon Remastered
- KayKit Furniture Bits
- KayKit Restaurant Bits
- KayKit Prototype Bits

## Immediate test-before-merge plan
1. Wait for the new Firefly architectural detail pack.
2. Pull the latest remote pipeline/documentation updates **without discarding local Codex work**.
3. Import it with `tools/import-firefly-architecture.ps1` using the usual Drop Zone archive/extract/manifest workflow.
4. Reload changed project files from disk in Godot if prompted.
5. Test the latest local Codex door/layout/visual work in Godot 4.7.2.
6. Verify Entrance Hall -> foyer -> Grand Stair Hall -> Long Gallery -> Drawing Room flow.
7. Verify door scale, clearance, interaction, double-door movement and collision.
8. Verify architecture is readable and furniture does not obstruct traversal.
9. Run `git status` and review the complete local working tree.
10. Only after playable approval create the first proper checkpoint commit/merge.
11. Then design the permanent mansion map skeleton and socket system before adding the remaining room catalogue.

## Safety / rollback rules
- Do not run `git clean`.
- Do not run destructive reset/checkout commands against the local working tree.
- Do not modify KayKit vendor source files.
- Do not commit `.godot` import cache.
- Do not commit raw Firefly reference folders wholesale.
- Do not build the remaining rooms until the first slice establishes the approved architecture, door system, material system, lighting quality and fixed-map/socket rules.
