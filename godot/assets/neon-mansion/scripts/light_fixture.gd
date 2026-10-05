extends Node3D
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const MAGENTA = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
@export_enum("sconce", "chandelier", "flush") var kind := "sconce"
@export var energy := 1.8
@export var range_metres := 7.0
@export var warm := false
var normal_color: Color
var light: OmniLight3D

func _ready() -> void:
	normal_color = Color(0.9, 0.70, 0.45) if warm else Color(0.60, 0.80, 0.86)
	if kind == "chandelier":
		A.box(self, Vector3(0.08, 2, 0.08), Vector3(0, 1, 0), BRASS)
		for i in range(8):
			var angle := i * TAU/8
			var arm := A.box(self, Vector3(1.8, 0.08, 0.1), Vector3(cos(angle)*0.9, 0, sin(angle)*0.9), BRASS)
			arm.rotation.y = -angle
			A.box(self, Vector3(0.10, 0.5, 0.10), Vector3(cos(angle)*1.8, 0.28, sin(angle)*1.8), MAGENTA)
	else:
		A.box(self, Vector3(0.32, 0.55, 0.14), Vector3.ZERO, BRASS)
		A.box(self, Vector3(0.24, 0.36, 0.16), Vector3(0, -0.05, 0.12), METAL)
		A.box(self, Vector3(0.20, 0.12, 0.10), Vector3(0, -0.10, 0.22), CYAN)
	light = OmniLight3D.new()
	light.light_color = normal_color
	light.light_energy = energy
	light.omni_range = range_metres
	light.position.z = 0.5 if kind == "sconce" else 0
	light.shadow_enabled = false
	add_child(light)
	add_to_group("nightmare_light_hooks")

func set_frequency(active: bool) -> void:
	light.light_color = Color(1, 0.03, 0.3) if active else normal_color

