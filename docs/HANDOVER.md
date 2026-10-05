# Neon Mansion — handover

Updated 5 October 2026. Work performed only inside C:\GitHub\neon-mansion. Nothing reset, cleaned, deleted, checked out over, merged or published. The user has authorized the Baseline v1 local checkpoint commit; pushing is not authorized. Existing uncommitted work was inspected first. The previous handover and the previous foundation entry scene/stair script are preserved in work/map-foundation alongside the before-state hash inventory. Existing owned room scenes, original foundation helpers, door behavior, materials, reference images and vendor sources are retained.

## Current visual upgrade

The 5 October visual pass is local and uncommitted on top of Baseline v1. See `docs/VISUAL-UPGRADE.md` for the comparison, file inventory, door/frame/material changes, Firefly mappings and remaining visual gaps. The approved mansion structure and socket logic remain intact. Runtime door surfaces now use owned display geometry while retaining the original wrapper collider and interaction ownership. All eight families plus the grand-anchor size preset remain available.

The latest Entrance Hall follow-up adds a mirrored pair of collision-free side-bay benches; that small addition remains pending a Godot visual check. Validation for this visual pass: installed Godot 4.7.2 foundation checks and rendered input checks passed. All 41 doors, grand/service stairs, upper landing/guards, basement progression, Drawing Room lanes and both socket templates passed. Final render logs contain no parser/resource/shader errors. The map snapshot still matches all 43 spaces, 41 doors, 22 sockets and two stairs. Hash checks confirmed 4,722 vendor/reference source files unchanged. Six matched before/after views and all nine door presets in closed/open states were visually reviewed under `work/visual-upgrade/`.

All 45 local source boards were reviewed before editing. No raw image was promoted or modified. Composite textures, signs/screens, artwork and VFX still require component extraction and Photoshop cleanup before production use. Normal materials remain independent of the disabled Nightmare layer.

## Approved structural baseline — v1

The current mansion foundation has been manually tested by the user and the layout is approved as the structural baseline. Codex validation passed in Godot 4.7.2. Grand Stair Hall, upper landing/balconies, doors, basement traversal and the persistent random socket prototype are working.

Permanent planning records: `docs/MANSION-MAP.md`, `design/mansion-map.json` and `docs/MANSION-CHANGELOG.md`. Future structural alterations must update the map, runtime definition, planning snapshot and changelog together. Random rooms may only attach to approved sockets. Nightmare Frequency remains disabled by default.

## Current playable build

The user-supplied THE SANCTUM — MANSION MAP is now the structural authority. The earlier instruction to stop at four rooms is superseded by this authorized skeleton pass. Ordinary rooms are structural shells with basic lighting and labels; the Drawing Room is the furnished benchmark. The former four room IDs and three door IDs remain.

Open godot/project.godot in Godot 4.7.2 and press F5. The player starts on the driveway at (0,0.05,32), facing the entrance. WASD/arrows move; mouse looks; E operates a focused door leaf; Escape releases capture and left-click captures again. An open door must be targeted at its moved leaf to close it.

Permanent arrival route:
Driveway / Exterior -> Entrance Hall -> Foyer / Reception -> Grand Stair Hall -> Long Gallery -> Drawing Room / mansion wings.

The front door is about 48 metres from the first stair, with the Entrance Hall and foyer intervening. The stair toe is 12 metres beyond the stair-hall threshold. Stairs are not immediately behind the front door.

## Authored structure and proportions

World axes: X runs along the galleries; -Z runs inward from the driveway; Y is elevation. Ground floor 0 m, upper floor +6.4 m, basement -6.4 m.

| Anchor | Centre (X,Y,Z), metres | Footprint | Ceiling / structure |
| --- | --- | --- | --- |
| Entrance Hall | (0,0,0) | 20 x 24 m | 10 m, multiple pilaster/window bays, coffered ceiling and chandelier |
| Foyer / Reception | (0,0,-18) | 12 x 12 m | 6 m, console/cabinet, seating, side panels and practical lights |
| Grand Stair Hall | (0,0,-42) | 32 x 36 m | 14 m, broad arrival floor, central staircase and open side balconies |
| Long Gallery | (68,0,-42) | 104 x 8 m | 6 m, horizontal GF circulation with repeated art/light/ceiling bays |
| Upper Landing | (0,6.4,-57) | 32 x 6 m rear deck | Side returns 6 x 20 m; principal void open to stair hall below |
| Upper Corridor | (68,6.4,-57) | 104 x 8 m | 6 m, bedroom/bathroom sockets on both sides |
| Drawing Room | (24,0,-30) | 16 x 16 m | 5.5 m, seating group, table, rug, walnut panels, artwork, lamps and ceiling detail |

Grand staircase: 6 m wide, 18 m run, 6.4 m rise, 32 visible steps. Toe Z=-36; top Z=-54; rear landing Z=-54..-60. Ramp collision provides continuous movement, with slope handrails, open balusters and continuous balcony guards. Side balcony entry lanes X=10..16 and -16..-10 remain open. A lower west-wing marker at (-16,0,-42) is reserved/inactive; the east GF gallery and east UF corridor are live connections.

Service staircase: 4 m wide, 12 m run, 6.4 m rise, 32 steps, under the kitchen. Its shaft is explicitly cut through kitchen floor, utility ceiling and exterior ground collision. All exposed upper edges are guarded except the authored stair entry.

The machine-readable authority is godot/assets/neon-mansion/layout/mansion_layout.json: 43 named spatial definitions, 41 doors, 22 fixed/random/special socket definitions and two vertical connections. These are shell/discovery spaces, not 43 furnished rooms. The Drawing Room is retained in addition to the map's Lounge. The additional UF-R02 is an authored reserved socket.

### Map structure implemented

- Exterior: Driveway, Front Garden, Rear Garden, Pool Terrace, Shed / Workshop and Garage. Outdoor ground is shared and traversable around the mansion. Gardens and pool are structural placeholders; no swimming or complete landscape dressing.
- GF anchors: Entrance Hall, Foyer / Reception, Grand Stair Hall, Long Gallery, Lounge, Kitchen and Pool Hub, plus the Drawing Room benchmark.
- GF defined shells: Pantry, Dining Room, Library, Study, Conservatory, Home Theatre, Games Room, Gym, Arcade and GF-R01.
- UF: Upper Landing/open stair void, Upper Corridor, Master Bedroom, En-Suite 1, Bedroom 2, En-Suite 2, Bedrooms 3 and 4, Bedroom 5 / Attic special shell, Bathrooms 1 and 2, Guest Lounge, UF-R01 and UF-R02.
- Basement: Kitchen service descent -> Utility / Service -> Service Corridor -> Wine Room -> Security / CCTV -> Cyber Room / Mainframe. Wine/security connect sideways; the mainframe turns north beyond security. It is a progression route, not a decorative straight row.

The attic is a special upper-floor shell; no additional attic storey/access stair has been added. Wine/security are designated future locked destinations, but all foundation doors are operable and no lock gameplay is implemented.

## Random sockets and persistence

All variation is constrained to explicit socket IDs. Fixed and special shells also have socket records, so later furnishing cannot alter the circulation spine. Each record includes floor, wing/zone, world transform, entry orientation/offset, footprint/size class, permitted categories, exterior-window flags, plumbing/service constraints, door transforms, safe clearance and prop exclusions. Fixed shells do not randomly populate.

GF-R01 is the working prototype, at (112,0,-30), 16 x 16 m, with its north doorway at (112,0,-38). It accepts two authored templates in layout/room_templates.json:

- music: Music Salon, with seating, cabinet and table.
- study: Private Study, with desk/table, chair and shelving.

Both reuse exactly the same shell, doorway and corridor. Furniture is authored outside the door exclusion lane, and actual vendor mesh bounds are checked against the shell and exclusions during validation. The shared content builder uses the real inspected KayKit furniture assets.

socket_assignments.gd validates footprint, category, floor, wing, entry edge/offset/width, service requirements and window constraints. It stores the selected template immediately when first assigned. Returning/reloading uses that assignment, irrespective of a changed seed. Malformed/incompatible saves are preserved and reported, not silently overwritten.

The current prototype default run_seed=0 chooses music for a fresh file. This is a deterministic foundation, not unrestricted random generation. Runtime assignments default to work/map-foundation/run-state.json inside the repository. For a separate test run, set assignment_file to a NEW path under work/map-foundation and use run_seed=1 to choose study. Do not discard existing run files. UF-R01/UF-R02 and the fixed socket records remain reserved shells.

## Door system

All eight existing families remain intact: standard, luxury, grand double, bedroom/bathroom, service, theatre/games/arcade, security/cyber and exterior/garden. One additional grand_anchor profile/scene reuses the same door system with two 3 x 5 m leaves, in 6.2 x 5.12 m portals for the entrance/foyer/stair/gallery/landing anchors.

Historical IDs:
- door_entrance_stair retains entrance_hall -> grand_stair_hall semantic links, records via foyer_reception, and sits at the foyer/stair boundary.
- door_stair_gallery retains grand_stair_hall -> long_gallery; it is now at the ground-floor east opening.
- door_gallery_drawing retains long_gallery -> drawing_room; it now connects the ground-floor gallery to the benchmark.

Interaction/controller code, opening timing, debounce, raycast owner lookup and signals were not changed. Normal single-leaf dimensions remain 1.92 x 2.78 x 0.16 m. The two anchor doors among the historical IDs now use the deliberately larger double-leaf collider profile; this is a documented scale/geometry change, not removal of collision. Decorative hardware, frames, panels and lights remain collision-free. All 41 installed doors passed closed-block/open-pass/close and ray-owner checks.

## Visual/art integration

New reusable interior_kit.gd and light_fixture.tscn/gd provide pilasters, panel mouldings, brass dado/coffer details, framed art, decorative smoked sash windows, practical sconces, simplified chandeliers, labels and furniture wrappers. Materials remain shared Neon Mansion resources: teal/charcoal, near-black doors, dark tile/marble, walnut, brass/dark metal, smoked glass, magenta and cyan trim, acid-green diagnostics. garden_ground.tres adds a restrained owned outdoor material.

Normal lighting mixes cool practicals with restrained warm luxury accents; a shadowed exterior moon improves the approach. Subtle fog, restrained glow and 32-step screen-space reflection settings support readability. Neon is concentrated on door frames, occasional stair treads and short indicators rather than every edge.

All 25 architectural boards (11 pack 1, 14 pack 2) were individually opened and classified. layout/architecture_manifest.json records filename, observed contents, roles, suitability, corresponding Godot helper and Photoshop requirements.

Useful current references:
- Pack 2 boards 1/11: wall mouldings, wainscot/bay/pilaster grammar.
- Pack 2 boards 3/12: coffered/ornate ceiling grammar.
- Pack 2 boards 5/13: sconce/chandelier/practical fixture silhouettes.
- Pack 2 board 4: smoked/privacy/sash window vocabulary.
- Pack 2 board 6: upholstery/walnut/brass palette.
- Pack 2 board 7: room/access signage vocabulary, rebuilt as literal Godot labels.
- Pack 1 board 10: warm/cool luxury lighting balance.
- Surface/floor swatch boards: existing procedural material families, never whole-board UV textures.

No new raw architecture bitmap was promoted into a runtime texture. Labelled swatch sheets, modelling studies and composite masks remain reference-only. The checkpoint replaces provisional raw-board sampling with two owned procedural placeholder art designs in the same frames. No raw Firefly bitmap is required by the committed runtime; originals remain untouched locally.

All 25 architectural composite images require component extraction/redrawing and Photoshop cleanup before direct texture/decal/screen/overlay use. Common work: remove captions/borders/checkerboards/backgrounds, verify real alpha, straighten perspective, remove baked glow/reflections, repair generated text, make suitable planar swatches seamless, separate normal and corrupted layers. Pack 1 boards 5/6/7/8/9 and pack 2 boards 4/7/8/9 contain potentially useful decal/screen/backdrop/mask/VFX components; none is approved wholesale.

The earlier nine door boards remain modelling references; see architecture/doors/firefly_door_manifest.json. The earlier material pack classification remains materials/firefly_manifest.json. The 30 room concepts are described in design/room-catalog.json, but their image folder is absent locally. Drop Zone was not accessed or imported during this pass.

## Nightmare Frequency

NightmareLayer remains separate, invisible and disabled by default. Every door's Nightmare overlay also defaults off and passed the final checks. The master layer lists prepared hooks for emissive cracks, code contamination, corrupted signage, Jester interference, glitch overlays and altered lights. Labels and fixtures expose hook groups; light fixtures can restore their normal colour after a future frequency change. Normal geometry/materials have no dependency on an enabled corruption state. Full corrupted gameplay/VFX are not implemented.

## Validation

Installed executable: C:\Users\doret\Videos\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64.exe. Reported engine version 4.7.2.stable.official.ed1daf0bf.

- Main project and rendered skeleton load successfully.
- Headless deterministic 60-FPS physics: all 41 actual doors, IDs/links, arrival route and return, ascent/descent of grand stairs, both balcony guard directions, landing and upper corridor alignment, service stair descent/ascent, basement progression and return.
- Walking lanes on both sides of the Drawing Room seating/table pass.
- Both random templates: identical shell/door/corridor, actual mesh bounds within shell and clear of the door exclusions, traversable entrance, saved assignment reload without reroll.
- Authored room footprint overlap checks pass at each level. Open landing/ground overlay volumes are intentional.
- Room graph reachability covers all 43 IDs. This is traversal/adjacency validation, not an AI NavigationMesh bake.
- Rendered input: pointer capture, yaw/pitch and limit, keyboard movement, focused E opening and reverse-side leaf closing, Escape release and click recapture pass.
- Nightmare master and all door layers remain off.
- No parser/resource/shader errors in final checks.log, input.log, render.log or final-detail-render.log.
- Nine camera PNGs under work/map-foundation were generated and visually reviewed; final foyer/gallery details were recaptured after the sign/headroom adjustment.

Development checks caught and fixed the terrain bridging the service shaft and a balcony guard closing the side return. Early failed test logs are retained for traceability. The initial headless mouse-input attempt was an unsuitable input harness; rendered input verifies the real controller instead.

## Remaining limitations / bugs

No unresolved blocking traversal, collision, parser or resource failures in the final tests. Manual feel/scale approval is complete for Baseline v1. Hardware performance profiling remains future work. Exterior landscaping/roof silhouette, ordinary room furnishing, pool swimming, attic ascent, locks/puzzles, complete Nightmare VFX, AI navigation and networking are outside this foundation implementation. Decorative windows are smoked panels on opaque wall backing, not full cut-through openings. Runtime room nodes are built from authored JSON when playing; the editor entry scene itself remains compact.

The existing player fall-respawn behavior is unchanged. Normal basement floor at -6.4 m stays above its -10 m fallback threshold.

## Checkpoint and next work

Baseline v1 is recorded in local commit 0fd277c1c31b4506e7ae1901504faeb152ce843b. The subsequent visual upgrade remains uncommitted. Do not push without separate authorization.

Further furnishing may build on this approved skeleton. Preserve the anchor proportions, stair/landing connections, door IDs and socket rules; record any proposed structural alteration in the permanent map/changelog before implementation.

Reproducible validation harnesses are in `tools/validation/check_mansion.gd` and `tools/validation/check_input.gd`. Run them against `godot/` using the installed Godot executable (headless fixed-fps 60 for the mansion checks; rendered mode for input). They write run/test artifacts only beneath the ignored `work/` folder. Local historical screenshots/logs and inventories remain there but are excluded from the checkpoint, as are raw Firefly references and `.godot/` caches. Godot `.import` settings and stable `.uid` sidecars remain tracked source metadata.
