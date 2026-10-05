extends Node3D
const Module = preload("res://assets/neon-mansion/architecture/module.tscn")
const Architecture = preload("res://assets/neon-mansion/scripts/architecture.gd")
const FLOOR = preload("res://assets/neon-mansion/materials/dark_marble.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const TRIM = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
@export var stair_width: float = 4.0
@export var run_length: float = 10.0
@export var rise: float = 3.2
@export var step_count: int = 8

func _ready() -> void:
	# Inspected KayKit mesh has eight steps and rises toward native -X.
	if step_count == 8:
		var stairs = Module.instantiate()
		stairs.asset_name = "Primitive_Stairs"
		stairs.dimensions = Vector3(run_length, rise, stair_width)
		stairs.surface = FLOOR
		stairs.solid = false
		stairs.position.y = rise / 2
		stairs.rotation.y = -PI / 2
		add_child(stairs)
	else:
		for i in range(step_count):
			var height := (i + 1) * rise / step_count
			Architecture.box(self, Vector3(stair_width, height, run_length / step_count), Vector3(0, height / 2, run_length / 2 - (i + 0.5) * run_length / step_count), FLOOR)
	var body := StaticBody3D.new()
	add_child(body)
	var collision := CollisionShape3D.new()
	var wedge := ConvexPolygonShape3D.new()
	var half_width := stair_width / 2
	var half_run := run_length / 2
	wedge.points = PackedVector3Array([
		Vector3(-half_width, 0, half_run), Vector3(half_width, 0, half_run),
		Vector3(-half_width, 0, -half_run), Vector3(half_width, 0, -half_run),
		Vector3(-half_width, rise, -half_run), Vector3(half_width, rise, -half_run)])
	collision.shape = wedge
	body.add_child(collision)
	for i in range(step_count):
		if step_count == 8 or i % 4 == 3:
			Architecture.box(self, Vector3(stair_width, 0.025, 0.055), Vector3(0, (i + 1) * rise / step_count + 0.01, half_run - i * run_length / step_count), TRIM)
	for x in [-half_width - 0.15, half_width + 0.15]:
		for i in range(9):
			Architecture.box(self, Vector3(0.075, 1.1, 0.075), Vector3(x, i * rise / 8 + 0.55, half_run - i * run_length / 8), METAL, true)
		var rail := Architecture.box(self, Vector3(0.12, 0.09, sqrt(run_length * run_length + rise * rise)), Vector3(x, rise / 2 + 1.1, 0), BRASS, true)
		rail.rotation.x = atan(rise / run_length)
		get_child(get_child_count() - 1).rotation.x = rail.rotation.x
