# Flat style handoff

For Codex, who built `foundation.tscn` and will do the integration. Branch: `long-gallery-flat`, tracking `origin/long-gallery-flat`. At this handoff check, local HEAD is one commit ahead of origin; three additional scene/import metadata files are modified in the working tree. Godot 4.7.2, Forward+.

## 1. Style rules

- Flat colour fills, black ink outlines, one hard shadow step.
- No gradients, no reflections, no glow, no textures on surfaces.
- Lighting is added later. Until then shadow is baked per face: a shaded face simply uses the shadow colour.
- 8 colours per room, never a 9th. The palette can change per room.
- Outlines are about 2 px at 1376 px wide, hard-edged.
- One allowed exception to "no glow": the screen in the Grand Stair Hall.

## 2. Palettes

**Long Gallery** (all 8 in use)

| Colour | Hex | Material |
|---|---|---|
| Wall | `#152731` | `flat_wall.tres` |
| Ceiling, far wall | `#0D161B` | `flat_ceiling.tres` |
| Floor | `#201827` | `flat_floor.tres` |
| Ink, door openings | `#000000` | `flat_ink.tres` |
| Pink main | `#B33E68` | `flat_trim_light.tres` |
| Pink shadow, skirting | `#872347` | `flat_trim_mid.tres` |
| Accent panel | `#5B0135` | `flat_accent_panel.tres` |
| Accent signal (plates) | `#60C59B` | `flat_accent_signal.tres` |

**Grand Stair Hall and Master Bedroom** (5 in use so far)

| Colour | Hex | Material | In use |
|---|---|---|---|
| Abyss Black (ink, door openings) | `#01050B` | `flat_abyss_black.tres` | yes |
| Deep Navy (walls, ceiling) | `#091E30` | `flat_deep_navy.tres` | yes |
| Petrol Teal (floor, stair surfaces) | `#184157` | `flat_petrol_teal.tres` | yes |
| Neon Magenta (trim, rails, far panel) | `#BB2C8B` | `flat_neon_magenta.tres` | yes |
| Electric Aqua (number plates) | `#13DCAF` | `flat_electric_aqua.tres` | yes |
| Shadow Teal (shading step) | `#2B777B` | `flat_shadow_teal.tres` | no |
| Neon Mint (detail) | `#72D9CA` | `flat_neon_mint.tres` | no |
| Soft Highlight (tiny details) | `#E0E9F4` | `flat_soft_highlight.tres` | no |

## 3. What exists

All paths are under `godot/assets/neon-mansion/` unless stated.

- **Materials:** `materials/flat_*.tres` (16 files, listed above). Unshaded `StandardMaterial3D`, colour only, so the rendered fill is the exact hex.
- **Outline shader:** `materials/shaders/flat_outline.gdshader`.
- **Look-test scenes** (fixed camera, no player, no collision, not walkable):
  - `scenes/long_gallery_flat.tscn`, built by `scripts/long_gallery_flat.gd`
  - `scenes/grand_stair_hall_flat.tscn`, built by `scripts/grand_stair_hall_flat.gd`
- **Screen frames:** `textures/grand_stair_hall/screen_frame_01.png` to `screen_frame_04.png`, played by `scripts/screen_flipbook.gd`.
- **Tile overlay:** `textures/grand_stair_hall/tile_overlay.png`, controlled by `scripts/tile_overlay.gd`.
- **Benchmarks:** `design/reference/grand-stair-hall/` in the repo root holds `grand_stair_hall_benchmark.png`, `master_bedroom_benchmark.png` and source copies of the frames and overlay. This folder is **not committed**; it exists only on the author's machine. The Long Gallery benchmark is also local only, at `work/long-gallery-flat/benchmark.png` (`work/` is git-ignored).
- **Style lock for the Long Gallery:** `docs/ART_DIRECTION.md`.

There is no Master Bedroom scene yet, only its benchmark.

## 4. How each piece works

**Outline shader.** It is a full-screen pass that belongs to one camera. In the look tests it is a `MeshInstance3D` named `Outline`, a child of the `Camera3D`, with a 2 × 2 `QuadMesh`, a `ShaderMaterial` using the shader, shadows off and a very large `extra_cull_margin` so it is never culled. To use it in the game, add the same node under the player's camera (`player/test_player.tscn` → `Camera3D`). It then outlines everything that camera sees, in every room; the HUD is unaffected.

It draws ink where the fill colour changes, where the surface plane changes, or where the surface angle changes. It also draws floor tile seams from positions you give it:

- `ink`: line colour (black for the gallery, Abyss Black for the hall).
- `gallery_from_world`: the room's inverse global transform, so seams are measured in room space.
- `seam_x` (up to 4) and `seam_z` (up to 12) with their counts: seam positions in metres. Seams only appear on surfaces within 2 cm of the room's local height 0.

The room scripts set these in `_ready()` on `$Camera3D/Outline`. With a shared player camera the seam values must be set for whichever room the player is in. Two limits to plan for: one set of seams at a time, and the 4 and 12 caps.

For exact colours the environment must not alter them: linear tonemap, no glow, no fog, no SSR. `foundation.tscn` currently uses filmic tonemap, glow, SSR and fog.

Anything that must stay un-outlined and drawn on top (the screen, the tile overlay) uses a transparent material with `render_priority = 1`, so it draws after the outline pass.

**TileOverlay.** A separate node named `TileOverlay` in `grand_stair_hall_flat.tscn`: a flat plane just above the floor. It has two inspector settings, `enabled` (on/off) and `opacity` (0 to 1, default 0.25). It can be hidden or deleted without touching anything else.

**Screen flipbook.** A node named `Screen` in the far-wall panel of the hall. `frames` holds the four textures and `frames_per_second` is 1.0; the script swaps the material's texture in a loop. It has no glow yet.

## 5. Not done

- Nothing is wired into `foundation.tscn`. The flat rooms are separate look tests.
- The 8 Grand Stair Hall materials are not in `material_library.gd`. (The 8 Long Gallery ones are, under `FLAT`.)
- The Grand Stair Hall side-wall exits are not modelled: west to Reception; east to the Lounge, Long Gallery and Pool Hub. The stairs lead to the Upper Landing, which is also not modelled.
- No collision, no lights, no door interaction in either flat scene.
- No Master Bedroom scene.
- The live mansion has 7 doors per side in the Long Gallery; the flat look test has 4, as drawn in its benchmark.

## 6. How to check the work

1. Render a 1376 × 768 view from the benchmark position.
   - Long Gallery: eye height 1.2 m, vertical FOV 27.8°, pitched 0.8° down, looking along the corridor.
   - Grand Stair Hall: eye height 1.6 m, vertical FOV 56.6°, pitched 2.2° down, looking at the far wall.
   - Exact transforms are on `Camera3D` in each look-test scene.
2. Compare it to the benchmark by eye, and with the benchmark laid over the render at 50% opacity. A few pixels off is fine.
3. Confirm only palette colours are used: count the distinct colours in the render and check each against the room's table. Do this with the screen and `TileOverlay` hidden, since both add non-palette colours on purpose. Expect 8 colours for the Long Gallery and 5 for the Grand Stair Hall.
4. Run `tools/validation/check_mansion.gd` to confirm the mansion still passes after integration.
