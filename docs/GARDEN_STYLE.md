# Garden style pass

Run `godot/assets/neon-mansion/scenes/garden_foundation.tscn` with F6. It loads the existing foundation and adds the garden; the project's F5 main scene stays unchanged to preserve the visual-upgrade files. Player and input resources are unchanged.

References: `design/reference/garden/garden-reference-1.png` (front garden with grid), `garden-reference-2.png` (without grid), `garden-reference-3.png` (grid studies), `garden-reference-4.png` and `garden-reference-7.png` (gate), `garden-reference-5.png` and `garden-reference-8.png` (pool), `garden-reference-6.png` (gazebo), `garden-reference-9.png` (duplicate gazebo). These are images from the Drop Zone ZIP, not 3D models or runtime textures.

Eight garden colours, in `godot/assets/neon-mansion/garden/materials/`:

| Role | Hex | File |
|---|---|---|
| Ink outlines | #000000 | ink.tres |
| Ground and openings | #08070D | ground.tres |
| Hard shadow and sky | #211C2D | shadow.tres |
| Stone architecture | #303C48 | stone.tres |
| Planter and hedge face | #28534E | teal.tres |
| Hedge tops and bed rims | #438B76 | leaf.tres |
| Small mint accents | #8ACCB3 | mint.tres |
| Door frames and gate accents | #B82D87 | magenta.tres |

Flat unshaded fills, black camera outlines and one authored shadow step. No surface textures, gradients, glow, bloom or reflections. Lighting comes later. Existing outdoor materials are replaced by their named roles in this running scene; shared resources are untouched.

`garden_style.gd` adds beds, hedges, trees, urns, open gate leaves, pool decoration and a rear gazebo. Existing ground collision, mansion geometry, room IDs, doors and player controls are retained. Only old front garden pillars and beds are removed from the running instance. New beds and pillars have collision; the central drive remains clear. The gate is decorative and open, with no new interaction.

`garden_outline.gdshader` derives from the existing outline pass. It detects colour, depth and surface-angle edges, draws front floor seams at 2 px at 1376 px wide, and snaps the final outdoor view to the eight-colour palette. It is added under the player's camera at runtime. Camera environment and outlines switch at the garden zone boundaries; indoors uses the original environment. The HUD is excluded from palette checks.

Check: render 1376 x 768 from the drive at (0, 0.05, 62), camera eye 1.65 m above the player, vertical FOV 65 degrees, pitch -0.025 radians. Compare with references 1 and 2, allowing for the retained mansion facade and drive width. With HUD hidden, colour-count the render: every pixel must belong to the eight garden colours. Walk the drive to the front door and check the return route, rear garden and pool links.

This is the first garden pass. It translates the reference layout into real 3D around the existing map; it is not a pixel-for-pixel recreation. The main foundation file, project settings and all pre-existing visual-upgrade files are unchanged. Local only; nothing pushed.

Validation: Godot 4.7.2 loads the scene without errors. The final 1376 x 768 front render uses all eight garden colours, with zero pixels outside the palette (HUD hidden). Walking from spawn to the gate, back to the entrance, through the working front door and back out passes. The rear garden lane and pool approach pass. The camera restores the original indoor environment and reapplies the garden style on return. All 43 rooms and 41 doors remain present. No tracked pre-existing file changed.

