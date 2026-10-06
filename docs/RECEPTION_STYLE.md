# Reception is now the entry hall

Use `godot/assets/neon-mansion/scenes/entry_stairs_foundation.tscn` with F6 for the latest complete scene. It includes the approved garden, unified reception-style entry hall and twin stairs with animated screen.

The original reception image is preserved at `godot/assets/neon-mansion/reception/reference/reception-benchmark.png`. Its eight-colour materials and black outline rules remain under `godot/assets/neon-mansion/reception/`.

The old separate entrance hall interior and dividing reception door are removed in this running scene. The main door opens into one continuous entry hall, whose rear doorway leads to the stair room. It retains the outer door positions, so the new hall is 12 x 36 m. Its room ID is `entrance_hall`; the separate `foyer_reception` record is retired.

See `docs/ENTRY_AND_STAIRS_STYLE.md` for references, palettes, screen playback and checks. The protected foundation source, project settings and player/input scripts are unchanged. F5 continues to run the original scene. Local only; nothing pushed.
