extends Node3D
## Each room owns its interior faces. A portal record is {offset, elevation}.
const Module = preload("res://assets/neon-mansion/architecture/module.tscn")
const Architecture = preload("res://assets/neon-mansion/scripts/architecture.gd")
const WALL = preload("res://assets/neon-mansion/materials/dark_teal.tres")
const FLOOR = preload("res://assets/neon-mansion/materials/charcoal.tres")
const TRIM = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
@export var wall_material: Material = WALL
@export var floor_material: Material = preload("res://assets/neon-mansion/materials/dark_tile.tres")
@export var lower_wall_material: Material = FLOOR
@export var room_id: StringName
@export_enum("anchor", "generated") var room_role: String = "anchor"
@export var display_name: String = "Room"
@export var footprint: Vector2 = Vector2(8, 8)
@export var ceiling_height: float = 4.0
@export var portals: Dictionary = {}
@export var discovery_permanent: bool = true

func _ready() -> void:
	add_to_group("mansion_rooms")
	set_meta("room_id", room_id)
	set_meta("room_role", room_role)
	for x in range(int(footprint.x / 4)):
		for z in range(int(footprint.y / 4)):
			module("Primitive_Floor", Vector3(4, 0.2, 4), Vector3(-footprint.x / 2 + 2 + x * 4, -0.1, -footprint.y / 2 + 2 + z * 4), floor_material)
	for edge in ["north", "south", "east", "west"]:
		build_edge(edge)
	module("Primitive_Floor", Vector3(footprint.x, 0.2, footprint.y), Vector3(0, ceiling_height + 0.1, 0), FLOOR)
	var area := Area3D.new()
	area.name = "DiscoveryVolume"
	area.collision_layer = 0
	area.collision_mask = 2
	add_child(area)
	var shape := BoxShape3D.new()
	shape.size = Vector3(footprint.x - 0.5, ceiling_height, footprint.y - 0.5)
	var collider := CollisionShape3D.new()
	collider.shape = shape
	collider.position.y = ceiling_height / 2
	area.add_child(collider)
	area.body_entered.connect(_on_entered)

func _on_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		get_tree().call_group("mansion_registry", "discover_room", room_id)

func module(asset: String, size: Vector3, at: Vector3, material: Material, yaw: float = 0.0) -> Node3D:
	var part = Module.instantiate()
	part.asset_name = asset
	part.dimensions = size
	part.surface = material
	part.position = at
	part.rotation.y = yaw
	add_child(part)
	return part

func build_edge(edge: String) -> void:
	var horizontal := edge == "north" or edge == "south"
	var length: float = footprint.x if horizontal else footprint.y
	var spans: Array[Vector2] = []
	if portals.has(edge):
		var entry: Dictionary = portals[edge]
		var offset: float = entry.get("offset", 0.0)
		var elevation: float = entry.get("elevation", 0.0)
		var half_width: float = entry.get("width", 2.0) / 2.0
		var opening_height: float = entry.get("height", 2.9)
		spans.append(Vector2(-length / 2, offset - half_width))
		spans.append(Vector2(offset + half_width, length / 2))
		segment(edge, offset - half_width, offset + half_width, elevation + opening_height, ceiling_height)
		if elevation > 0:
			segment(edge, offset - half_width, offset + half_width, 0, elevation)
	else:
		spans.append(Vector2(-length / 2, length / 2))
	for span in spans:
		var cursor: float = span.x
		while cursor < span.y - 0.01:
			var end: float = minf(cursor + 4, span.y)
			segment(edge, cursor, end, 0, ceiling_height)
			cursor = end

func edge_position(edge: String, along: float, height: float) -> Vector3:
	match edge:
		"north": return Vector3(along, height, -footprint.y / 2 + 0.15)
		"south": return Vector3(along, height, footprint.y / 2 - 0.15)
		"east": return Vector3(footprint.x / 2 - 0.15, height, along)
		_: return Vector3(-footprint.x / 2 + 0.15, height, along)

func segment(edge: String, start: float, end: float, bottom: float, top: float) -> void:
	if end - start < 0.01 or top - bottom < 0.01:
		return
	var yaw: float = 0.0 if edge == "north" or edge == "south" else PI / 2
	var center := (start + end) / 2
	module("Primitive_Wall", Vector3(end - start, top - bottom, 0.3), edge_position(edge, center, (top + bottom) / 2), wall_material, yaw)
	for height in [bottom + 0.08, top - 0.08]:
		var trim := Architecture.box(self, Vector3(end - start, 0.045, 0.34), edge_position(edge, center, height), METAL)
		trim.rotation.y = yaw
	if is_zero_approx(bottom):
		var panel := Architecture.box(self, Vector3(end - start, 1.1, 0.33), edge_position(edge, center, 0.62), lower_wall_material)
		panel.rotation.y = yaw
		var lip := Architecture.box(self, Vector3(end - start, 0.035, 0.35), edge_position(edge, center, 1.2), BRASS)
		lip.rotation.y = yaw
		if end - start > 2.0:
			var accent := Architecture.box(self, Vector3(0.75, 0.025, 0.36), edge_position(edge, center, 0.08), TRIM)
			accent.rotation.y = yaw
