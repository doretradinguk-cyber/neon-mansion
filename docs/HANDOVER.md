# Neon Mansion — handover

Updated: 5 October 2026.

## Purpose

Neon Mansion is a clean, reusable mansion project derived from the verified Book of Hosts Virtual Manor foundation. It is not a copy of the Book of Hosts app. The goal is to isolate the mansion-specific room data, rendering ideas and useful assets so the environment can be reworked into the **Neo-Gothic Glitch** visual language.

## Source of truth for extraction

Primary source repository:
- `dorejamesdt4-lang/book-of-hosts-app`

Verified Virtual Manor boundary:
- `public/modules/virtual-manor/`

Verified design data already copied into this repository:
- `design/original-room-bounds.json`

## Verified source facts

The Book of Hosts Virtual Manor currently contains seven fixed rooms:
- Entrance Hall
- Long Gallery
- Drawing Room
- Library
- Dining Room
- Conservatory
- Garden

The source handover also records:
- self-hosted Three.js 0.180.0/MIT in the old runtime
- authored batched architecture
- source-derived plaster/tile maps
- first-person exploration
- material and texture work
- 27 draw calls / 104,858 triangles in one measured pass
- current old-runtime movement code includes superseded/malformed sections and must not be copied wholesale

## Neon Mansion direction

This new project will deliberately move away from the Storybook / Arcane Oracle palette of Book of Hosts and toward:
- dark neo-gothic architecture
- cel-shaded / graphic-novel rendering
- retrowave neon cyan / magenta / violet / acid-green emission
- Nightmare Frequency overlays
- Firefly-generated backgrounds, glows, decals and texture concepts where useful
- Photoshop cleanup / masking / texture preparation
- reusable room and material data

## First extraction pass

Do not import everything at once. First inspect and isolate:
1. room bounds / room graph
2. world-building geometry source
3. material registry
4. runtime texture catalogue
5. room and door definitions
6. camera / spawn positions
7. reusable furniture / props
8. visual regression assets that help compare the old and new mansion

## Do not bring across blindly

- dashboard code
- narrator / theatre features
- unrelated Book of Hosts routes
- old service workers
- admin tools
- superseded movement / camera code
- time-machine or twisting-corridor systems from other projects

## Immediate next task

Inspect `public/modules/virtual-manor/` in Book of Hosts and copy the minimum mansion-specific text/code files needed to reconstruct and test the environment in isolation. Record the original source path for every copied file.

After the extraction is stable, begin a first visual pass on Entrance Hall + Long Gallery using new Neon Mansion materials and lighting.
