extends CharacterBody3D
## Input and camera belong to this instance; a later second player can disable both.
@export var local_control: bool = true
@export var walking_speed: float = 4.0
@export var mouse_sensitivity: float = 0.002
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/InteractRay
@onready var hint: Label = $HUD/Hint
var pitch := 0.0

func _ready() -> void:
	add_to_group("players")
	camera.current = local_control
	$HUD.visible = local_control
	if local_control:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	ray.add_exception(self)

func _unhandled_input(event: InputEvent) -> void:
	if not local_control:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pitch = clampf(pitch - event.relative.y * mouse_sensitivity, -1.45, 1.45)
		camera.rotation.x = pitch
	if event.is_action_pressed("interact") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var door := focused_door()
		if door:
			door.interact()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= 20.0 * delta
	if local_control:
		var direction := Vector2.ZERO
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var movement := transform.basis * Vector3(direction.x, 0, direction.y)
		velocity.x = movement.x * walking_speed
		velocity.z = movement.z * walking_speed
	move_and_slide()
	if local_control:
		var door := focused_door()
		hint.text = "E  —  " + ("Close " if door.opened else "Open ") + door.caption if door else ""
	if global_position.y < -10:
		global_position = Vector3(0, 0.05, -2)
		velocity = Vector3.ZERO

func focused_door() -> Node:
	if not ray.is_colliding():
		return null
	var node = ray.get_collider()
	while node and node != get_tree().root:
		if node.has_method("interact") and node.is_in_group("mansion_doors"):
			return node
		node = node.get_parent()
	return null
