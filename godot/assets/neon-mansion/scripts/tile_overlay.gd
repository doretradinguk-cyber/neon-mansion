@tool
extends MeshInstance3D
## Optional decal layer over the floor. Hide or delete this node freely; nothing else depends on it.
@export var enabled: bool = true:
	set(value):
		enabled = value
		visible = value
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.25:
	set(value):
		opacity = value
		apply()

func _ready() -> void:
	visible = enabled
	apply()

func apply() -> void:
	var material := material_override as StandardMaterial3D
	if material:
		material.albedo_color.a = opacity
