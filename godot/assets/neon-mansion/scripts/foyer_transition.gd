extends Node3D
## Connector belonging to Entrance Hall, not an extra procedural/discovery room.
const Module = preload("res://assets/neon-mansion/architecture/module.tscn")
const WALL = preload("res://assets/neon-mansion/materials/dark_teal.tres")
const FLOOR = preload("res://assets/neon-mansion/materials/dark_marble.tres")
const CEILING = preload("res://assets/neon-mansion/materials/charcoal.tres")

func _ready() -> void:
	set_meta("owner_room_id", &"entrance_hall")
	_module("Primitive_Floor", Vector3(4, 0.2, 4), Vector3(0, -0.1, 0), FLOOR)
	_module("Primitive_Floor", Vector3(4, 0.2, 4), Vector3(0, 4.3, 0), CEILING)
	for x in [-1.85, 1.85]:
		_module("Primitive_Wall", Vector3(0.3, 4.2, 4), Vector3(x, 2.1, 0), WALL)

func _module(asset: String, size: Vector3, at: Vector3, material: Material) -> void:
	var part = Module.instantiate()
	part.asset_name = asset
	part.dimensions = size
	part.position = at
	part.surface = material
	add_child(part)
