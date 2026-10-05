# Neon Mansion

Neon Mansion is the reusable 3D mansion / virtual-layer project for **Neo-Gothic Glitch**.

The starting point is the verified Virtual Manor work from `dorejamesdt4-lang/book-of-hosts-app`, but this repository is intentionally separate from the Book of Hosts web app. We will preserve the useful room layout, geometry references, material ideas and proven spatial relationships, then rework the visual identity toward a darker cel-shaded neo-gothic / retrowave / Nightmare Frequency look.

## Current goal

1. Extract and preserve the verified mansion room data and relevant source references.
2. Keep the original Book of Hosts app untouched as a rollback/reference.
3. Build a clean mansion-specific project that can be cloned and developed independently.
4. Test new cel-shaded materials, neon lighting, Firefly-generated backgrounds/overlays and Nightmare Frequency effects.
5. Use the 3D mansion as a reusable virtual layer and future-game foundation while the main Neo-Gothic Glitch game develops its 2D fixed-camera room system.

## Verified starting rooms

- Entrance Hall
- Long Gallery
- Drawing Room
- Library
- Dining Room
- Conservatory
- Garden

These room bounds were extracted from the original Dore Trading manor layout and already exist in the Book of Hosts Virtual Manor project.

## Repository structure

- `docs/` — handovers, extraction notes and design decisions
- `design/` — room bounds, graphs, camera points and procedural-room planning
- `source-book-of-hosts/` — manifests and references describing the files we extract from Book of Hosts
- `mansion/rooms/` — room-specific definitions and later scene files
- `mansion/materials/` — material definitions and tests
- `mansion/textures/` — prepared runtime textures
- `mansion/lighting/` — neon/cel lighting experiments
- `mansion/vfx/` — Nightmare Frequency and other visual effects
- `firefly/` — prompts, references and generated-art handoffs
- `tests/` — visual, layout and regression tests

## Visual direction

Dark gothic architecture + retrowave neon + cel-shaded graphic-novel rendering. Cyan, magenta, violet and acid-green diagnostics should sit over a dark stone/walnut/brass/marble foundation. Nightmare Frequency effects are layered and event-driven rather than permanently covering the environment.

## Extraction rule

Do **not** blindly copy the whole Book of Hosts application or its old runtime. Only bring across mansion-specific data/code/assets after inspection. Existing malformed/superseded movement code should not be imported wholesale.
