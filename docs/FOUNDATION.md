# Neon Mansion first playable foundation

Run godot/project.godot in Godot 4.7 and press F6 on foundation.tscn, or F5.
WASD/arrows move, mouse looks, E opens/closes a focused door within 3m.
Escape releases the cursor; left-click captures it.

Route: Entrance Hall -> Grand Stair Hall -> climb stairs -> upper landing ->
Long Gallery -> Drawing Room on the right. This is a new four-room grid slice,
not a recreation of the older extracted room bounds.

## Modular structure
Project-facing files are under godot/assets/neon-mansion/.
Rooms are separate scene instances with footprints in metres, an interior shell,
collision, room IDs, role and discovery volume. Architecture/module.tscn wraps
an inspected KayKit mesh with size, material and collision parameters. It can be
instanced independently as wall, floor or other primitive. Doors and stairs have
their own reusable scenes. Construction currently runs on play; room scene
shells are not baked into the editor viewport.

The main scene places the anchor rooms. Portal dictionaries identify a wall,
opening offset and elevation. Each room owns its inset interior wall faces,
so adjacent shells do not overlap. Floor and wall segmentation use a 4m grid.
Grand Stair Hall provides 7.2m headroom, an 8m stair run rising 3.2m and guarded
upper landing. Stair collision is a continuous wedge for reliable walking.

Door IDs map two room IDs and emit state_changed. The registry indexes rooms
and doors, asserts unique IDs and valid links, and records first discovery
without replacing the room. This is an in-session persistence seam only:
future generation must store seed/layout/scene/state by room ID and serialize
the registry to retain discoveries across sessions. Generation, saving and
networking are intentionally not implemented in this first slice.

Player input/camera are instance-owned via local_control. Collision layer 1
is world architecture; layer 2 is players. No player singleton or networking
was introduced. A future remote player must be driven externally.

Normal materials use restrained flat colour, Godot's toon diffuse mode and
disabled specular highlights. Emissive magenta, green and cyan accents have
separate resources. NightmareLayer is disabled by default and owns future
effects; normal shared materials are never mutated by that layer.

## Referenced vendor models (no copies or vendor changes)
Prototype Bits / Assets/gltf: Primitive_Wall.gltf, Primitive_Floor.gltf,
Primitive_Stairs.gltf, Door_A.gltf.
Furniture Bits / Assets/gltf: couch.gltf, table_low.gltf, armchair.gltf,
pictureframe_large_A.gltf.
All are loaded from the existing godot/addons/kaykit_* folders.
Runtime material_override is per instance; imported source materials remain intact.

## Files created
- assets/neon-mansion/scripts/architecture.gd
- assets/neon-mansion/scripts/room.gd
- assets/neon-mansion/scripts/door.gd
- assets/neon-mansion/scripts/staircase.gd
- assets/neon-mansion/scripts/player.gd
- assets/neon-mansion/scripts/foundation.gd
- assets/neon-mansion/scripts/nightmare_layer.gd
- assets/neon-mansion/architecture/module.tscn
- assets/neon-mansion/architecture/door.tscn
- assets/neon-mansion/architecture/staircase.tscn
- assets/neon-mansion/rooms/entrance_hall.tscn
- assets/neon-mansion/rooms/grand_stair_hall.tscn
- assets/neon-mansion/rooms/long_gallery.tscn
- assets/neon-mansion/rooms/drawing_room.tscn
- assets/neon-mansion/player/test_player.tscn
- assets/neon-mansion/scenes/foundation.tscn
- assets/neon-mansion/nightmare-fx/nightmare_layer.tscn
- assets/neon-mansion/materials/dark_teal.tres
- assets/neon-mansion/materials/charcoal.tres
- assets/neon-mansion/materials/near_black.tres
- assets/neon-mansion/materials/magenta_trim.tres
- assets/neon-mansion/materials/acid_green.tres
- assets/neon-mansion/materials/cyan_indicator.tres
- docs/FOUNDATION.md (this document)

All asset paths above are relative to godot/.
Modified: godot/project.godot (main scene and movement/interaction input actions).
Validation scripts and logs are kept in work/foundation/ inside this repository.
Godot may generate local .godot cache files. No merge, commit or publication.

## Validation and complete auxiliary file inventory

Validated with the existing Godot 4.7.2 stable executable:
- Main scene loads without script/runtime errors.
- Automated capsule walkthrough passes: closed door collision; focused door
  interaction; entrance -> stair ascent -> landing at Y=3.2 -> gallery ->
  drawing room and exit; gallery wall collision; repeat discovery retains records.
- Four rendered views inspected with the project's D3D12 / Forward+ renderer.
- All 4,655 vendor files match the before-build SHA-256 snapshot. No vendor
  files were added, deleted, renamed, duplicated or changed.
- git diff --check passes.

Additional created files, all relative to repository root:
- work/foundation/check_foundation.gd
- work/foundation/capture_foundation.gd
- work/foundation/checks.log
- work/foundation/runtime.log
- work/foundation/render.log
- work/foundation/entrance.png
- work/foundation/grand_stair.png
- work/foundation/gallery.png
- work/foundation/drawing_room.png
- work/foundation/vendor-before.json
- work/foundation/vendor-verification.json

Total authored/validation files: 35 created, 1 existing file modified
(godot/project.godot). Vendor folders and third_party_licenses were already
untracked before this work. They were not added to Git or altered.
Engine-generated ignored cache files under godot/.godot are not game source.
