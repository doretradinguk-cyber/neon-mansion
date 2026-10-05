extends SceneTree
const STORE = preload("res://assets/neon-mansion/scripts/socket_assignments.gd")
var level: Node3D
var player: CharacterBody3D
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
func stop() -> void:
	player.velocity = Vector3.ZERO
func walk(direction: Vector3, count: int) -> void:
	for i in range(count):
		player.velocity.x = direction.x * 4
		player.velocity.z = direction.z * 4
		await physics_frame
	player.velocity.x = 0
	player.velocity.z = 0
func go(target: Vector3) -> void:
	var reached := false
	for i in range(2000):
		var delta := Vector3(target.x-player.position.x,0,target.z-player.position.z)
		if delta.length() < 0.1:
			reached = true
			break
		player.velocity.x = delta.normalized().x * 4
		player.velocity.z = delta.normalized().z * 4
		await physics_frame
	player.velocity.x = 0
	player.velocity.z = 0
	await frames(3)
	check(reached,"Route blocked: " + str(target) + " from " + str(player.position))
	check(absf(player.position.y-target.y)<0.25,"Wrong floor at " + str(target) + ": " + str(player.position.y))

func run() -> void:
	level = (load("res://assets/neon-mansion/scenes/foundation.tscn") as PackedScene).instantiate()
	level.assignment_file = "res://../work/map-foundation/validation-run-state.json"
	player = level.get_node("Player")
	player.local_control = false
	root.add_child(level)
	await frames(10)
	check(level.rooms_by_id.size()==43,"All map spaces present")
	check(level.doors_by_id.size()==41,"All authored doors present")
	for id in [&"entrance_hall",&"grand_stair_hall",&"long_gallery",&"drawing_room"]:
		check(level.rooms_by_id.has(id),"Original room ID missing")
	for id in [&"door_entrance_stair",&"door_stair_gallery",&"door_gallery_drawing"]:
		check(level.doors_by_id.has(id),"Original door ID missing")
	check(level.rooms_by_id[&"long_gallery"].position.y==0,"Gallery must be ground-floor spine")
	# Mouse-gated input is verified separately in rendered mode.
	player.local_control = false
	stop()
	# Every real installed door: closed block, E action via ray owner, open passage, close.
	for definition in level.layout.doors:
		var door = level.doors_by_id[StringName(definition.id)]
		var normal: Vector3 = Basis(Vector3.UP,definition.yaw) * Vector3(0,0,1)
		player.position = door.position + normal*2 + Vector3(0,0.05,0)
		player.rotation = Vector3(0,definition.yaw,0)
		player.camera.rotation = Vector3.ZERO
		stop()
		await frames(4)
		await walk(-normal,35)
		var remaining: float = (player.position-door.position).dot(normal)
		check(remaining>0.25 and remaining<0.75,definition.id + ": closed door collision / safe approach")
		player.ray.force_raycast_update()
		check(player.focused_door()==door,definition.id + ": ray resolves interaction")
		player.local_control = true
		var action := InputEventAction.new()
		action.action = "interact"
		action.pressed = true
		if DisplayServer.get_name() == "headless":
			door.interact()
		else:
			player._unhandled_input(action)
		player.local_control = false
		await frames(30)
		check(door.opened,definition.id + ": E opens")
		await walk(-normal,38)
		check((player.position-door.position).dot(normal)<-1.6,definition.id + ": open doorway traversable")
		door.interact()
		await frames(30)
		check(not door.opened,definition.id + ": close")
		check(not door.nightmare_active,definition.id + ": normal state")
		print("DOOR CHECK COMPLETE ",definition.id)
	# Required arrival sequence, including uninterrupted central arrival lane.
	for door in level.doors_by_id.values():
		door.interact()
	await frames(30)
	player.position = Vector3(0,0.05,32)
	stop()
	for at in [Vector3(0,0,16),Vector3(0,0,6),Vector3(0,0,-6),Vector3(0,0,-18),Vector3(0,0,-28),Vector3(0,0,-34),Vector3(10,0,-34),Vector3(10,0,-42),Vector3(20,0,-42),Vector3(24,0,-42),Vector3(24,0,-34)]:
		await go(at)
	for id in [&"entrance_hall",&"foyer_reception",&"grand_stair_hall",&"long_gallery",&"drawing_room"]:
		check(level.discovered_rooms.has(id),"Arrival discovery missing: "+String(id))
	for at in [Vector3(21,0,-34),Vector3(21,0,-31),Vector3(21,0,-29),Vector3(21,0,-31),Vector3(27,0,-31),Vector3(27,0,-29),Vector3(27,0,-31),Vector3(24,0,-34)]:
		await go(at)
	print("DRAWING ROOM FURNITURE LANES PASS")
	await go(Vector3(24,0,-42))
	await go(Vector3(10,0,-42))
	await go(Vector3(10,0,-34))
	await go(Vector3(0,0,-34))
	await go(Vector3(0,6.4,-57))
	print("UPPER LANDING ",player.position)
	for at in [Vector3(13,6.4,-57),Vector3(13,6.4,-38)]:
		await go(at)
	await walk(Vector3(0,0,1),60)
	check(player.position.z < -34.25 and absf(player.position.y-6.4)<0.15,"Front balcony guard")
	await go(Vector3(13,6.4,-57))
	await go(Vector3(-13,6.4,-57))
	await go(Vector3(-13,6.4,-38))
	await walk(Vector3(1,0,0),60)
	check(player.position.x < -10.25 and absf(player.position.y-6.4)<0.15,"Inner balcony guard")
	await go(Vector3(-13,6.4,-57))
	await go(Vector3(0,6.4,-57))
	await go(Vector3(22,6.4,-57))
	await go(Vector3(0,6.4,-57))
	await go(Vector3(0,0,-34))
	await go(Vector3(0,0,4))
	print("ARRIVAL AND STAIR ROUTE PASS")
	# Service descent: authored hole with guarded perimeter and correct lower ceiling cutout.
	player.position = Vector3(41,0.05,-61)
	stop()
	await frames(4)
	await go(Vector3(41,-6.4,-47))
	await go(Vector3(40,-6.4,-42))
	await go(Vector3(64,-6.4,-42))
	await go(Vector3(64,-6.4,-54))
	await go(Vector3(80,-6.4,-54))
	await go(Vector3(80,-6.4,-74))
	await go(Vector3(80,-6.4,-54))
	await go(Vector3(64,-6.4,-54))
	await go(Vector3(64,-6.4,-42))
	await go(Vector3(40,-6.4,-42))
	await go(Vector3(41,-6.4,-47))
	await go(Vector3(41,0,-61))
	print("BASEMENT PROGRESSION ROUTE PASS")
	# No unrelated room footprints overlap at the same level; overlay volumes are intentional.
	for i in range(level.layout.rooms.size()):
		var a: Dictionary = level.layout.rooms[i]
		if not a.get("shell",true):
			continue
		for j in range(i+1,level.layout.rooms.size()):
			var b: Dictionary = level.layout.rooms[j]
			if not b.get("shell",true) or a.position[1]!=b.position[1]:
				continue
			var ra := Rect2(a.position[0]-a.size[0]/2.0,a.position[2]-a.size[1]/2.0,a.size[0],a.size[1])
			var rb := Rect2(b.position[0]-b.size[0]/2.0,b.position[2]-b.size[1]/2.0,b.size[0],b.size[1])
			check(not ra.intersects(rb),a.id+" overlaps "+b.id)
	# Both templates use identical authored shell/door and leave the exclusion lane clear.
	var socket: Dictionary = level.socket_definition("GF-R01")
	var shell = level.rooms_by_id[&"random_ground"]
	var shell_position: Vector3 = shell.position
	var portal_snapshot: String = JSON.stringify(shell.portals)
	var corridor_transform: Transform3D = level.rooms_by_id[&"long_gallery"].transform
	for key in ["music","study"]:
		level.socket_instances["GF-R01"].queue_free()
		await frames(2)
		level.populate_socket(socket,key)
		check(shell.position==shell_position and JSON.stringify(shell.portals)==portal_snapshot,"Template moved doorway/shell")
		check(level.rooms_by_id[&"long_gallery"].transform==corridor_transform,"Template moved corridor")
		for prop in level.socket_instances["GF-R01"].get_children():
			if not prop.is_in_group("mansion_props"):
				continue
			var meshes: Array[MeshInstance3D] = []
			load("res://assets/neon-mansion/scripts/architecture.gd")._collect(prop,meshes)
			for mesh in meshes:
				var bounds: AABB = (shell.global_transform.affine_inverse()*mesh.global_transform)*mesh.get_aabb()
				var footprint := Rect2(bounds.position.x,bounds.position.z,bounds.size.x,bounds.size.z)
				check(Rect2(-7.7,-7.7,15.4,15.4).encloses(footprint),"Template furniture exceeds shell")
				for rect in socket.prop_exclusion_zones:
					check(not footprint.intersects(Rect2(rect[0],rect[1],rect[2],rect[3])),"Template furniture intersects door exclusion")
		player.position = Vector3(112,0.05,-42)
		stop()
		await frames(4)
		await go(Vector3(112,0,-34))
		await go(Vector3(112,0,-42))
		print("SOCKET TEMPLATE PASS ",key)
		var assignment := STORE.new()
		assignment.load_run(ProjectSettings.globalize_path("res://../work/map-foundation/persistence-"+key+".json"),level.layout.sockets,level.templates)
		assignment.assignments["GF-R01"] = key
		assignment.save()
		var reloaded := STORE.new()
		reloaded.load_run(assignment.path,level.layout.sockets,level.templates)
		check(reloaded.select(socket,level.templates,1 if key=="music" else 0)==key,"Assignment rerolled after reload")
	# Graph reachability: every map ID can be reached via an authored portal/stair/outdoor link.
	var seen := {"driveway":true}
	var pending: Array[String] = ["driveway"]
	while not pending.is_empty():
		var id: String = pending.pop_back()
		for next in level.navigation_links[id]:
			if not seen.has(next):
				seen[next] = true
				pending.append(next)
	check(seen.size()==level.rooms_by_id.size(),"Room graph has disconnected spaces")
	check(not level.get_node("NightmareLayer").active and not level.get_node("NightmareLayer").visible,"Nightmare master layer off")
	for door in level.doors_by_id.values():
		check(not door.nightmare_active,"Nightmare door off")
		for effect in door.nightmare_layers:
			check(not effect.visible,"Nightmare overlay visible")
	print("MANSION FOUNDATION CHECKS: ","PASS" if failures.is_empty() else failures)
	quit(0 if failures.is_empty() else 1)
