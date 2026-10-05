# Neon Mansion layout changelog

## Baseline v1 — 5 October 2026

The user manually tested the current Godot foundation and approved the layout as the new structural baseline. Codex validation passed in installed Godot 4.7.2.

Approved main arrival route: **Entrance Hall → Foyer / Reception → Massive Grand Stair Hall → Long Gallery**. Driveway/exterior precedes it; the Drawing Room remains the furnished quality benchmark off the gallery. The staircase is set back, with a broad lower arrival floor and open upper landing/balconies.

Baseline inventory: 43 spatial definitions, 41 operable doors, 22 socket records and two stair connections. Includes exterior shells, fixed ground-floor circulation, upper landing/corridor and room shells, basement service-to-cyber progression, and GF-R01 with two compatible persistent templates. Wine/security locks and attic ascent are future work.

Fixed-structure + procedural-socket rule: anchors, corridors, stairs, exterior links and door openings are authored and permanent. Random rooms may populate only approved sockets; compatible templates must preserve shell, doorway, collision clearance and corridor. Once assigned in a run, a room persists. UF random sockets remain reserved. Nightmare Frequency remains separate and disabled by default.

Checkpoint housekeeping: raw Firefly boards and local captures/cache/run saves are excluded from Git. Framed panels use owned procedural placeholder artwork so the project does not depend on an excluded raw board. Assignment saving creates its ignored local directory when absent. No structural transforms, door interactions, controller or vendor source assets changed during checkpoint preparation.

Permanent records: MANSION-MAP.md, design/mansion-map.json and the runtime layout. Update all three together with this changelog for future structural alterations. Record date, reason, affected room/door/socket IDs, connection/transform changes, compatibility or save migration implications, and validation outcome. New sockets require explicit approval and complete metadata before generation uses them.

This checkpoint is local only. Publishing requires separate authorization.

## Visual quality pass — 5 October 2026 (local, uncommitted)

Baseline v1 structure remains unchanged. No room/door/socket IDs, transforms, connections, stairs, aperture dimensions or procedural assignment rules changed. No save migration is required.

Rebuilt door display geometry around the existing collider/hinge system; added layered frames, hardware, distinct family details and control plaques. Upgraded the five hero spaces with mouldings, coffers, railing detail, floor/rug zones, glass accents, fixtures and shared stylised finishes. Details and source classifications: VISUAL-UPGRADE.md and layout/visual_upgrade_manifest.json. Nightmare Frequency remains disabled. No push or new commit was requested for this pass.
Validation: Godot 4.7.2 foundation and rendered-input checks passed; map snapshot unchanged; all 4,722 protected vendor/reference hashes matched. Final captures were reviewed and privacy/service detail overlaps corrected. No parser/resource/shader errors in final validation logs.
