# Neon Mansion reusable door system

Completed 2026-10-05 inside C:\GitHub\neon-mansion. Current uncommitted work was inspected before editing and preserved. No reset, cleanup, deletion, checkout, commit, merge or publication occurred.

## Runtime variants

| Scene / profile | Visual role | Reviewed source boards |
| --- | --- | --- |
| standard | Rectangular dark single leaf, teal frame, magenta outline, brass lever, green/cyan access light | 1 |
| luxury | Pointed pediment and leaf inlay, brass pull | 2, 7 |
| grand_double | Two opposed hinged leaves, wider pointed frame, paired pulls | 3 |
| bedroom_bathroom | Pointed single leaf, dark privacy insert, literal room number | 4, 5 |
| kitchen_service | Simple dark single leaf, push plate, privacy insert | 6 |
| theatre_games_arcade | Cyan vertical accent, PLAY plaque | 8 |
| security_cyber | Keypad geometry, cyan spine, ACCESS plaque | 9 |
| exterior_garden | Pull handle, dark decorative glazing insert | Derived from 1 and 5; no dedicated exterior board |

Scenes inherit the existing architecture/door.tscn; shared style resources live in architecture/doors/styles. The base KayKit Door_A mesh is reused through the existing module loader. Neon Mansion geometry and existing owned materials supply all frames, accents, plaques and hardware. No vendor file is changed or duplicated.

Single leaves retain 1.92 x 2.78 x 0.16 metre colliders. Grand double uses two 1.92 x 3.20 x 0.16 metre leaves, for a 3.84 metre span; provide a minimum 4 x 3.32 metre rectangular portal if placing it later. It is not forced into the current smaller portals. Pointed features are decorative pediments/inlays, keeping rectangular functional apertures. Glazing inserts are decorative smoked surfaces over the opaque base leaf, not cut-through windows. Hardware is visual; no locks/privacy mechanics or networking added.

## Existing mansion integration and preservation

Only the foundation scene's style assignments and literal numbers changed: entrance-to-stair remains standard (02); stair-to-gallery and gallery-to-drawing use luxury (03 and 04). Existing captions, door IDs, room IDs, room links and all spatial transforms remain intact.

Preserved sequence: Entrance Hall -> foyer/reception transition -> Grand Stair Hall -> Long Gallery -> Drawing Room. No additional rooms. The set-back stair, larger arrival floor, upper landing, side balconies, railings and future wing markers remain as previously revised.

Interaction retains the existing group, metadata, raycast lookup, first hinge, 90 degree opening, 0.4 second sine tween, animation debounce and state_changed(door_id, opened) signal. The double-door prefab extends the same behavior to a second hinge opening oppositely, emitting one signal per accepted interaction. Current installed doors retain one box collider each. Decorative frames, accents, labels and effects add no collision.

## Firefly door pack classification

All nine 1379 x 770 PNGs were opened and visually inspected before editing. Their shared filename prefix is Retro_Nightmare_Frequency___Scene_1_Production_Board-; numbers below identify the full filenames in firefly/door-references/raw.

All are composite closed/ajar/open modelling studies: useful modelling, frame/profile, hardware, emissive-trim and access/identifier references; all are reference-only and unsuitable for direct runtime texture use. No standalone usable decal or screen asset was found. No generated bitmap was applied to a door.

| Board | Actual content and useful contribution | Photoshop work required before any extracted bitmap use |
| --- | --- | --- |
| 1.png | Standard rectangular single door; teal frame, magenta outline, brass lever, small green light | Isolate one orthographic view; remove state captions/background/bloom; redraw access symbols |
| 2.png | Luxury pointed single door, ornamental pull and inset panels | Correct perspective and inconsistent states; isolate hardware; rebuild clean trim mask |
| 3.png | Grand gothic double door, paired pulls and luminous transom glyphs | Reconcile leaf/hinge proportions; remove background; redraw transom glyphs and masks |
| 4.png | Bedroom door, shallow pointed panel, lever/backplate and bedroom identifier | Separate bed icon/number; repair distorted details; remove baked glow |
| 5.png | Bathroom door, upper glazing vocabulary and privacy identifier | Redraw privacy icon; separate glass/frame masks; remove reflections and background |
| 6.png | Service door, porthole/push-plate vocabulary and service controls | Rebuild PUSH lettering, porthole and controls as clean isolated art; perspective correction |
| 7.png | Library/study pointed door, stacked panels, ornamental lever and book identifier | Redraw book symbol and consistent hardware profile; separate trim/background |
| 8.png | Games/arcade door, cyan spine, gamepad identifier and magenta panel outline | Redraw gamepad icon; remove state captions/baked glow; export verified alpha if used as decal |
| 9.png | Security/CCTV door, armored panels, keypad and CCTV identifier | Rebuild keypad digits/icons; reconcile panel/rivet geometry; separate emissive mask |

None needs Photoshop cleanup to remain a modelling reference. All nine need extraction/redraw/cleanup before any direct production decal, screen or texture use; the current geometric implementation does not depend on that work. Source files remain unchanged. Detailed source-by-source classifications, runtime suitability, material/helper correspondence and cleanup notes are recorded in architecture/doors/firefly_door_manifest.json.

## Nightmare Frequency

door_nightmare.gd creates a separate optional layer on each leaf with its own shader materials. It supplies animated signal bands/tearing, emissive crack patterns and a corrupted access-panel overlay. It follows leaf movement and never changes normal materials, collision, links or interaction state. nightmare_active defaults false; all normal mansion instances start disabled. Set nightmare_active true on an instance only when future gameplay enables it. The test capture nightmare_preview.png explicitly enables the test specimen only.

## Godot validation

Installed executable: C:\Users\doret\Videos\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe, confirmed 4.7.2.stable.official.ed1daf0bf.

- All eight prefabs instantiated successfully; correct hinge/collider counts and dimensions.
- Closed-door collision blocks the existing player; opening allows passage.
- Raycast resolves the same door interaction owner.
- Animation debounce, paired opening angles and one signal per accepted toggle pass.
- Nightmare defaults disabled, can toggle without modifying base materials/open state, then disables again.
- Full existing foyer/stair/gallery/drawing route and return route pass, including landing/railings/wing marker checks.
- Forward+ rendering succeeded for eight normal variants, one enabled Nightmare test and six preserved mansion views. Captions and emissive effects were reviewed after corrections.
- No parser, resource or shader errors in checks.log, layout.log, render.log or mansion-render.log.

SHA256 comparison against before-files.json: no previous file missing; only scripts/door.gd and scenes/foundation.tscn changed. All 4,655 KayKit files and all nine raw door PNGs retain their original hashes. Existing owned material/source assets and previous validation work retain their hashes. Godot transient .godot caches may update during validation.

## Complete created/modified file inventory

Paths below are relative to C:\GitHub\neon-mansion. A machine-readable copy is work/door-system/file-report.json.

### Modified existing files

- godot/assets/neon-mansion/scripts/door.gd
- godot/assets/neon-mansion/scenes/foundation.tscn

### Created runtime resources / manifest

- godot/assets/neon-mansion/architecture/doors/door_style.gd
- godot/assets/neon-mansion/architecture/doors/styles/standard.tres
- godot/assets/neon-mansion/architecture/doors/standard.tscn
- godot/assets/neon-mansion/architecture/doors/styles/luxury.tres
- godot/assets/neon-mansion/architecture/doors/luxury.tscn
- godot/assets/neon-mansion/architecture/doors/styles/grand_double.tres
- godot/assets/neon-mansion/architecture/doors/grand_double.tscn
- godot/assets/neon-mansion/architecture/doors/styles/bedroom_bathroom.tres
- godot/assets/neon-mansion/architecture/doors/bedroom_bathroom.tscn
- godot/assets/neon-mansion/architecture/doors/styles/kitchen_service.tres
- godot/assets/neon-mansion/architecture/doors/kitchen_service.tscn
- godot/assets/neon-mansion/architecture/doors/styles/theatre_games_arcade.tres
- godot/assets/neon-mansion/architecture/doors/theatre_games_arcade.tscn
- godot/assets/neon-mansion/architecture/doors/styles/security_cyber.tres
- godot/assets/neon-mansion/architecture/doors/security_cyber.tscn
- godot/assets/neon-mansion/architecture/doors/styles/exterior_garden.tres
- godot/assets/neon-mansion/architecture/doors/exterior_garden.tscn
- godot/assets/neon-mansion/scripts/door_visual.gd
- godot/assets/neon-mansion/nightmare-fx/shaders/door_contamination.gdshader
- godot/assets/neon-mansion/scripts/door_nightmare.gd
- godot/assets/neon-mansion/architecture/doors/firefly_door_manifest.json

### Created documentation / validation evidence

- docs/DOOR-SYSTEM.md
- work/door-system/bedroom_bathroom.png
- work/door-system/before-files.json
- work/door-system/before-status.txt
- work/door-system/capture_doors.gd
- work/door-system/capture_mansion.gd
- work/door-system/check_doors.gd
- work/door-system/checks.log
- work/door-system/drawing_room.png
- work/door-system/entrance_foyer.png
- work/door-system/exterior_garden.png
- work/door-system/file-report.json
- work/door-system/file-verification.json
- work/door-system/gallery.png
- work/door-system/grand_arrival.png
- work/door-system/grand_double.png
- work/door-system/grand_wide.png
- work/door-system/kitchen_service.png
- work/door-system/layout.log
- work/door-system/luxury.png
- work/door-system/mansion-render.log
- work/door-system/nightmare_preview.png
- work/door-system/render.log
- work/door-system/security_cyber.png
- work/door-system/standard.png
- work/door-system/theatre_games_arcade.png
- work/door-system/upper_balcony.png
