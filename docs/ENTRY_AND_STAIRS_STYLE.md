# Entry hall and stairs

Run `godot/assets/neon-mansion/scenes/entry_stairs_foundation.tscn` with F6. It includes the garden, reception-style entry hall and twin stairs. The original F5 scene and protected visual-upgrade files remain unchanged.

There is now one continuous entry hall between the main door at z=12 and stair-room doorway at z=-23.5. It uses the approved reception desk, teal panels and eight-colour palette. The old entrance interior and separating reception door are removed from this running scene. The two former rooms become one `entrance_hall` record, with one discovery volume and updated navigation links. The room is 12 m wide and 36 m long to retain both outer door positions. The scene has 42 room records and 40 door records.

Original reception reference: `godot/assets/neon-mansion/reception/reference/reception-benchmark.png`. The reception materials and black outline rules are unchanged. The floor seams extend through the whole entry hall. Player and input scripts are unchanged.

The stair hall follows the corrected dark-teal/plum reference. Two 5 m wide flights rise 6.4 m over an 18 m run, centred at x=-6.5 and x=6.5. Both connect to the upper landing. Clear outer corridors keep the existing gallery and other side connections accessible. The original central stairs and obstructing balcony pieces are removed only in this running instance.

Stair reference: `godot/assets/neon-mansion/stair_hall/reference/stair-hall-benchmark.png`. The earlier `stairs_prev.png` is superseded.

Stair materials are under `godot/assets/neon-mansion/stair_hall/materials/`:

| Role | Hex | Material |
|---|---|---|
| Black ink | #000000 | ink.tres |
| Deep recesses | #08070D | deep.tres |
| Teal walls and rails | #192F39 | wall.tres |
| Hard shadow | #14232B | shadow.tres |
| Plum floor and stairs | #241B2D | floor.tres |
| Pink trim and step edges | #AC3A68 | pink.tres |
| Dark pink screen frame | #690C41 | panel.tres |
| Mint plates | #60BEA0 | mint.tres |

Black outlines keep the garden's edge rules and 2 px reference width. Fills are unshaded. No gradients, glow, bloom, reflections or surface textures. Lighting comes later.

The screen is the allowed colour exception. Its source is `godot/assets/neon-mansion/stair_hall/reference/screen-animation-sheet.png`; the four extracted stills are `textures/screen-frame-01.png` through `screen-frame-04.png`. The animation holds each frame for 0.95 seconds, then crossfades for 0.25 seconds: a 4.8-second loop. These transitions provide intermediate frames without generating extra artwork. `screen_animation.gd` controls the timing.

A solid black plate sits behind the screen. `screen.gdshader` outputs fully opaque colour throughout the transitions and draws after the outline pass, so neither transparency nor crossfades let pink show through. There is no emitted light or glow. Hide the `Screen` mesh when checking room palette counts.

Validation passed: main door to unified entry, both desk-side routes, stair-room door, ascent/descent of both flights, upper-landing crossings, the ground-floor gallery door and return to the garden. The merged room graph remains connected. Four animation frames load and advance. Camera styles switch between garden, entry and stair hall.

Render checks use 1376 x 768: entry at player (0,0.05,-13), FOV 75 degrees; stairs at (0,0.05,-28), FOV 56.6 degrees. Eye height is 1.65 m above the player and pitch is -0.025 radians. Hide HUD and screen for palette checks. This follows the reference within the existing map, rather than copying its pixels. Local only; nothing pushed.

Final colour checks passed: all eight entry colours and all eight stair colours are present; zero pixels outside each palette with HUD and screen hidden. Saved previews: godot/assets/neon-mansion/reception/reference/entry-hall-preview.png and godot/assets/neon-mansion/stair_hall/reference/stair-hall-preview.png. All pre-existing tracked files remain unchanged.
