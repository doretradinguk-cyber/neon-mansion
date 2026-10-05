extends SceneTree
var failures: Array[String] = []
func _initialize() -> void:
	call_deferred("run")
func check(ok: bool, message: String) -> void:
	if not ok:
		failures.append(message)
		push_error(message)
func frames(count: int) -> void:
	for i in range(count):
		await physics_frame
func run() -> void:
	var level = (load("res://assets/neon-mansion/scenes/foundation.tscn") as PackedScene).instantiate()
	level.assignment_file = "res://../work/map-foundation/input-run-state.json"
	root.add_child(level)
	var player = level.get_node("Player")
	await frames(10)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	check(Input.mouse_mode==Input.MOUSE_MODE_CAPTURED,"Rendered pointer capture")
	var motion := InputEventMouseMotion.new()
	motion.relative = Vector2(30,-20)
	player._unhandled_input(motion)
	check(absf(player.rotation.y+0.06)<0.001 and absf(player.pitch-0.04)<0.001,"Mouse yaw and pitch")
	motion.relative = Vector2(0,5000)
	player._unhandled_input(motion)
	check(absf(player.pitch+1.45)<0.001,"Mouse pitch limit")
	player.rotation = Vector3.ZERO
	player.pitch = 0
	player.camera.rotation = Vector3.ZERO
	player.position = Vector3(0,0.05,14)
	player.velocity = Vector3.ZERO
	Input.action_press("move_forward")
	await frames(35)
	Input.action_release("move_forward")
	check(player.position.z>12.25 and player.position.z<12.8,"WASD moves and closed front door blocks")
	player.ray.force_raycast_update()
	var door = level.doors_by_id[&"door_front_arrival"]
	check(player.focused_door()==door,"Input ray focus")
	var action := InputEventAction.new()
	action.action = "interact"
	action.pressed = true
	player._unhandled_input(action)
	await frames(40)
	check(door.opened,"E action opens both anchor leaves")
	Input.action_press("move_forward")
	await frames(40)
	Input.action_release("move_forward")
	check(player.position.z<10.5,"WASD passes opened door")
	action = InputEventAction.new()
	action.action = "interact"
	action.pressed = true
	# Close through the actual E handler from the reverse side.
	player.position = Vector3(1.5,0.05,10)
	player.rotation.y = -PI/2
	await frames(4)
	player.ray.force_raycast_update()
	check(player.focused_door()==door,"Reverse-side open leaf focus")
	player._unhandled_input(action)
	await frames(40)
	check(not door.opened,"E action closes from reverse side")
	var escape := InputEventKey.new()
	escape.keycode = KEY_ESCAPE
	escape.pressed = true
	player._unhandled_input(escape)
	check(Input.mouse_mode==Input.MOUSE_MODE_VISIBLE,"Escape releases pointer")
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	player._unhandled_input(click)
	check(Input.mouse_mode==Input.MOUSE_MODE_CAPTURED,"Left click recaptures pointer")
	print("RENDERED INPUT CHECKS: ","PASS" if failures.is_empty() else failures)
	quit(0 if failures.is_empty() else 1)
