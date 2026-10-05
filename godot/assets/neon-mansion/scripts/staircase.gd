extends Node3D
const G = preload("res://assets/neon-mansion/scripts/visual_geometry.gd")
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
	# Surface dress only; wedge, original posts and handrail collision stay identical.
	var carpet = preload("res://assets/neon-mansion/materials/burgundy_carpet.tres")
	for i in range(step_count):
		var y := (i+1)*rise/step_count
		var z := half_run-(i+0.5)*run_length/step_count
		Architecture.box(self,Vector3(stair_width*0.44,0.012,run_length/step_count),Vector3(0,y+0.008,z),carpet)
		Architecture.box(self,Vector3(stair_width*0.44,rise/step_count,0.012),Vector3(0,y-rise/step_count/2,z+run_length/step_count/2+0.007),carpet)
		for x in [-stair_width*0.23,stair_width*0.23]:
			Architecture.box(self,Vector3(0.025,0.015,run_length/step_count),Vector3(x,y+0.012,z),BRASS)
	for x in [-half_width-0.15,half_width+0.15]:
		for t in [0.0,1.0]:
			var at := Vector3(x,t*rise,half_run-t*run_length)
			Architecture.box(self,Vector3(0.20,1.15,0.20),at+Vector3(0,0.575,0),METAL)
			G.cylinder(self,at+Vector3(0,1.18,0),0.16,0.08,BRASS)
		for i in range(1,24):
			var t := i/24.0
			Architecture.box(self,Vector3(0.035,1.0,0.035),Vector3(x,t*rise+0.50,half_run-t*run_length),METAL)
			Architecture.box(self,Vector3(0.07,0.07,0.07),Vector3(x,t*rise+0.55,half_run-t*run_length),BRASS)
	G.batch(self)
