# Art direction

## Art style lock — flat comic (Long Gallery)

Applies to `godot/assets/neon-mansion/scenes/long_gallery_flat.tscn`. The benchmark image is the only reference; matching by eye is enough.

### Look

- Low-detail comic cel-shading: black pen outlines, flat colour fills, hard-edged shadow steps.
- Outlines are about 2 px at 1376 px wide and hard-edged.
- No gradients, glow, bloom, reflections, textures or highlights.
- Lighting is added later. Until then, shadow is baked per face: a shaded face takes the shadow colour with a hard edge.

### Palette — exactly 8 colours, never a 9th

| Colour | Hex | Material | Used for |
|---|---|---|---|
| Wall | `#152731` | `flat_wall.tres` | Side walls and cornice |
| Ceiling | `#0D161B` | `flat_ceiling.tres` | Ceiling and the far wall (the wall's shadow step) |
| Floor | `#201827` | `flat_floor.tres` | Floor tiles |
| Ink | `#000000` | `flat_ink.tres` | Outlines, door openings, floor seams, cornice lines |
| Pink main | `#B33E68` | `flat_trim_light.tres` | Lit door frames and door faces |
| Pink shadow | `#872347` | `flat_trim_mid.tres` | Shaded frame faces, reveals and skirting boards |
| Accent panel | `#5B0135` | `flat_accent_panel.tres` | The far-wall rectangle |
| Accent signal | `#60C59B` | `flat_accent_signal.tres` | Blank number plates |

The materials live in `godot/assets/neon-mansion/materials/` and are registered as `FLAT` in `material_library.gd`. They are unshaded so the rendered fill is the exact hex value. Do not edit the shared mansion materials to achieve this look.

### Elements

- Four doors per side, with the jamb further from the camera drawn wider than the near one.
- Number plates are blank flat squares with no visible side face, on the first three doors of each side only.
- Floor tile seams and cornice lines are ink.
- Pen lines come from the screen-space outline pass (`materials/shaders/flat_outline.gdshader`) on the scene's own camera only.
