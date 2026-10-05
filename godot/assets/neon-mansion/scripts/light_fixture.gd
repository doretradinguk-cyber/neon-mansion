extends Node3D
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const G = preload("res://assets/neon-mansion/scripts/visual_geometry.gd")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const MAGENTA = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
const WARM = preload("res://assets/neon-mansion/materials/lamp_warm.tres")
@export_enum("sconce", "chandelier", "flush") var kind := "sconce"
@export var energy := 1.8
@export var range_metres := 7.0
@export var warm := false
var normal_color: Color
var light: OmniLight3D

func _ready() -> void:
	normal_color = Color(0.82,0.68,0.53) if warm else Color(0.32,0.70,0.83)
	if kind == "chandelier":
		G.cylinder(self,Vector3(0,1.1,0),0.05,2.2,BRASS)
		G.cylinder(self,Vector3(0,0.12,0),0.26,0.38,METAL)
		G.ring(self,Vector3.ZERO,1.65,0.09,BRASS,true)
		G.ring(self,Vector3(0,0.6,0),0.95,0.055,METAL,true)
		for i in range(8):
			var direction := Vector3(cos(i*TAU/8),0,sin(i*TAU/8))
			G.beam(self,Vector3(0,0.15,0),direction*1.65,0.065,0.065,BRASS)
			G.beam(self,Vector3(0,0.95,0),direction*1.65,0.025,0.025,METAL)
			G.cylinder(self,direction*1.65+Vector3(0,0.10,0),0.14,0.07,BRASS)
			G.cylinder(self,direction*1.65+Vector3(0,0.32,0),0.055,0.37,WARM if warm else MAGENTA)
			G.cylinder(self,direction*1.65-Vector3(0,0.24,0),0.038,0.35,METAL)
		G.cylinder(self,Vector3(0,-0.45,0),0.10,0.38,BRASS)
	elif kind == "sconce":
		A.box(self,Vector3(0.27,0.64,0.07),Vector3.ZERO,BRASS)
		A.box(self,Vector3(0.20,0.53,0.04),Vector3(0,0,0.055),METAL)
		G.beam(self,Vector3(0,0.18,0.07),Vector3(0,0.18,0.4),0.05,0.06,BRASS)
		G.cylinder(self,Vector3(0,-0.04,0.4),0.16,0.43,METAL)
		G.cylinder(self,Vector3(0,-0.255,0.4),0.145,0.024,WARM if warm else CYAN)
		G.cylinder(self,Vector3(0,0.18,0.4),0.18,0.055,BRASS)
		for x in [-0.09,0.09]:
			for y in [-0.25,0.25]:
				G.cylinder(self,Vector3(x,y,0.06),0.018,0.018,METAL,Vector3(PI/2,0,0))
	else:
		G.cylinder(self,Vector3.ZERO,0.36,0.10,METAL)
		G.ring(self,Vector3(0,-0.055,0),0.27,0.035,CYAN,true)
	G.batch(self)
	light = OmniLight3D.new()
	light.light_color = normal_color
	light.light_energy = energy*0.82
	light.omni_range = range_metres
	light.light_specular = 0.35
	light.position = Vector3(0,-0.35,0.6) if kind == "sconce" else Vector3(0,-0.3,0)
	light.shadow_enabled = false
	light.distance_fade_enabled = true
	light.distance_fade_begin = 35
	light.distance_fade_length = 15
	add_child(light)
	add_to_group("nightmare_light_hooks")

func set_frequency(active: bool) -> void:
	light.light_color = Color(1,0.03,0.3) if active else normal_color
