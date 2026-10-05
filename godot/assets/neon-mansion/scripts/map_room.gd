extends "res://assets/neon-mansion/scripts/room.gd"
## Multi-portal shell. Geometry derives only from authored layout records.
var definition: Dictionary
var kit: Node
const KIT = preload("res://assets/neon-mansion/scripts/interior_kit.gd")

func _ready() -> void:
	room_id = StringName(definition.id)
	display_name = definition.name
	footprint = Vector2(definition.size[0], definition.size[1])
	ceiling_height = definition.height
	portals = definition.get("portals", {})
	room_role = "generated" if definition.role == "random_socket" else "anchor"
	add_to_group("mansion_rooms")
	set_meta("room_id", room_id)
	set_meta("definition_role", definition.role)
	set_meta("socket_id", definition.get("socket_id", ""))
	if definition.get("shell", true):
		build_floor(definition.get("floor_regions", [[-footprint.x / 2, -footprint.y / 2, footprint.x, footprint.y]]), -0.1, floor_material)
		for edge in ["north", "south", "east", "west"]:
			build_edge(edge)
		build_floor(definition.get("ceiling_regions", [[-footprint.x / 2, -footprint.y / 2, footprint.x, footprint.y]]), ceiling_height + 0.1, FLOOR)
	add_volume(Vector3.ZERO, Vector3(footprint.x - 0.5, ceiling_height, footprint.y - 0.5))

func build_floor(regions: Array, y: float, material: Material) -> void:
	for rect in regions:
		Architecture.box(self, Vector3(rect[2], 0.2, rect[3]), Vector3(rect[0] + rect[2]/2.0, y, rect[1] + rect[3]/2.0), material, true)

func build_edge(edge: String) -> void:
	var length: float = footprint.x if edge in ["north", "south"] else footprint.y
	var openings: Array = portals.get(edge, [])
	var cuts: Array[float] = [-length/2, length/2]
	for entry in openings:
		cuts.append(float(entry.offset) - float(entry.width)/2)
		cuts.append(float(entry.offset) + float(entry.width)/2)
	cuts.sort()
	for index in range(cuts.size() - 1):
		var start := cuts[index]
		var end := cuts[index + 1]
		if end - start < 0.01:
			continue
		var levels: Array[float] = [0.0, ceiling_height]
		for entry in openings:
			if (start + end)/2 > entry.offset - entry.width/2.0 and (start + end)/2 < entry.offset + entry.width/2.0:
				levels.append(float(entry.elevation))
				levels.append(float(entry.elevation) + float(entry.height))
		levels.sort()
		for j in range(levels.size() - 1):
			var y := (levels[j] + levels[j+1])/2
			var hole := false
			for entry in openings:
				if (start+end)/2 > entry.offset-entry.width/2.0 and (start+end)/2 < entry.offset+entry.width/2.0 and y > entry.elevation and y < entry.elevation+entry.height:
					hole = true
			if not hole:
				var cursor := start
				while cursor < end - 0.01:
					segment(edge, cursor, minf(cursor+4, end), levels[j], levels[j+1])
					cursor += 4

func add_volume(at: Vector3, size: Vector3) -> void:
	var area := Area3D.new()
	area.name = "DiscoveryVolume"
	area.collision_layer = 0
	area.collision_mask = 2
	add_child(area)
	var shape := BoxShape3D.new()
	shape.size = size
	var collider := CollisionShape3D.new()
	collider.shape = shape
	collider.position = at + Vector3(0, size.y/2, 0)
	area.add_child(collider)
	area.body_entered.connect(_on_entered)

