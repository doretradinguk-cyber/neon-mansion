# Neon Mansion — Godot Asset Plan

## Source policy
The Drop Zone is the external source library. Neon Mansion only imports cleared, Godot-ready working content.

Current source packs:
- KayKit Dungeon Remastered
- KayKit Furniture Bits
- KayKit Restaurant Bits
- KayKit Prototype Bits

The source packs are pinned in `doretradinguk-cyber/the-drop-zone` under `retro-game-assets/source-packs/kaykit/`.

## Godot layout
Third-party vendor content lives under:

`godot/addons/kaykit_*`

Do not modify those files directly. Build Neon Mansion-specific scenes, materials and variants under:

`godot/assets/neon-mansion/`

Recommended project-facing categories:
- `architecture/walls`
- `architecture/doors`
- `architecture/stairs`
- `architecture/floors`
- `architecture/ceilings`
- `architecture/arches`
- `architecture/railings`
- `furniture/lounge`
- `furniture/bedrooms`
- `furniture/dining`
- `furniture/office`
- `kitchen`
- `games-arcade`
- `bathroom-pool`
- `props`
- `lighting`
- `materials`
- `nightmare-fx`

## Visual benchmark
The 3D mansion should follow the Retro Nightmare Frequency benchmark rather than the original Book of Hosts texture treatment:
- dark teal / charcoal wall and ceiling base
- dark tiled or polished floors
- near-black doors
- strong hot-magenta emissive trims
- small acid-green/cyan access markers
- restrained texture detail
- cel-shaded / graphic low-poly presentation
- neon light used as controlled accents rather than covering every surface

The Nightmare Frequency is a separate visual state and can add code rain, corrupted signs, Jester imagery, emissive cracks, flicker, distortion and fog.

## Mansion design target
The 3D build is a reusable modern-gothic mansion framework rather than a copy of another game. It should support roughly 30 interior spaces across fixed anchor rooms and generated/support rooms, plus exterior areas.

Initial anchor-room target:
1. Entrance / Reception Hall
2. Grand Stair Hall
3. Long Gallery
4. Kitchen / Service Hub
5. Main Lounge / Great Room
6. Pool / Garden Hub

Exterior target:
- driveway
- front garden
- rear garden
- pool terrace
- shed/workshop
- optional garage

## First Godot build slice
Build and validate this before expanding:

Entrance / Reception Hall -> Grand Stair Hall -> Long Gallery -> one side room

This proves scale, stairs, doors, navigation, materials, lighting, cel shading and Nightmare Frequency switching.

## Sync workflow
After updating Drop Zone source packs, run from the Neon Mansion repository:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\sync-kaykit.ps1
```

This copies the four Godot addon packs into the local Godot project and creates the Neon Mansion working asset folders.
