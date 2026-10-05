# Spatial layout revision — 5 October 2026

Latest layout: Entrance Hall -> reception/foyer transition -> Grand Stair Hall ->
Long Gallery -> Drawing Room. Older foundation/material-pass documents and
validation captures describe the previous layout and are retained as history.

## Proportions and flow
- Entrance Hall remains 8 x 8m. Its existing north door and ID stay at Z=-8.
- ReceptionFoyer is a reusable 4 x 4m connector spanning Z=-8..-12, with
  4.2m headroom. It belongs to Entrance Hall and creates no fifth discovery ID.
- Grand Stair Hall is now a 16 x 24m fixed anchor, spanning X=-8..8 and
  Z=-12..-36 with 8m headroom (previously 12 x 12m with 7.2m headroom).
- The foyer opens through a 4m-wide, 4.2m-high opening into the grand hall.
- The first stair begins at Z=-22: 14m beyond the original entrance door,
  including 4m of foyer and 10m of unobstructed arrival floor inside the hall.
- Stairs are 4m wide with a 10m run, rising 3.2m to Z=-32. The existing
  KayKit stair mesh and continuous wedge approach are retained.
- A full-width 16 x 4m rear landing spans Z=-32..-36 at Y=3.2.
  Two 4 x 4m side returns project forward to Z=-28. Open balusters and brass
  handrails replace the opaque landing barriers; guard colliders contain the
  player while preserving views. Rear-landing access to both returns stays open.
- Two inactive Marker3D sockets reserve lower left/right wing approaches at
  X=+-8, Z=-18. Walls remain closed. No wing rooms or new door IDs were added.
- Long Gallery moved south by 16m: Z=-36..-52, floor Y=3.2.
- Drawing Room also moved south by 16m, centred at (6,3.2,-48).

| Existing ID | Updated location/role |
| --- | --- |
| entrance_hall | Entry and foyer ownership |
| grand_stair_hall | Enlarged fixed anchor and balcony |
| long_gallery | Beyond the upper landing |
| drawing_room | Gallery side room |
| door_entrance_stair | Original first door at (0,0,-8), now opens into foyer |
| door_stair_gallery | Upper door at (0,3.2,-36) |
| door_gallery_drawing | Side door at (2,3.2,-48) |

## Implementation
Room portal dictionaries now optionally specify width and height; existing
2m x 2.9m defaults remain. This supports the wider foyer reveal without changing
existing door dimensions. Stair width, run and rise are exposed parameters.
Foyer and balcony railing are reusable component scenes. Room bounds, related
doors, existing furniture/artwork, signs and lights were moved coherently.
Additional hall fill covers the enlarged space so the stair and balusters read
clearly; prior material resources and Firefly artwork selections were retained.
The artwork helper now loads the already-imported Texture2D resource instead of
reading a raw image; this removes the runtime/export warning without editing
the source image or its import settings.

All room/door IDs, discovery permanence behaviour and local controller are
retained. Nightmare remains separately disabled. Collision follows the revised
stairs, landing, balcony and foyer. No other mansion rooms were added.
Existing uncommitted work was inspected and preserved; no reset, clean, checkout,
delete, commit, merge or publication was performed.

## Validation
Godot 4.7.2 / D3D12 Forward+ was used for six rendered views.
The spatial walkthrough checks the original closed/usable first door, flat foyer,
large arrival floor, both future lower wing approach zones, ascent to Y=3.2,
both side balconies and guard collisions, upper door, gallery, Drawing Room
entry/exit, and the reverse route down to Entrance Hall.
Four room records and three door records remain; wing sockets and Nightmare
are inactive. The corrected run passes without parser/resource errors or the
earlier artwork warning. The six captured views were inspected.
Hashes are compared with the current-local before snapshot; exact protected-file
counts and source changes are recorded in work/layout-revision/file-verification.json.
The previous work/foundation and work/material-integration validation files were
not overwritten. git diff --check was run.

## Created files
- godot/assets/neon-mansion/architecture/foyer_transition.tscn
- godot/assets/neon-mansion/architecture/balcony_railing.tscn
- godot/assets/neon-mansion/scripts/foyer_transition.gd
- godot/assets/neon-mansion/scripts/balcony_railing.gd
- docs/LAYOUT-REVISION.md

## Modified files
- godot/assets/neon-mansion/rooms/grand_stair_hall.tscn
- godot/assets/neon-mansion/scenes/foundation.tscn
- godot/assets/neon-mansion/scripts/room.gd
- godot/assets/neon-mansion/scripts/staircase.gd
- godot/assets/neon-mansion/scripts/foundation.gd
- godot/assets/neon-mansion/scripts/firefly_artwork.gd

## Created validation files
- work/layout-revision/before-files.json
- work/layout-revision/before-status.txt
- work/layout-revision/check_layout.gd
- work/layout-revision/capture_layout.gd
- work/layout-revision/checks.log
- work/layout-revision/render.log
- work/layout-revision/entrance_foyer.png
- work/layout-revision/grand_arrival.png
- work/layout-revision/grand_wide.png
- work/layout-revision/upper_balcony.png
- work/layout-revision/gallery.png
- work/layout-revision/drawing_room.png
- work/layout-revision/file-verification.json
- work/layout-revision/file-report.json

Total: 19 created files and 6 modified source files. All paths are relative to
C:/GitHub/neon-mansion. Original KayKit and Firefly sources are unchanged.
