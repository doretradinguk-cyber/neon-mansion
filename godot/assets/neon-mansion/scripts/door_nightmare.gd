extends Node3D
## Entirely visual. Does not alter collision, interaction, shared materials or IDs.
const EFFECT = preload("res://assets/neon-mansion/nightmare-fx/shaders/door_contamination.gdshader")
@export var active: bool = false:
	set(value):
		active = value
		visible = value
		process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED
var leaf_width: float = 1.92
var leaf_height: float = 2.78
var direction: float = 1.0

func _ready() -> void:
	for side in [-1, 1]:
		_overlay(Vector2(leaf_width * 0.90, leaf_height * 0.9), Vector3(direction * leaf_width / 2, leaf_height / 2, side * 0.21), side, false)
		_overlay(Vector2(0.24, 0.3), Vector3(direction * leaf_width * 0.86, 1.45, side * 0.255), side, true)
	active = active

func _overlay(size: Vector2, at: Vector3, side: int, panel: bool) -> void:
	var quad := MeshInstance3D.new()
	var mesh := QuadMesh.new()
	mesh.size = size
	quad.mesh = mesh
	quad.position = at
	if side == -1:
		quad.rotation.y = PI
	var material := ShaderMaterial.new()
	material.shader = EFFECT
	material.set_shader_parameter("access_panel", panel)
	material.set_shader_parameter("seed", leaf_width * 13.0 + direction)
	quad.material_override = material
	quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(quad)
