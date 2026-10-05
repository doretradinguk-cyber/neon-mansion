extends Node3D
## Fixed slice registry. Future generation must reuse discovered definitions by ID.
signal room_discovered(room_id: StringName)
const Architecture = preload("res://assets/neon-mansion/scripts/architecture.gd")
const RAILING = preload("res://assets/neon-mansion/architecture/balcony_railing.tscn")
const FLOOR = preload("res://assets/neon-mansion/materials/dark_marble.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const WOOD = preload("res://assets/neon-mansion/materials/walnut.tres")
const CHARCOAL = preload("res://assets/neon-mansion/materials/charcoal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const GLASS = preload("res://assets/neon-mansion/materials/smoked_glass.tres")
const ARTWORK = preload("res://assets/neon-mansion/scripts/firefly_artwork.gd")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const FURNITURE = "res://addons/kaykit_furniture_bits/Assets/gltf/"
var discovered_rooms: Dictionary = {}
var rooms_by_id: Dictionary = {}
var doors_by_id: Dictionary = {}

func _enter_tree() -> void:
	add_to_group("mansion_registry")

func _ready() -> void:
	for room in get_tree().get_nodes_in_group("mansion_rooms"):
		assert(not rooms_by_id.has(room.room_id))
		rooms_by_id[room.room_id] = room
	for door in get_tree().get_nodes_in_group("mansion_doors"):
		assert(not doors_by_id.has(door.door_id))
		assert(rooms_by_id.has(door.room_a) and rooms_by_id.has(door.room_b))
		doors_by_id[door.door_id] = door
	build_upper_balcony()
	for at in [Vector3(0, 3, -4), Vector3(-5, 5.8, -19), Vector3(5, 5.8, -19), Vector3(0, 4.0, -18), Vector3(0, 5.5, -27), Vector3(0, 6.1, -40), Vector3(0, 6.1, -48), Vector3(6, 6.1, -48)]:
		var light := OmniLight3D.new()
		light.position = at
		light.light_color = Color(0.23, 0.7, 0.78)
		light.light_energy = 1.3
		light.omni_range = 13.0 if at.z < -12 and at.z > -36 else 7.5
		if at.z < -12 and at.z > -36:
			light.light_energy = 1.8
			light.light_color = Color(0.45, 0.65, 0.7)
		add_child(light)
	var magenta := OmniLight3D.new()
	magenta.position = Vector3(0, 4.8, -31)
	magenta.light_color = Color(1, 0.02, 0.3)
	magenta.light_energy = 0.8
	magenta.omni_range = 5
	add_child(magenta)
	prop("couch", Vector3(8.7, 3.2, -48), PI / 2, true, CHARCOAL)
	prop("table_low", Vector3(6.5, 3.2, -48), 0, true, WOOD)
	prop("armchair", Vector3(6, 3.2, -50.8), 0, true, CHARCOAL)
	for z in [-39, -43, -51]:
		prop("pictureframe_large_A", Vector3(-1.78, 4.5, z), PI / 2, false, BRASS, 1 if z == -43 else 0)
	room_sign("01 / ENTRANCE HALL", Vector3(0, 3.75, -7.6))
	room_sign("02 / GRAND STAIR HALL", Vector3(0, 7.5, -35.6))
	room_sign("03 / LONG GALLERY", Vector3(0, 6.6, -51.65))
	var side_sign := room_sign("04 / DRAWING ROOM", Vector3(9.65, 6.5, -48))
	side_sign.rotation.y = -PI / 2
	add_visual_fixtures()

func discover_room(id: StringName) -> void:
	$Player/HUD/Room.text = rooms_by_id[id].display_name.to_upper()
	if discovered_rooms.has(id):
		return
	discovered_rooms[id] = {"room_id": String(id), "scene": rooms_by_id[id].scene_file_path, "permanent": true}
	room_discovered.emit(id)

func room_sign(text: String, at: Vector3) -> Label3D:
	var label := Label3D.new()
	label.text = text
	label.position = at
	label.modulate = Color(0.62, 1, 0.02)
	label.font_size = 42
	label.pixel_size = 0.008
	add_child(label)
	return label

func prop(asset: String, at: Vector3, yaw: float, solid: bool = true, material: Material = FLOOR, art_index: int = -1) -> void:
	var instance = (load(FURNITURE + asset + ".gltf") as PackedScene).instantiate() as Node3D
	add_child(instance)
	instance.position = at
	instance.rotation.y = yaw
	var parts: Array[MeshInstance3D] = []
	Architecture._collect(instance, parts)
	for part in parts:
		part.material_override = material
		if solid:
			# Accurate per-mesh static geometry, transformed with the vendor node.
			part.create_trimesh_collision()

	if art_index >= 0:
		var art := Node3D.new()
		art.set_script(ARTWORK)
		art.set("artwork_index", art_index)
		art.position.z = 0.215
		instance.add_child(art)
		var pane := Architecture.box(instance, Vector3(0.88, 1.08, 0.005), Vector3(0, 0, 0.225), GLASS)
		pane.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func add_visual_fixtures() -> void:
	# Visual-only fixtures: do not introduce colliders into the proven route.
	for at in [Vector3(-3.65, 2.5, -4), Vector3(3.65, 2.5, -4), Vector3(-7.65, 4.8, -22), Vector3(7.65, 4.8, -22), Vector3(9.65, 5.5, -46)]:
		Architecture.box(self, Vector3(0.12, 0.7, 0.3), at, BRASS)
		var bulb := Architecture.box(self, Vector3(0.13, 0.4, 0.18), at + Vector3(0, 0, 0.01), CYAN)
		var light := OmniLight3D.new()
		light.position = at + Vector3(-signf(at.x) * 0.3, 0, 0)
		light.light_color = Color(0.65, 0.78, 0.8)
		light.light_energy = 0.7
		light.omni_range = 3.5
		add_child(light)
		bulb.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var warm := OmniLight3D.new()
	warm.position = Vector3(7, 5.9, -48)
	warm.light_color = Color(0.85, 0.58, 0.3)
	warm.light_energy = 1.1
	warm.omni_range = 5
	add_child(warm)

func build_upper_balcony() -> void:
	var hall := $Rooms/GrandStairHall
	# Rear landing world Z=-32..-36, with side returns Z=-28..-32.
	Architecture.box(hall, Vector3(16, 0.2, 4), Vector3(0, 3.1, -10), FLOOR, true)
	for x in [-6.0, 6.0]:
		Architecture.box(hall, Vector3(4, 0.2, 4), Vector3(x, 3.1, -6), FLOOR, true)
	for x in [-3.1, 3.1]:
		add_railing(hall, 1.8, Vector3(x, 3.2, -8))
	for x in [-4.0, 4.0]:
		add_railing(hall, 4.0, Vector3(x, 3.2, -6), PI / 2)
	for x in [-6.0, 6.0]:
		add_railing(hall, 4.0, Vector3(x, 3.2, -4))
	# Narrow supports keep the centre and future lower wing approaches open.
	for x in [-7.5, 7.5]:
		Architecture.box(hall, Vector3(0.3, 3.2, 0.3), Vector3(x, 1.6, -4), METAL, true)

func add_railing(parent: Node3D, length: float, at: Vector3, yaw: float = 0.0) -> void:
	var railing = RAILING.instantiate()
	railing.length = length
	railing.position = at
	railing.rotation.y = yaw
	parent.add_child(railing)
