# Visual material integration — 5 October 2026

## Result and limits

Only the existing Entrance Hall -> Grand Stair Hall -> Long Gallery -> Drawing
Room slice was changed. No additional rooms, generation, save system or networking
was added. Current local files were inspected before edits; existing uncommitted
work was retained. No reset, clean, checkout, deletion, commit, merge or publication.

The material system contains twelve normal families and two separate Nightmare
families. Existing six material paths remain valid; shader-backed surfaces now
provide world-coordinate tile joints, restrained marble veining, subtle walnut
grain and dark/brushed metal without relying on KayKit UV scaling.
Normal shared materials are immutable defaults: duplicate before tuning an
instance. Room scenes export wall, floor and lower-wall material slots.

Entrance Hall and Grand Stair Hall use dark marble; Long Gallery uses dark tile;
Drawing Room uses walnut flooring, walnut table/panelling and charcoal upholstery.
Teal walls, near-black doors, brass/metal rails and small cyan fixtures create
contrast. Continuous glowing wall borders were replaced by dark moulding,
brass panel edges and short magenta guide accents. Door frames and stair nosings
retain hot-magenta emission. Cyan fill is restrained; the Drawing Room has a
local warm accent. Added moulding, fixtures and artwork have no collision.

Room IDs, door IDs, portal dimensions/positions, floor elevations, stair wedge,
rail collision, furniture collision and player behaviour are unchanged.
NightmareLayer remains invisible and disabled and references only its separate
corruption resources. Activating the placeholder layer does not mutate normal
materials. Real corruption transitions/VFX remain future work.

## Firefly inspection and use

Every source was viewed individually at 1025 x 1025. All eleven are labelled
composite/reference boards. None is approved as a direct tiling runtime texture.
The manifest is godot/assets/neon-mansion/materials/firefly_manifest.json.
It records each actual filename, observed contents, classification, direct-use
suitability, intended role, corresponding resource/helper and cleanup work.

Filename prefix below:
Retro_Nightmare_Frequency___Scene_1_Production_Board-
All files are .png under materials/firefly-source/nightmare-fx/.

| Suffix | Actual contents | Use in this pass |
| --- | --- | --- |
| 1 | 3x3 labelled teal, charcoal, black door, tile, marble, walnut, panel, brass and black-metal samples | Surface palette/finish reference |
| 2 | Smoked/frosted glass, tiles, carpet, concrete, masonry and corruption composite | Smoked-glass and dormant corruption reference; other surfaces deferred |
| 3 | Fabric/chrome/crack/stone/plaster/leather/rubber/black-paint/mesh sheet | Dark metal, charcoal and dormant corruption reference |
| 4 | Clean/glitched emissive bars, indicators, signs and terminals | Geometric emission and access-indicator reference |
| 5 | Decals/icons/damage/corruption contact sheet with visible checker pattern | Future decal candidates; no runtime use |
| 6 | Screens/UI/terminals, gothic painting, abstract art and poster contact sheet | Two provisional artwork regions sampled in the existing gallery frames |
| 7 | City/driveway/gardens/pool/storm/corrupted-sky cinematic plates | Future backdrop reference; no exterior built |
| 8 | Code rain/glyphs/scanlines/tears/bursts/clouds/cracks/Jester/sigil VFX sheet | Deferred Nightmare VFX reference |
| 9 | Door/window/screen/trim/zone masks and combined mask sheet | Mask planning reference; no runtime mask bound |
| 10 | Cyan/magenta/moonlight/green-corruption/warm-light comparisons | Controlled normal lighting reference |
| 11 | Material naming guide and small swatches | Material organisation and palette reference |

Board 6 is the only bitmap used in the running slice. The artwork helper reads the
unchanged local source as an ImageTexture and its shader samples verified
label-free rectangles: gothic painting (42,556,284,166), abstract art
(373,557,280,165). These are aspect-fit framed artwork, not tiling surfaces.
No image was cropped, edited, duplicated or regenerated. The samples are local
prototype integrations, not approval of raw sources as final production assets.
The checkerboard sheets were not mistaken for transparent assets.

## Photoshop cleanup before production

- Boards 1–3: if producing surface maps, isolate swatches, remove labels/borders,
  remove baked gradients/highlights, fix seams and author proper roughness/normal
  maps. Separate crack base/albedo and emission masks. Reference-only use itself
  needs no cleanup.
- Board 4: isolate components, remove captions/black matte/baked bloom, and
  separate crisp emission masks from glow or glitch variants.
- Board 5: extract icons, remove the visible checker background and headings,
  verify real alpha, clean edges and redraw small/illegible labels.
- Board 6: export the two used paintings as separate artwork with clean margins
  and sufficient resolution. Screen/UI cells additionally need readable text
  and removal of headings, frames or generated text artifacts.
- Board 7: extract plates and remove dividers/titles; review generated details.
  Perspective sky plates cannot be dropped in as spherical sky maps.
- Board 8: split effects into sprites/masks, remove labels/checker backgrounds,
  verify alpha and make overlays suitable for animation and compositing.
- Board 9: extract/normalize masks and redraw them to match actual mansion meshes;
  the combined reference is not a packed mask for these rooms.
- Boards 10–11: useful as references without cleanup. They are not runtime
  lightmaps, LUTs or surface textures.

## Validation

Installed engine: Godot 4.7.2 stable, ed1daf0bf.
D3D12 / Forward+ rendering completed and four room views were inspected.
All fourteen material families were rendered in a separate sample scene,
including both dormant corruption shaders; normal mansion stayed uncorrupted.
No parser/resource/shader errors appeared in the validation logs.
Existing physics walkthrough passes with the same positions:
stair landing (-0.000004, 3.200271, -18.32104),
gallery (-0.000004, 3.200271, -32.12123),
drawing room (3.666658, 3.200271, -32.05456).
Material count, eleven-source manifest, disabled layer and no normal-material
mutation on layer toggling checks pass. git diff --check passes.
SHA-256 checks verify all 4,666 protected KayKit/Firefly files unchanged.
All snapshotted pre-existing files remain present; project.godot, controller,
architecture collision helpers and earlier foundation validation files were
not edited by this pass.

## Exact created source files

- godot/assets/neon-mansion/materials/brass.tres
- godot/assets/neon-mansion/materials/dark_marble.tres
- godot/assets/neon-mansion/materials/dark_metal.tres
- godot/assets/neon-mansion/materials/dark_tile.tres
- godot/assets/neon-mansion/materials/firefly_manifest.json
- godot/assets/neon-mansion/materials/material_library.gd
- godot/assets/neon-mansion/materials/shaders/firefly_artwork.gdshader
- godot/assets/neon-mansion/materials/shaders/nightmare_corruption.gdshader
- godot/assets/neon-mansion/materials/shaders/stylised_surface.gdshader
- godot/assets/neon-mansion/materials/smoked_glass.tres
- godot/assets/neon-mansion/materials/walnut.tres
- godot/assets/neon-mansion/nightmare-fx/materials/corruption_base.tres
- godot/assets/neon-mansion/nightmare-fx/materials/corruption_emissive.tres
- godot/assets/neon-mansion/scripts/firefly_artwork.gd
- docs/MATERIAL-INTEGRATION.md (this report)

## Exact modified source files

- godot/assets/neon-mansion/materials/acid_green.tres
- godot/assets/neon-mansion/materials/charcoal.tres
- godot/assets/neon-mansion/materials/cyan_indicator.tres
- godot/assets/neon-mansion/materials/dark_teal.tres
- godot/assets/neon-mansion/materials/magenta_trim.tres
- godot/assets/neon-mansion/materials/near_black.tres
- godot/assets/neon-mansion/rooms/drawing_room.tscn
- godot/assets/neon-mansion/rooms/entrance_hall.tscn
- godot/assets/neon-mansion/rooms/grand_stair_hall.tscn
- godot/assets/neon-mansion/rooms/long_gallery.tscn
- godot/assets/neon-mansion/scenes/foundation.tscn
- godot/assets/neon-mansion/scripts/door.gd
- godot/assets/neon-mansion/scripts/foundation.gd
- godot/assets/neon-mansion/scripts/nightmare_layer.gd
- godot/assets/neon-mansion/scripts/room.gd
- godot/assets/neon-mansion/scripts/staircase.gd

## Created validation files

All are inside work/material-integration/; previous work/foundation files remain
untouched. file-report.json also provides a machine-readable inventory.

- before-files.json
- before-status.txt
- capture_material_pass.gd
- check_material_pass.gd
- capture_material_library.gd
- walkthrough.log
- materials.log
- render.log
- material-render.log
- entrance.png
- grand_stair.png
- gallery.png
- drawing_room.png
- material_families.png
- file-verification.json
- file-report.json

Total: 31 created files (14 asset/system files, this report and 16 validation
files) and 16 modified source files. Paths above are relative to
C:/GitHub/neon-mansion. Engine caches are local ignored artifacts, not vendor
or game source. No file from the original source packs was altered.

## Baseline v1 checkpoint update — 5 October 2026

The earlier Board 6 runtime atlas trial has been replaced by owned procedural placeholder artwork in the same frames. All raw Firefly sources remain reference-only and are excluded from the checkpoint. The artwork helper/shader names are retained for scene compatibility; neither loads a source image. This update supersedes the historical bitmap-use notes above. Final extracted paintings/screens still require cleanup and deliberate production approval.
