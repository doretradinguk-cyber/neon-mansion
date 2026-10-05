extends Node3D
## Owned procedural placeholder art; raw Firefly boards remain reference-only.
const ART_SHADER = preload("res://assets/neon-mansion/materials/shaders/firefly_artwork.gdshader")
@export_enum("Gothic mansion", "Retrowave abstract") var artwork_index: int = 0

func _ready() -> void:
	var material := ShaderMaterial.new()
	material.shader = ART_SHADER
	material.set_shader_parameter("artwork_index", artwork_index % 2)
	var quad := MeshInstance3D.new()
	var mesh := QuadMesh.new()
	mesh.size = Vector2(0.88, 1.08)
	quad.mesh = mesh
	quad.material_override = material
	quad.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(quad)
