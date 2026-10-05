extends Node3D
## Future frequency effects live here, never on shared normal-mansion materials.
@export var corruption_base: Material = preload("res://assets/neon-mansion/nightmare-fx/materials/corruption_base.tres")
@export var corruption_emissive: Material = preload("res://assets/neon-mansion/nightmare-fx/materials/corruption_emissive.tres")
@export var active: bool = false:
	set(value):
		active = value
		visible = value
		process_mode = Node.PROCESS_MODE_INHERIT if value else Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	active = active
