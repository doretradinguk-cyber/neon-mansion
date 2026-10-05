extends MeshInstance3D
## Loops still frames on this quad's material.
@export var frames: Array[Texture2D] = []
@export var frames_per_second: float = 1.0
var elapsed := 0.0

func _process(delta: float) -> void:
	if frames.is_empty():
		return
	elapsed += delta
	(material_override as StandardMaterial3D).albedo_texture = frames[int(elapsed * frames_per_second) % frames.size()]
