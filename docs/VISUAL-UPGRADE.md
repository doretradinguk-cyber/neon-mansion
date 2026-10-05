# Visual quality pass — 5 October 2026

This local, uncommitted pass builds on approved Baseline v1 (`0fd277c`). The fixed map, room and door IDs, door dimensions/hinge motion, collision, player controller, basement route and persistent socket architecture are preserved. No vendor sources or raw Firefly images were edited. Nothing was pushed.

## Comparison before editing

Reviewed all 45 local images: 11 imported material boards, nine door boards, and 25 architecture boards. Pack 1 repeats the earlier material reference vocabulary. Compared these with six newly captured baseline views (Entrance, Foyer, Grand Stair Hall below/above, Gallery and Drawing Room).

The baseline used thin flat frames, a vendor door silhouette with oversized inherited hardware, sparse wall/ceiling profiles, simple rod chandeliers, broad specular light pools and nearly uniform surfaces. Firefly instead emphasizes layered teal casing depth, black inset fields, coherent gothic moulding, small integrated controls, restrained metal hardware and more deliberate architectural profiles. No whole source sheet was suitable as a final runtime surface.

## Implemented visual changes

- Doors: connected deep jamb reveals; stepped casings, plinths and lintels; threshold plates; continuous inset magenta trim; literal caption/number plaques; framed access panels with buttons; cylinder hinges, lock roses, lever/pull hardware and push plates. The original KayKit wrapper remains for its exact collider/interaction ownership while its inherited visible mesh is hidden locally and replaced by owned geometry.
- Families remain distinct: simple standard panel; nested luxury tracery; paired grand leaves (including existing enlarged anchor preset); frosted privacy insert; service porthole/PUSH plate; theatre cyan spine; security seams/bolts/keypad; garden glazing/mullion. No profile dimensions changed.
- Entrance/Foyer: inset wainscot, crown/dado/skirting profiles, fluted pilaster detailing, rear-wall panels, floor compass inlay, foyer runner and console art.
- Grand Stair Hall: original staircase and balcony positions preserved; denser decorative balusters, collars, newel caps, diamond motifs, stair runner/edge borders, arrival runner and an applied stained-glass triptych above the rear landing.
- Gallery: black tiled floor and burgundy runner; repeated ceiling brackets/coffers, mouldings, wainscot, upgraded doors and sconces. Existing art bays remain.
- Drawing Room: separate upholstery finishes, burgundy rug, deeper coffer and wall profiles, glazed wall features, ceiling rosette and small tabletop objects. Furniture arrangement/collision stays as approved.
- Lighting: modelled warm/cool downlight sconces, ring flush fixtures and suspended ring chandeliers. Ambient fill tuned; specular wash reduced; six localized magenta fill lights and two low-specular stair readability fills added. Distance fading limits practical-light reach. Nightmare hooks remain separate and off.
- Performance: twelve-sided shared cylinder meshes; decorative meshes combined by material within door frames, moving leaves, fixtures, hero overlays and railing/stair modules. No per-frame geometry generation or additional decorative collision.

## Material changes

Updated teal, dark marble, dark tile, walnut, brass, smoked glass and the shared stylised shader. Added frame teal, dark wood panels, frosted glass, black/teal upholstery, burgundy carpet and warm lamp emission; registered them in the reusable normal material library. Smoked/frosted glass is deliberately opaque and reflective/softly lit on backed panels to avoid transparency sorting and false views through solid architecture.

The first render review rejected overly bright marble veins and found frame/caption overlap. Veining was subdued, gallery flooring switched to dark tile, captions moved forward and coffer seams separated before final captures.

## Firefly usage and Photoshop work

`godot/assets/neon-mansion/layout/visual_upgrade_manifest.json` records all reviewed sources and the helper/material mappings. Most useful: door boards 1–9; architecture pack 2 boards 1/11 (trim), 3/12 (ceilings), 4 (glass), 5/13 (fixtures), 2/6/14 (floor/furniture finishes), and 7 (signage); material boards 1/2/3/10/11 (palette and light balance).

No bitmap was promoted. Composite material sheets need clean, seamless component extraction and authored material channels. Door boards are modelling references, not consistent orthographic assets. Decal/screen/sign sheets need clean backgrounds/real alpha and redrawn text. Artwork needs separate clean production exports. Damage/Nightmare sheets need isolated masks and emissions; they remain deferred. All original sources are unchanged.

## Entrance Hall follow-up

A mirrored pair of low walnut-and-burgundy salon benches was added to the side bays in `hero_visuals.gd`, leaving the compass inlay and central arrival axis clear. These are visual-only meshes with no collision or map changes. This follow-up has not yet been run through Godot or visually checked.

## Validation and visual review

Godot 4.7.2 foundation checks cover all 41 doors, route/return, staircase ascent/descent, balcony guards, upper landing, basement progression, Drawing Room furniture lanes and both persistent socket templates. The planning snapshot must still match the runtime map. Rendered input checks cover movement, mouse look, interaction and cursor capture. Final results and remaining gaps are recorded in HANDOVER.md.

Local comparison captures and logs are under ignored `work/visual-upgrade/`. They include six matched before/after room views and closed/open views of all nine existing door presets. These are review artifacts, not project dependencies.

## Remaining visual gaps

The approved rectangular openings limit fidelity to Firefly's fully pointed door silhouettes: this pass uses applied curved mouldings without cutting new apertures or changing collision. Art is still procedural placeholder work. Windows remain decorative backed panels, not exterior views. Furnishing outside the five hero spaces, production portraits, fine sculpted gothic ornaments and hardware performance profiling remain future work. This pass improves the stylised interpretation rather than claiming an exact reproduction of generated artwork.

## Complete project file inventory

Changed or created project files: 29. Local captures/logs are separately inventoried under work/visual-upgrade/FILES.md.

- `docs/HANDOVER.md`
- `docs/MANSION-CHANGELOG.md`
- `docs/VISUAL-UPGRADE.md`
- `godot/assets/neon-mansion/layout/visual_upgrade_manifest.json`
- `godot/assets/neon-mansion/materials/brass.tres`
- `godot/assets/neon-mansion/materials/burgundy_carpet.tres`
- `godot/assets/neon-mansion/materials/dark_marble.tres`
- `godot/assets/neon-mansion/materials/dark_teal.tres`
- `godot/assets/neon-mansion/materials/dark_tile.tres`
- `godot/assets/neon-mansion/materials/dark_wood_panel.tres`
- `godot/assets/neon-mansion/materials/frame_teal.tres`
- `godot/assets/neon-mansion/materials/frosted_glass.tres`
- `godot/assets/neon-mansion/materials/lamp_warm.tres`
- `godot/assets/neon-mansion/materials/material_library.gd`
- `godot/assets/neon-mansion/materials/shaders/stylised_surface.gdshader`
- `godot/assets/neon-mansion/materials/smoked_glass.tres`
- `godot/assets/neon-mansion/materials/upholstery_black.tres`
- `godot/assets/neon-mansion/materials/upholstery_teal.tres`
- `godot/assets/neon-mansion/materials/walnut.tres`
- `godot/assets/neon-mansion/scenes/foundation.tscn`
- `godot/assets/neon-mansion/scripts/balcony_railing.gd`
- `godot/assets/neon-mansion/scripts/door_visual.gd`
- `godot/assets/neon-mansion/scripts/door.gd`
- `godot/assets/neon-mansion/scripts/hero_visuals.gd`
- `godot/assets/neon-mansion/scripts/interior_kit.gd`
- `godot/assets/neon-mansion/scripts/light_fixture.gd`
- `godot/assets/neon-mansion/scripts/mansion_skeleton.gd`
- `godot/assets/neon-mansion/scripts/staircase.gd`
- `godot/assets/neon-mansion/scripts/visual_geometry.gd`
