# Neon Mansion — Stable Map + Random Room Architecture

## Goal
The mansion must feel intentionally designed even though many rooms can vary between runs. The solution is a permanent authored mansion skeleton with fixed anchor rooms, fixed stairs/corridor geometry and fixed connection sockets. Random rooms are selected only for approved sockets; they never move the mansion's structural spine.

## Core rule
**The map skeleton is always the same. Room content can change; structural logic cannot.**

This prevents:
- stairs spawning in implausible places
- corridors failing to connect
- furniture blocking doors
- rooms overlapping each other
- exterior windows facing impossible directions
- anchor rooms drifting between runs
- generic procedural layouts

## Fixed structural layer
These remain authored and persistent:
- exterior footprint
- driveway / front approach
- Entrance / Reception Hall
- foyer transition
- Grand Stair Hall
- all staircases
- upper landing / balcony
- main corridors
- Long Gallery
- major wing junctions
- service spine / kitchen hub
- pool / garden hub
- exterior garden and terrace connections
- vertical shafts / double-height spaces
- important windows and exterior-facing walls
- anchor doors and required traversal route

## Random-room layer
Random or semi-random rooms attach only to designated sockets along the fixed structural layer.

A socket records:
- socket ID
- floor level
- wing / zone
- door transform
- room-size class
- allowed room categories
- required orientation
- exterior-wall requirement or prohibition
- plumbing/service requirement where relevant
- special encounter allowance
- one-way / secret / locked rules where relevant

## Room templates
Every generated room must declare compatibility before it may spawn:
- size class: small / medium / large / special
- doorway positions
- doorway width/type
- ceiling height
- allowed floor
- allowed wing
- window requirements
- plumbing requirement
- service adjacency requirement
- prop clearance zones
- camera / encounter clear zones
- player spawn-safe zone

## Persistence rule
When a random room is first selected for a socket, save that assignment. Revisiting the mansion does not reroll an already discovered room unless a specific Nightmare/gameplay event explicitly changes it.

## Furniture rule
Furniture is not placed freely across the entire room. Each room template contains authored prop zones and no-block zones around:
- doors
- interaction points
- encounter lanes
- windows
- stairs
- clue/puzzle positions
- player camera positions

Random furniture variants may change within those zones without changing navigation.

## Proposed anchor hierarchy
The exact map will be authored after the current first-slice test, but the stable structure should use anchor rooms similar to:

Ground / arrival spine:
- Front approach / driveway
- Entrance / Reception Hall
- Foyer transition
- Grand Stair Hall
- Long Gallery

Primary social wing:
- Main Lounge / Great Room anchor
- Dining/Kitchen service hub

Garden / leisure wing:
- Pool / Garden Hub anchor
- Rear garden / terrace

Upper-floor spine:
- Grand Stair upper landing
- fixed upper corridor junctions
- bedroom/bathroom-compatible random sockets

Special fixed or semi-fixed destinations:
- Security / CCTV access zone
- Cyber Mainframe route
- major encounter / story locations

## Random-room categories
Sockets may permit selected categories rather than the entire room catalogue. Examples:
- social: drawing room, music room, study, library
- leisure: games room, arcade, theatre, gym
- private: bedroom, bathroom, en-suite
- service: pantry, utility/laundry, wine room
- special: security/CCTV, cyber room, encounter room

This preserves believable zoning while keeping replay variety.

## Testing requirement before expansion
Before building the complete map:
1. Approve Entrance Hall -> foyer -> Grand Stair Hall spatial flow.
2. Approve stair placement and upper landing proportions.
3. Approve Long Gallery connection.
4. Approve reusable doors and door clearances.
5. Approve one example random-room socket and two interchangeable room templates.
6. Verify both templates connect without geometry overlap or blocked navigation.
7. Save the selected room and confirm it persists after reload.

Only then scale the system to the full room catalogue.
