# Neon Mansion map — Baseline v1

Approved 5 October 2026 after manual testing. This records the current structural baseline, adapted from THE SANCTUM map. The 43 spatial definitions include unfurnished shells and outdoor zones; they are not 43 completed rooms. The Drawing Room remains the dressed benchmark.

Permanent arrival: **Driveway / Exterior → Entrance Hall → Foyer / Reception → Massive Grand Stair Hall → Long Gallery → mansion wings**. The Drawing Room connects off the gallery.

## Authority and change rule

Runtime transforms: `godot/assets/neon-mansion/layout/mansion_layout.json`. Planning snapshot: `design/mansion-map.json`. Record every future structural alteration in this map and `docs/MANSION-CHANGELOG.md`, and synchronize the JSON snapshot. Fixed anchors, circulation spines, stairs and door positions are authored. Random rooms may attach only to approved sockets; their shell, corridor and connections stay fixed. Once assigned during a run, a room persists.

Axes: X follows the galleries, −Z runs inward from the driveway. Ground floor Y=0 m; upper floor Y=6.4 m; basement Y=−6.4 m. Exterior zones share ground-floor elevation.

## Exterior

| ID | Space | Role | Centre X/Y/Z (m) | Footprint (m) |
| --- | --- | --- | --- | --- |
| driveway | Driveway | exterior | 0, 0, 40 | 20 × 56 |
| front_garden | Front Garden | exterior | 0, 0, 40 | 80 × 56 |
| rear_garden | Rear Garden | exterior | 56, 0, -106 | 136 × 40 |
| pool_terrace | Pool Terrace | exterior | 40, 0, -14 | 16 × 16 |
| shed_workshop | Shed / Workshop | fixed | 58, 0, -14 | 12 × 12 |
| garage | Garage | fixed | 80, 0, 8 | 24 × 24 |

## Ground floor

| ID | Space | Role | Centre X/Y/Z (m) | Footprint (m) |
| --- | --- | --- | --- | --- |
| entrance_hall | Entrance Hall | anchor | 0, 0, 0 | 20 × 24 |
| foyer_reception | Foyer / Reception | anchor | 0, 0, -18 | 12 × 12 |
| grand_stair_hall | Grand Stair Hall | anchor | 0, 0, -42 | 32 × 36 |
| long_gallery | Long Gallery | anchor | 68, 0, -42 | 104 × 8 |
| drawing_room | Drawing Room | benchmark | 24, 0, -30 | 16 × 16 |
| lounge | Lounge | anchor | 24, 0, -54 | 16 × 16 |
| kitchen | Kitchen | anchor | 40, 0, -54 | 16 × 16 |
| pool_hub | Pool Hub | anchor | 40, 0, -30 | 16 × 16 |
| pantry | Pantry | defined_socket | 52, 0, -54 | 8 × 16 |
| dining_room | Dining Room | defined_socket | 62, 0, -54 | 12 × 16 |
| library | Library | defined_socket | 74, 0, -54 | 12 × 16 |
| study | Study | defined_socket | 86, 0, -54 | 12 × 16 |
| conservatory | Conservatory | defined_socket | 102, 0, -54 | 20 × 16 |
| home_theatre | Home Theatre | defined_socket | 56, 0, -30 | 16 × 16 |
| games_room | Games Room | defined_socket | 72, 0, -30 | 16 × 16 |
| gym | Gym | defined_socket | 86, 0, -30 | 12 × 16 |
| arcade | Arcade | defined_socket | 98, 0, -30 | 12 × 16 |
| random_ground | Random Room | random_socket | 112, 0, -30 | 16 × 16 |

## Upper floor

| ID | Space | Role | Centre X/Y/Z (m) | Footprint (m) |
| --- | --- | --- | --- | --- |
| upper_landing | Upper Landing | anchor | 0, 6.4, -57 | 32 × 6 |
| upper_corridor | Upper Corridor | anchor | 68, 6.4, -57 | 104 × 8 |
| master_bedroom | Master Bedroom | defined_socket | -38, 6.4, -57 | 20 × 16 |
| ensuite_1 | En-Suite 1 | defined_socket | -22, 6.4, -57 | 12 × 16 |
| bedroom_2 | Bedroom 2 | defined_socket | 24, 6.4, -69 | 16 × 16 |
| ensuite_2 | En-Suite 2 | defined_socket | 38, 6.4, -69 | 12 × 16 |
| bedroom_3 | Bedroom 3 | defined_socket | 52, 6.4, -69 | 16 × 16 |
| bedroom_4 | Bedroom 4 | defined_socket | 68, 6.4, -69 | 16 × 16 |
| bedroom_5_attic | Bedroom 5 / Attic | special_socket | 90, 6.4, -69 | 28 × 16 |
| random_upper_north | Upper Random Socket | defined_socket | 112, 6.4, -69 | 16 × 16 |
| bathroom_1 | Bathroom 1 | defined_socket | 44, 6.4, -45 | 16 × 16 |
| bathroom_2 | Bathroom 2 | defined_socket | 60, 6.4, -45 | 16 × 16 |
| guest_lounge | Guest Lounge | defined_socket | 84, 6.4, -45 | 32 × 16 |
| random_upper | Upper Random Room | random_socket | 110, 6.4, -45 | 20 × 16 |

## Basement

| ID | Space | Role | Centre X/Y/Z (m) | Footprint (m) |
| --- | --- | --- | --- | --- |
| utility_service | Utility / Service | fixed | 40, -6.4, -54 | 16 × 16 |
| service_corridor | Service Corridor | anchor | 64, -6.4, -42 | 64 × 8 |
| wine_room | Wine Room | locked_destination | 64, -6.4, -54 | 16 × 16 |
| security_cctv | Security / CCTV | locked_destination | 80, -6.4, -54 | 16 × 16 |
| cyber_mainframe | Cyber Room / Mainframe | special_anchor | 80, -6.4, -74 | 24 × 24 |

## Spines, stairs and exterior connections

- Long Gallery: 104 × 8 m, centre (68,0,−42), east of the Grand Stair Hall. North side: Lounge, Kitchen, Pantry, Dining, Library, Study, Conservatory. South side: Drawing Room, Pool Hub, Theatre, Games, Gym, Arcade, GF-R01.
- Upper Corridor: 104 × 8 m, centre (68,6.4,−57), reached from the upper landing. North side: Bedroom 2, En-Suite 2, Bedrooms 3/4, Bedroom 5/Attic, UF-R02. South side: Bathrooms 1/2, Guest Lounge, UF-R01. West landing connects through En-Suite 1 to Master Bedroom.
- Grand staircase: centre (0,0,−45), width 6 m, run 18 m, rise 6.4 m, 32 steps. Toe Z=−36 is 12 m beyond the stair-hall entry. Front door to first stair is approximately 48 m. Rear landing is 32 × 6 m with 6 × 20 m side balconies open to the hall below; inner and front edges are guarded.
- Service staircase: centre (41,−6.4,−54), width 4 m, run 12 m, rise 6.4 m. Links Kitchen to Utility/Service through a guarded floor/ceiling/terrain shaft.
- Basement spine: Kitchen → Utility/Service → Service Corridor → Wine Room → Security/CCTV → Cyber/Mainframe. Wine and security connect sideways; the final cyber room turns inward beyond security.
- Exterior: Driveway → Entrance Hall; shared grounds join Front Garden, Rear Garden and Pool Terrace. Pool Hub opens to Pool Terrace; Conservatory opens toward Rear Garden; Shed/Workshop is reached from the terrace side and Garage from the front grounds. Gardens/pool are placeholders.
- Reserved west ground-floor wing connection: grand_west_GF at (−16,0,−42), inactive. East gallery and east upper corridor are live. Further wings require a recorded structural change.

## Approved sockets

| Socket | Room ID | Floor | Status | Categories |
| --- | --- | --- | --- | --- |
| GF-R01 | random_ground | GF | prototype | music, study |
| UF-R01 | random_upper | UF | reserved_shell | bedroom, guest_lounge |
| UF-R02 | random_upper_north | UF | reserved_shell | bedroom, attic |
| GF-F01 | pantry | GF | authored_fixed_shell | pantry |
| GF-F02 | dining_room | GF | authored_fixed_shell | dining_room |
| GF-F03 | library | GF | authored_fixed_shell | library |
| GF-F04 | study | GF | authored_fixed_shell | study |
| GF-F05 | conservatory | GF | authored_fixed_shell | conservatory |
| GF-F06 | home_theatre | GF | authored_fixed_shell | home_theatre |
| GF-F07 | games_room | GF | authored_fixed_shell | games_room |
| GF-F08 | gym | GF | authored_fixed_shell | gym |
| GF-F09 | arcade | GF | authored_fixed_shell | arcade |
| UF-F01 | master_bedroom | UF | authored_fixed_shell | bedroom |
| UF-F02 | ensuite_1 | UF | authored_fixed_shell | bathroom |
| UF-F03 | bedroom_2 | UF | authored_fixed_shell | bedroom |
| UF-F04 | ensuite_2 | UF | authored_fixed_shell | bathroom |
| UF-F05 | bedroom_3 | UF | authored_fixed_shell | bedroom |
| UF-F06 | bedroom_4 | UF | authored_fixed_shell | bedroom |
| UF-F07 | bedroom_5_attic | UF | reserved_special_shell | bedroom |
| UF-F08 | bathroom_1 | UF | authored_fixed_shell | bathroom |
| UF-F09 | bathroom_2 | UF | authored_fixed_shell | bathroom |
| UF-F10 | guest_lounge | UF | authored_fixed_shell | guest_lounge |

GF-R01 is active: 16 × 16 m at (112,0,−30), north entry, Music Salon or Private Study. UF-R01 and UF-R02 are reserved; no template assignment is active there. Fixed socket records are furnishing boundaries, not permission to reroll fixed rooms. Every socket records transform, entry orientation/offset, footprint, floor/wing, permitted categories, window/service constraints, door connections, safe clearance and prop exclusions. Match all constraints before assignment; preserve invalid save files for investigation.

## Special, locked and service destinations

Bedroom 5/Attic is a special upper-floor shell; no extra attic storey or stair exists. Wine Room and Security/CCTV are future locked destinations; foundation doors currently operate without locks. Cyber/Mainframe is a special basement anchor. Pantry, Kitchen, Utility/Service and Service Corridor provide service circulation. Networking, AI navigation mesh, puzzles and full furnishing remain future work. Nightmare Frequency is a separate visual layer, disabled by default.

## Door connections

| Door ID | Semantic link | Physical via | Variant |
| --- | --- | --- | --- |
| door_front_arrival | driveway ↔ entrance_hall |  | grand_anchor |
| door_entrance_foyer | entrance_hall ↔ foyer_reception |  | grand_anchor |
| door_entrance_stair | entrance_hall ↔ grand_stair_hall | foyer_reception | grand_anchor |
| door_stair_gallery | grand_stair_hall ↔ long_gallery |  | grand_anchor |
| door_gallery_drawing | long_gallery ↔ drawing_room |  | luxury |
| door_gallery_lounge | long_gallery ↔ lounge |  | luxury |
| door_gallery_kitchen | long_gallery ↔ kitchen |  | kitchen_service |
| door_gallery_pantry | long_gallery ↔ pantry |  | kitchen_service |
| door_gallery_dining_room | long_gallery ↔ dining_room |  | luxury |
| door_gallery_library | long_gallery ↔ library |  | luxury |
| door_gallery_study | long_gallery ↔ study |  | luxury |
| door_gallery_conservatory | long_gallery ↔ conservatory |  | luxury |
| door_gallery_pool_hub | long_gallery ↔ pool_hub |  | standard |
| door_gallery_home_theatre | long_gallery ↔ home_theatre |  | theatre_games_arcade |
| door_gallery_games_room | long_gallery ↔ games_room |  | theatre_games_arcade |
| door_gallery_gym | long_gallery ↔ gym |  | standard |
| door_gallery_arcade | long_gallery ↔ arcade |  | theatre_games_arcade |
| door_gallery_random_ground | long_gallery ↔ random_ground |  | standard |
| door_kitchen_pantry | kitchen ↔ pantry |  | kitchen_service |
| door_pool_terrace | pool_hub ↔ pool_terrace |  | exterior_garden |
| door_conservatory_garden | conservatory ↔ rear_garden |  | exterior_garden |
| door_shed | pool_terrace ↔ shed_workshop |  | kitchen_service |
| door_garage | front_garden ↔ garage |  | exterior_garden |
| door_landing_corridor | grand_stair_hall ↔ upper_corridor | upper_landing | grand_anchor |
| door_landing_ensuite | grand_stair_hall ↔ ensuite_1 | upper_landing | bedroom_bathroom |
| door_master_ensuite | ensuite_1 ↔ master_bedroom |  | bedroom_bathroom |
| door_upper_bedroom_2 | upper_corridor ↔ bedroom_2 |  | bedroom_bathroom |
| door_upper_ensuite_2 | upper_corridor ↔ ensuite_2 |  | bedroom_bathroom |
| door_upper_bedroom_3 | upper_corridor ↔ bedroom_3 |  | bedroom_bathroom |
| door_upper_bedroom_4 | upper_corridor ↔ bedroom_4 |  | bedroom_bathroom |
| door_upper_bedroom_5_attic | upper_corridor ↔ bedroom_5_attic |  | bedroom_bathroom |
| door_upper_random_upper_north | upper_corridor ↔ random_upper_north |  | bedroom_bathroom |
| door_upper_bathroom_1 | upper_corridor ↔ bathroom_1 |  | bedroom_bathroom |
| door_upper_bathroom_2 | upper_corridor ↔ bathroom_2 |  | bedroom_bathroom |
| door_upper_guest_lounge | upper_corridor ↔ guest_lounge |  | luxury |
| door_upper_random_upper | upper_corridor ↔ random_upper |  | bedroom_bathroom |
| door_bedroom2_ensuite | bedroom_2 ↔ ensuite_2 |  | bedroom_bathroom |
| door_utility_corridor | utility_service ↔ service_corridor |  | kitchen_service |
| door_service_wine | service_corridor ↔ wine_room |  | kitchen_service |
| door_wine_security | wine_room ↔ security_cctv |  | security_cyber |
| door_security_mainframe | security_cctv ↔ cyber_mainframe |  | security_cyber |

Historical door_entrance_stair retains its entrance_hall/grand_stair_hall semantic link and records foyer_reception as via; its physical opening is at the foyer/stair-hall threshold. This is intentional compatibility metadata, not a bypass around the foyer.
