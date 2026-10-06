extends Node3D
## New benchmark reception, fitted to the existing map location.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const ROLES := ["ink", "ceiling", "floor", "wall", "panel", "teal", "mint", "magenta"]
const HEX := ["000000", "08070D", "24172C", "343B4A", "25343E", "398E7D", "91CDBF", "C02D86"]
var materials: Dictionary = {}
var camera: Camera3D
var outline: MeshInstance3D
var environment: Environment
var room: Node3D
var reception_door: Node3D

func _ready() -> void:
    call_deferred("build")

func build() -> void:
    var foundation = get_parent().get_node("Foundation")
    room = foundation.rooms_by_id[&"foyer_reception"]
    position = room.position
    merge_entry(foundation)
    camera = foundation.get_node("Player/Camera3D")
    for role in ROLES:
        materials[role] = load("res://assets/neon-mansion/reception/materials/" + role + ".tres")
    # Retain discovery/room identity; replace the old room construction in this instance only.
    for child in room.get_children():
        if not child is Area3D:
            child.queue_free()
    shell()
    wall_panels()
    counter()
    doorway()
    install_camera_style()

func slab(size: Vector3, at: Vector3, role: String, solid: bool = false) -> MeshInstance3D:
    return A.box(self, size, at, materials[role], solid)

func shell() -> void:
    slab(Vector3(12, 0.2, 36), Vector3(0, -0.075, 12), "floor", true)
    slab(Vector3(12, 0.2, 36), Vector3(0, 6.1, 12), "ceiling", true)
    for side in [-1.0, 1.0]:
        slab(Vector3(0.2, 6, 36), Vector3(side * 6.1, 3, 12), "wall", true)
        # Preserve the existing south entry's full width and height.
        slab(Vector3(2.9, 6, 0.2), Vector3(side * 4.55, 3, 30.1), "wall", true)
        slab(Vector3(4.1, 6, 0.2), Vector3(side * 3.95, 3, -5.7), "panel", true)
    slab(Vector3(6.2, 0.88, 0.2), Vector3(0, 5.56, 30.1), "wall", true)
    slab(Vector3(3.8, 2.6, 0.2), Vector3(0, 4.7, -5.7), "magenta", true)
    for y in [0.16, 2.4, 3.05, 4.1, 5.55, 5.85]:
        var width := 0.11 if y != 3.05 else 0.28
        for side in [-1.0, 1.0]:
            slab(Vector3(4.1, width, 0.08), Vector3(side * 3.95, y, -5.58), "teal")
            slab(Vector3(0.08, width, 36), Vector3(side * 5.94, y, 12), "teal")
    for side in [-1.0, 1.0]:
        slab(Vector3(0.12, 0.4, 36), Vector3(side * 5.92, 0.2, 12), "teal")
        slab(Vector3(0.18, 0.16, 36), Vector3(side * 5.88, 5.8, 12), "wall")

func wall_panels() -> void:
    for side in [-1.0, 1.0]:
        for z in [-4.5,-1.5,1.5,4.5,7.5,10.5,13.5,16.5,19.5,22.5,25.5,28.5]:
            slab(Vector3(0.05, 4.65, 2.55), Vector3(side * 5.87, 2.92, z), "panel")
            for edge in [-1.0, 1.0]:
                slab(Vector3(0.07, 4.7, 0.07), Vector3(side * 5.83, 2.92, z + edge * 1.28), "teal")
                slab(Vector3(0.07, 0.07, 2.6), Vector3(side * 5.83, 2.92 + edge * 2.35, z), "teal")
            slab(Vector3(0.32, 5.7, 0.24), Vector3(side * 5.8, 2.85, z - 1.45), "wall")
            slab(Vector3(0.42, 0.25, 0.4), Vector3(side * 5.74, 5.6, z - 1.45), "panel")
            slab(Vector3(0.12, 5.2, 0.24), Vector3(side * 5.61, 2.6, z - 1.45), "ceiling")

func counter() -> void:
    # Enough space to walk down either side and behind the reception desk.
    slab(Vector3(5.6, 1.3, 1.3), Vector3(0, 0.675, -2.5), "panel", true)
    slab(Vector3(5.85, 0.18, 1.6), Vector3(0, 0.09, -2.5), "panel")
    slab(Vector3(6.0, 0.12, 1.7), Vector3(0, 1.39, -2.5), "mint")
    for y in [0.5, 0.68, 0.87]:
        slab(Vector3(5.6, 0.06 if y != 0.68 else 0.14, 0.035), Vector3(0, y, -1.83), "teal")
    for side in [-1.0, 1.0]:
        slab(Vector3(0.7, 0.12, 0.65), Vector3(side * 2.65, 1.39, -3.25), "mint")
    # Flat cut-corner magenta emblem; black border comes from the unchanged outline pass.
    var vertices := PackedVector3Array()
    var points := [Vector2(-0.3,0.2),Vector2(-0.2,0.3),Vector2(0.2,0.3),Vector2(0.3,0.2),Vector2(0.3,-0.2),Vector2(0.2,-0.3),Vector2(-0.2,-0.3),Vector2(-0.3,-0.2)]
    for i in range(points.size()):
        vertices.append(Vector3(0,0.7,-1.795))
        vertices.append(Vector3(points[i].x,0.7+points[i].y,-1.795))
        var q: Vector2 = points[(i+1)%points.size()]
        vertices.append(Vector3(q.x,0.7+q.y,-1.795))
    var surface := SurfaceTool.new()
    surface.begin(Mesh.PRIMITIVE_TRIANGLES)
    for vertex in vertices:
        surface.add_vertex(vertex)
    surface.generate_normals()
    var badge := MeshInstance3D.new()
    badge.mesh = surface.commit()
    badge.material_override = materials.magenta
    add_child(badge)

func doorway() -> void:
    for side in [-1.0, 1.0]:
        slab(Vector3(0.55, 5.5, 0.24), Vector3(side * 1.95, 2.75, -5.55), "magenta")
        slab(Vector3(0.2, 0.28, 0.025), Vector3(side * 1.96, 1.45, -5.415), "teal")
    slab(Vector3(3.25, 1.15, 0.035), Vector3(0, 4.73, -5.55), "floor")
    for x in [-1.64,1.64]:
        slab(Vector3(0.04,1.2,0.05),Vector3(x,4.73,-5.52),"magenta")
    for y in [4.13,5.33]:
        slab(Vector3(3.3,0.04,0.05),Vector3(0,y,-5.52),"magenta")
    reception_door = preload("res://assets/neon-mansion/architecture/doors/grand_anchor.tscn").instantiate()
    var foundation = get_parent().get_node("Foundation")
    var original = foundation.doors_by_id[&"door_entrance_stair"]
    reception_door.name = original.name
    original.get_parent().remove_child(original)
    original.queue_free()
    reception_door.style = reception_door.style.duplicate()
    reception_door.style.leaf_width = 1.6
    reception_door.style.leaf_height = 3.2
    reception_door.style.pointed_profile = false
    reception_door.style.family = "standard"
    reception_door.door_id = &"door_entrance_stair"
    reception_door.room_a = &"entrance_hall"
    reception_door.room_b = &"grand_stair_hall"
    reception_door.caption = "Grand Stair Hall"
    reception_door.position = to_global(Vector3(0,0,-5.5))
    reception_door.set_meta("via", "entrance_hall")
    foundation.get_node("Doors").add_child(reception_door)
    foundation.doors_by_id[&"door_entrance_stair"] = reception_door
    remap_door(reception_door)

func remap_door(node: Node) -> void:
    if node is Label3D:
        node.visible = false
    if node is MeshInstance3D and node.material_override:
        var role: String = node.material_override.resource_path.get_file().get_basename()
        var mapping := {"frame_teal":"magenta","magenta_trim":"magenta","near_black":"ceiling","dark_metal":"floor","brass":"mint","cyan_indicator":"teal","acid_green":"teal"}
        if mapping.has(role):
            node.material_override = materials[mapping[role]]
    for child in node.get_children():
        remap_door(child)

func install_camera_style() -> void:
    outline = MeshInstance3D.new()
    outline.name = "ReceptionOutline"
    var quad := QuadMesh.new()
    quad.size = Vector2(2,2)
    outline.mesh = quad
    outline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    outline.extra_cull_margin = 16384
    var material := ShaderMaterial.new()
    material.shader = preload("res://assets/neon-mansion/reception/reception_outline.gdshader")
    var colours := PackedColorArray()
    for hex in HEX:
        colours.append(Color.html(hex))
    material.set_shader_parameter("palette",colours)
    material.set_shader_parameter("ink",Color.BLACK)
    material.set_shader_parameter("gallery_from_world",global_transform.affine_inverse())
    outline.material_override = material
    camera.add_child(outline)
    environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color.html("08070D")
    environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED

func _process(_delta: float) -> void:
    if not is_instance_valid(outline):
        return
    var p := to_local(camera.global_position)
    var inside := absf(p.x) < 6 and p.z > -6 and p.z < 30 and p.y < 6
    outline.visible = inside
    if inside:
        camera.environment = environment



func merge_entry(foundation: Node3D) -> void:
    var old_entry: Node3D = foundation.rooms_by_id[&"entrance_hall"]
    for child in old_entry.get_children():
        old_entry.remove_child(child)
        child.queue_free()
    room.name = "EntryHall"
    room.room_id = &"entrance_hall"
    room.display_name = "Entry Hall"
    room.set_meta("room_id", &"entrance_hall")
    room.definition = room.definition.duplicate(true)
    room.definition.id = "entrance_hall"
    room.definition.name = "Entry Hall"
    room.definition.size = [12,36]
    room.footprint = Vector2(12,36)
    room.position = Vector3(0,0,-6)
    room.definition.position = [0,0,-6]
    room.portals = {"south":[{"offset":0,"elevation":0,"width":6.2,"height":5.12}],"north":[{"offset":0,"elevation":0,"width":3.8,"height":3.4}]}
    room.definition.portals = room.portals.duplicate(true)
    for child in room.get_children():
        if child is Area3D:
            room.remove_child(child)
            child.queue_free()
    room.add_volume(Vector3.ZERO,Vector3(11.5,6,35.5))
    foundation.rooms_by_id.erase(&"foyer_reception")
    foundation.rooms_by_id[&"entrance_hall"] = room
    old_entry.get_parent().remove_child(old_entry)
    old_entry.queue_free()
    var divider = foundation.doors_by_id[&"door_entrance_foyer"]
    divider.get_parent().remove_child(divider)
    divider.queue_free()
    foundation.doors_by_id.erase(&"door_entrance_foyer")
    foundation.navigation_links.erase("foyer_reception")
    for id in foundation.navigation_links:
        var links: Array = []
        for next in foundation.navigation_links[id]:
            var destination = "entrance_hall" if next == "foyer_reception" else next
            if destination != id and not links.has(destination):
                links.append(destination)
        foundation.navigation_links[id] = links
    for destination in ["driveway", "grand_stair_hall"]:
        if not foundation.navigation_links.entrance_hall.has(destination):
            foundation.navigation_links.entrance_hall.append(destination)
    foundation.doors_by_id[&"door_front_arrival"].caption = "Entry Hall"
    foundation.layout = foundation.layout.duplicate(true)
    foundation.layout.rooms = foundation.layout.rooms.filter(func(d): return d.id != "foyer_reception")
    for d in foundation.layout.rooms:
        if d.id == "entrance_hall":
            d.position = [0,0,-6]
            d.size = [12,36]
            d.height = 6
            d.name = "Entry Hall"
            d.portals = room.portals.duplicate(true)
    foundation.layout.doors = foundation.layout.doors.filter(func(d): return d.id != "door_entrance_foyer")
    for d in foundation.layout.doors:
        if d.has("via") and d.via == "foyer_reception":
            d.erase("via")
    for child in foundation.get_children():
        if child is Node3D:
            var p: Vector3 = child.position
            if p.z > 12.3 and p.z < 12.5 and p.y > 6:
                child.queue_free()
            elif absf(absf(p.x)-8) < 0.1 and p.z > 12.3 and p.z < 12.5:
                child.queue_free()


