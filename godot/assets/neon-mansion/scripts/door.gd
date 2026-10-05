extends Node3D
signal state_changed(door_id: StringName, opened: bool)
const Module = preload("res://assets/neon-mansion/architecture/module.tscn")
const BLACK = preload("res://assets/neon-mansion/materials/near_black.tres")
const Visual = preload("res://assets/neon-mansion/scripts/door_visual.gd")
const Nightmare = preload("res://assets/neon-mansion/scripts/door_nightmare.gd")
@export var door_id: StringName
@export var room_a: StringName
@export var room_b: StringName
@export var caption: String = "ACCESS"
@export var room_number: String = ""
@export var style: Resource = preload("res://assets/neon-mansion/architecture/doors/styles/standard.tres")
@export var nightmare_active: bool = false:
	set(value):
		nightmare_active = value
		for effect in nightmare_layers:
			effect.active = value
var opened := false
var pivot: Node3D
var tween: Tween
var pivots: Array[Node3D] = []
var nightmare_layers: Array[Node3D] = []

func _ready() -> void:
	add_to_group("mansion_doors")
	assert(style != null and style.leaf_count in [1, 2])
	var width: float = style.leaf_width * style.leaf_count
	var visual := Node3D.new()
	visual.set_script(Visual)
	visual.name = "NormalVisuals"
	add_child(visual)
	visual.frame(self, style)
	for index in range(style.leaf_count):
		var direction: float = 1.0 if index == 0 else -1.0
		var hinge := Node3D.new()
		hinge.name = "Hinge" if index == 0 else "RightHinge"
		hinge.position.x = -direction * width / 2
		add_child(hinge)
		pivots.append(hinge)
		var panel = Module.instantiate()
		panel.name = "DoorPanel"
		panel.asset_name = "Door_A"
		panel.dimensions = Vector3(style.leaf_width, style.leaf_height, 0.16)
		panel.surface = BLACK
		panel.position = Vector3(direction * style.leaf_width / 2, style.leaf_height / 2, 0)
		panel.set_meta("door_id", door_id)
		hinge.add_child(panel)
		visual.leaf(hinge, style, direction, room_number)
		var effect := Node3D.new()
		effect.set_script(Nightmare)
		effect.name = "NightmareVisuals"
		effect.set("leaf_width", style.leaf_width)
		effect.set("leaf_height", style.leaf_height)
		effect.set("direction", direction)
		hinge.add_child(effect)
		nightmare_layers.append(effect)
	pivot = pivots[0]
	nightmare_active = nightmare_active
	for side in [-1, 1]:
		var label := Label3D.new()
		label.text = caption
		label.double_sided = false
		label.font_size = 32
		label.pixel_size = 0.008
		label.modulate = Color(0.2, 1.0, 0.85)
		label.outline_modulate = Color(0.01, 0.02, 0.025)
		label.position = Vector3(0, style.leaf_height + (0.64 if style.pointed_profile else 0.49), side * 0.43)
		if side == -1:
			label.rotation.y = PI
		add_child(label)

func interact() -> void:
	if tween and tween.is_running():
		return
	opened = not opened
	tween = create_tween()
	tween.set_parallel(true)
	for index in range(pivots.size()):
		var angle: float = (PI / 2 if index == 0 else -PI / 2) if opened else 0.0
		tween.tween_property(pivots[index], "rotation:y", angle, 0.4).set_trans(Tween.TRANS_SINE)
	state_changed.emit(door_id, opened)
