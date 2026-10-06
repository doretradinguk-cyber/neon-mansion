extends MeshInstance3D
@export var frames: Array[Texture2D] = []
@export var frame_seconds := 1.2
@export var transition_seconds := 0.25
var elapsed := 0.0
func _process(delta: float) -> void:
    if frames.is_empty():
        return
    elapsed += delta
    var index := int(elapsed / frame_seconds) % frames.size()
    var phase := fmod(elapsed, frame_seconds)
    var material := material_override as ShaderMaterial
    material.set_shader_parameter("frame_a", frames[index])
    material.set_shader_parameter("frame_b", frames[(index + 1) % frames.size()])
    material.set_shader_parameter("transition", smoothstep(frame_seconds-transition_seconds,frame_seconds,phase))
