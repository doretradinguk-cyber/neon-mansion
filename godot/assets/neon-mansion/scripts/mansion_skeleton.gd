extends Node3D
## Authored permanent skeleton; variation is restricted to declared sockets.
signal room_discovered(room_id: StringName)
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const ROOM = preload("res://assets/neon-mansion/scripts/map_room.gd")
const KIT = preload("res://assets/neon-mansion/scripts/interior_kit.gd")
const ASSIGNMENTS = preload("res://assets/neon-mansion/scripts/socket_assignments.gd")
const RAILING = preload("res://assets/neon-mansion/architecture/balcony_railing.tscn")
const STAIR = preload("res://assets/neon-mansion/architecture/staircase.tscn")
const TEAL = preload("res://assets/neon-mansion/materials/dark_teal.tres")
const CHARCOAL = preload("res://assets/neon-mansion/materials/charcoal.tres")
const WOOD = preload("res://assets/neon-mansion/materials/walnut.tres")
const MARBLE = preload("res://assets/neon-mansion/materials/dark_marble.tres")
const TILE = preload("res://assets/neon-mansion/materials/dark_tile.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const GRASS = preload("res://assets/neon-mansion/materials/garden_ground.tres")
@export var assignment_file := "res://../work/map-foundation/run-state.json"
@export var run_seed := 0
var layout: Dictionary
var templates: Dictionary
var run_store: RefCounted
var rooms_by_id: Dictionary = {}
var doors_by_id: Dictionary = {}
var discovered_rooms: Dictionary = {}
var socket_instances: Dictionary = {}
var navigation_links: Dictionary = {}

func _enter_tree() -> void:
	add_to_group("mansion_registry")

func _ready() -> void:
	layout = JSON.parse_string(FileAccess.get_file_as_string("res://assets/neon-mansion/layout/mansion_layout.json"))
	templates = JSON.parse_string(FileAccess.get_file_as_string("res://assets/neon-mansion/layout/room_templates.json")).templates
	run_store = ASSIGNMENTS.new()
	run_store.load_run(ProjectSettings.globalize_path(assignment_file), layout.sockets, templates)
	var room_root := Node3D.new()
	room_root.name = "Rooms"
	add_child(room_root)
	for definition in layout.rooms:
		var room := Node3D.new()
		room.set_script(ROOM)
		room.definition = definition
		room.name = String(definition.id).to_pascal_case()
		room.position = vector(definition.position)
		room.floor_material = MARBLE if definition.role in ["anchor", "benchmark"] else TILE
		room.wall_material = CHARCOAL if definition.position[1] < 0 or definition.id == "drawing_room" else TEAL
		room.lower_wall_material = WOOD if definition.id in ["drawing_room", "foyer_reception", "lounge"] else CHARCOAL
		rooms_by_id[StringName(definition.id)] = room
		navigation_links[definition.id] = []
		room_root.add_child(room)
		if definition.get("socket_id", "") != "":
			room.set_meta("socket_definition", socket_definition(definition.socket_id))
		if definition.get("shell", true):
			dress_shell(room, definition)
	build_ground()
	build_balcony()
	for vertical in layout.vertical_connections:
		var stairs = STAIR.instantiate()
		stairs.name = vertical.id.to_pascal_case()
		stairs.position = vector(vertical.position)
		stairs.stair_width = vertical.width
		stairs.run_length = vertical.run
		stairs.rise = vertical.rise
		stairs.step_count = 32
		add_child(stairs)
		navigation_links[vertical.from].append(vertical.to)
		navigation_links[vertical.to].append(vertical.from)
	build_service_guards()
	var door_root := Node3D.new()
	door_root.name = "Doors"
	add_child(door_root)
	for definition in layout.doors:
		var source := load("res://assets/neon-mansion/architecture/doors/" + definition.variant + ".tscn") as PackedScene
		var door = source.instantiate()
		door.name = definition.id.to_pascal_case()
		door.door_id = StringName(definition.id)
		door.room_a = StringName(definition.room_a)
		door.room_b = StringName(definition.room_b)
		door.caption = definition.caption.to_upper()
		door.room_number = definition.number
		door.position = vector(definition.position)
		door.rotation.y = definition.yaw
		door.set_meta("via", definition.get("via", ""))
		doors_by_id[door.door_id] = door
		door_root.add_child(door)
		navigation_links[definition.room_a].append(definition.room_b)
		navigation_links[definition.room_b].append(definition.room_a)
		if definition.has("via"):
			navigation_links[definition.via].append(definition.room_a)
			navigation_links[definition.via].append(definition.room_b)
			navigation_links[definition.room_a].append(definition.via)
	# Outdoor zones share traversable grounds, not arbitrary generated corridors.
	for pair in [["driveway","front_garden"],["front_garden","rear_garden"],["rear_garden","pool_terrace"],["upper_landing","grand_stair_hall"]]:
		navigation_links[pair[0]].append(pair[1])
		navigation_links[pair[1]].append(pair[0])
	for socket in layout.sockets:
		add_socket_marker(socket)
		if not socket.templates.is_empty():
			populate_socket(socket, run_store.select(socket, templates, run_seed))
	dress_arrival()
	dress_drawing()
	for marker in layout.reserved_wing_connections:
		var node := Marker3D.new()
		node.name = marker.id
		node.position = vector(marker.position)
		node.rotation.y = marker.orientation
		node.set_meta("connection_id", marker.id)
		node.set_meta("active", false)
		add_child(node)
	$Player.global_position = Vector3(0, 0.05, 32)

static func vector(a: Array) -> Vector3:
	return Vector3(a[0], a[1], a[2])

func discover_room(id: StringName) -> void:
	if not rooms_by_id.has(id):
		return
	$Player/HUD/Room.text = rooms_by_id[id].display_name.to_upper()
	if not discovered_rooms.has(id):
		discovered_rooms[id] = {"room_id": String(id), "permanent": true, "definition": "mansion_layout.json"}
		room_discovered.emit(id)

func clear_edge(definition: Dictionary, edge: String, offset: float, margin: float = 1.5) -> bool:
	for portal in definition.portals.get(edge, []):
		if absf(offset - portal.offset) < portal.width/2.0 + margin:
			return false
	return true

func dress_shell(room: Node3D, definition: Dictionary) -> void:
	var w: float = definition.size[0]
	var d: float = definition.size[1]
	var h: float = definition.height
	if definition.id in ["entrance_hall", "grand_stair_hall", "drawing_room", "foyer_reception", "long_gallery"]:
		var bay_size := 8.0
		var nx := int(ceil(w/bay_size))
		var nz := int(ceil(d/bay_size))
		for x in range(nx):
			for z in range(nz):
				KIT.coffer(room, Vector3(-w/2 + (x+0.5)*w/nx, h-0.15, -d/2+(z+0.5)*d/nz), w/nx, d/nz)
	for side in [-1, 1]:
		var edge := "south" if side == 1 else "north"
		for x in range(int(w/8)):
			var along: float = -w/2+4+x*8
			if clear_edge(definition, edge, along):
				var at := Vector3(along, minf(h-1.2,3.3), side*(d/2-0.42))
				var yaw := PI if side == 1 else 0.0
				KIT.fixture(room, at, yaw, "sconce", 1.8, 8, definition.id in ["drawing_room", "foyer_reception"])
				if definition.id == "long_gallery":
					KIT.panel(room, Vector3(along, 1.9, side*(d/2-0.34)), yaw, 3.0, 2.2, CHARCOAL)
					KIT.painting(room, Vector3(along, 2.2, side*(d/2-0.29)), yaw, x%2)
	# One subtle indirect fill per ordinary shell; large halls receive authored fixtures below.
	if not definition.id in ["entrance_hall","grand_stair_hall","long_gallery"]:
		KIT.fixture(room, Vector3(0,h-0.5,0), 0, "flush", 1.7, maxf(w,d)*0.8)
	if definition.id == "foyer_reception":
		KIT.sign(room,definition.name.to_upper(),Vector3(w/2-0.42,4.6,0),-PI/2)
	else:
		KIT.sign(room, definition.name.to_upper(), Vector3(0,h-0.65,-d/2+0.42))
	if definition.role in ["defined_socket", "special_socket", "random_socket"]:
		KIT.sign(room, definition.get("socket_id", "FIXED SHELL") + " / " + definition.role.replace("_"," ").to_upper(), Vector3(0,2.7,d/2-0.42), PI)

func build_ground() -> void:
	var moon := DirectionalLight3D.new()
	moon.name = "ExteriorMoon"
	moon.rotation = Vector3(-0.7,-0.8,0)
	moon.light_color = Color(0.38,0.62,0.8)
	moon.light_energy = 0.45
	moon.shadow_enabled = true
	moon.directional_shadow_max_distance = 160
	add_child(moon)
	# Terrain must leave the service stair shaft open; it cannot bridge the kitchen hole.
	for region in [Rect2(-62,-132,100,208),Rect2(44,-132,114,208),Rect2(38,-132,6,72),Rect2(38,-48,6,124)]:
		A.box(self,Vector3(region.size.x,0.2,region.size.y),Vector3(region.get_center().x,-0.11,region.get_center().y),GRASS,true)
	A.box(self, Vector3(20,0.025,56), Vector3(0,0.005,40), TILE)
	A.box(self, Vector3(16,0.025,16), Vector3(40,0.005,-14), MARBLE)
	for x in [-7.0,7.0]:
		for z in [20.0,36.0,52.0,66.0]:
			KIT.column(self,Vector3(x,0,z),3.5)
			KIT.fixture(self,Vector3(x,3.3,z),0,"flush",1.4,9)
	for x in [-24.0,24.0]:
		for z in [24.0,42.0,60.0]:
			A.box(self,Vector3(6,0.8,6),Vector3(x,0.4,z),GRASS,true)
	# Non-swimmable pool placeholder; water and terrace are structural landmarks.
	A.box(self,Vector3(10,0.04,8),Vector3(40,0.04,-13),CYAN)
	for x in [34.8,45.2]:
		A.box(self,Vector3(0.3,0.35,8.6),Vector3(x,0.17,-13),CHARCOAL,true)
	for z in [-17.3,-8.7]:
		A.box(self,Vector3(10.7,0.35,0.3),Vector3(40,0.17,z),CHARCOAL,true)
	KIT.sign(self,"POOL TERRACE",Vector3(40,2.8,-7.3),PI)
	for x in [12.0,40.0,68.0,96.0]:
		KIT.fixture(self,Vector3(x,3,-102),0,"flush",1.3,15)
	# Authored estate boundary.
	for x in [-62.0,158.0]:
		A.box(self,Vector3(0.5,2.5,208),Vector3(x,1.25,-28),CHARCOAL,true)
	for z in [-132.0,76.0]:
		A.box(self,Vector3(220,2.5,0.5),Vector3(48,1.25,z),CHARCOAL,true)

func railing(length: float, at: Vector3, yaw: float = 0) -> void:
	var node = RAILING.instantiate()
	node.length = length
	node.position = at
	node.rotation.y = yaw
	add_child(node)

func build_balcony() -> void:
	A.box(self,Vector3(32,0.2,6),Vector3(0,6.3,-57),MARBLE,true)
	for x in [-13.0,13.0]:
		A.box(self,Vector3(6,0.2,20),Vector3(x,6.3,-44),MARBLE,true)
		railing(20,Vector3(signf(x)*10,6.4,-44),PI/2)
		railing(6,Vector3(x,6.4,-34))
		KIT.column(self,Vector3(x,0,-34),6.4)
	for x in [-6.6,6.6]:
		railing(6.8,Vector3(x,6.4,-54))
	var landing = rooms_by_id[&"upper_landing"]
	for x in [-13.0,13.0]:
		landing.add_volume(Vector3(x,0,13),Vector3(5.6,5.5,19.6))
	KIT.sign(self,"UPPER LANDING",Vector3(0,9.5,-59.5))

func build_service_guards() -> void:
	for x in [38.1,43.9]:
		railing(12,Vector3(x,0,-54),PI/2)
	railing(6,Vector3(41,0,-48))
	for x in [38.5,43.5]:
		railing(1,Vector3(x,0,-60))
	KIT.sign(self,"SERVICE / BASEMENT",Vector3(41,3.8,-61.5))

func dress_arrival() -> void:
	var entrance = rooms_by_id[&"entrance_hall"]
	for x in [-8.0,8.0]:
		KIT.column(self,Vector3(x,0,12.35),9.8)
	A.box(self,Vector3(20,0.3,0.5),Vector3(0,9.85,12.35),CHARCOAL)
	KIT.window(self,Vector3(0,7.8,12.36),0)
	for side in [-1,1]:
		for z in [-8.0,0.0,8.0]:
			KIT.column(entrance,Vector3(side*9.1,0,z),9.8)
			KIT.panel(entrance,Vector3(side*9.58,3.3,z+3),-side*PI/2,3,4,TEAL)
			KIT.window(entrance,Vector3(side*9.59,5.3,z),-side*PI/2)
			KIT.fixture(entrance,Vector3(side*8.8,3.8,z),-side*PI/2,"sconce",2.4,11,true)
	KIT.fixture(entrance,Vector3(0,8,0),0,"chandelier",3.5,17,true)
	KIT.fixture(entrance,Vector3(0,9.5,-8),0,"flush",2.5,13)
	var foyer = rooms_by_id[&"foyer_reception"]
	KIT.prop(foyer,"cabinet_medium_decorated",Vector3(-4.8,0,0),PI/2,WOOD)
	KIT.prop(foyer,"armchair",Vector3(4.2,0,1),-PI/2,CHARCOAL)
	for side in [-1,1]:
		KIT.panel(foyer,Vector3(side*5.6,2.5,0),-side*PI/2,4,3)
		KIT.fixture(foyer,Vector3(side*5.5,3.8,-2),-side*PI/2,"sconce",2.3,8,true)
	var hall = rooms_by_id[&"grand_stair_hall"]
	for side in [-1,1]:
		for z in [-12.0,-4.0,4.0,12.0]:
			KIT.column(hall,Vector3(side*15.1,0,z),13.5)
			KIT.panel(hall,Vector3(side*15.58,3.5,z+2),-side*PI/2,3.8,4,TEAL)
			KIT.fixture(hall,Vector3(side*15.2,4.5,z),-side*PI/2,"sconce",3.4,13)
	for z in [5.0,-8.0]:
		KIT.fixture(hall,Vector3(0,12,z),0,"chandelier",4.0,22,true)
	for x in [-10.0,10.0]:
		KIT.fixture(hall,Vector3(x,13.5,-12),0,"flush",2.3,15)

func dress_drawing() -> void:
	var room = rooms_by_id[&"drawing_room"]
	KIT.prop(room,"couch_pillows",Vector3(4.6,0,2),-PI/2,CHARCOAL,true,1.3)
	KIT.prop(room,"couch",Vector3(-4.6,0,2),PI/2,TEAL,true,1.3)
	KIT.prop(room,"armchair_pillows",Vector3(2.5,0,5),PI,CHARCOAL,true,1.2)
	KIT.prop(room,"armchair",Vector3(-2.5,0,5),PI,TEAL,true,1.2)
	KIT.prop(room,"table_low",Vector3(0,0,2),0,WOOD,true,1.5)
	KIT.prop(room,"rug_rectangle_B",Vector3(0,0.01,2),0,CHARCOAL,false,2)
	KIT.prop(room,"lamp_standing",Vector3(5.8,0,5.5),0,BRASS,false,1.2)
	for side in [-1,1]:
		for z in [-3.0,3.0]:
			KIT.panel(room,Vector3(side*7.58,2.5,z),-side*PI/2,3.8,3,WOOD)
			KIT.painting(room,Vector3(side*7.52,2.8,z),-side*PI/2,0 if side == 1 else 1)
			KIT.fixture(room,Vector3(side*7.4,4.1,z),-side*PI/2,"sconce",2.2,7,true)
	KIT.fixture(room,Vector3(0,3.6,2),0,"chandelier",2.4,11,true)
	KIT.coffer(room,Vector3(0,5.1,0),13,13)
	# Symmetric wall feature leaves the 4 metre arrival lane open.
	KIT.prop(room,"cabinet_medium_decorated",Vector3(6,0,-5),PI/2,WOOD)

func socket_definition(id: String) -> Dictionary:
	for socket in layout.sockets:
		if socket.socket_id == id:
			return socket
	return {}

func add_socket_marker(socket: Dictionary) -> void:
	var marker := Marker3D.new()
	marker.name = socket.socket_id
	marker.position = vector(socket.transform.position)
	marker.rotation.y = socket.transform.rotation_y
	marker.set_meta("socket_definition", socket)
	add_child(marker)

func populate_socket(socket: Dictionary, key: String) -> void:
	assert(run_store.compatible(socket,key,templates))
	var content := Node3D.new()
	content.name = "SocketContent"
	rooms_by_id[StringName(socket.room_id)].add_child(content)
	content.set_meta("template_id",key)
	var t: Dictionary = templates[key]
	rooms_by_id[StringName(socket.room_id)].display_name = t.name
	for prop in t.props:
		# Templates are explicitly authored outside all no-prop rectangles.
		var at := vector(prop.at)
		for rect in socket.prop_exclusion_zones:
			assert(not Rect2(rect[0]-1.5,rect[1]-1.5,rect[2]+3,rect[3]+3).has_point(Vector2(at.x,at.z)), "Prop in door clearance zone")
		KIT.prop(content,prop.asset,at,prop.yaw,WOOD)
	KIT.sign(content,t.name.to_upper(),Vector3(0,3.5,6),PI)
	socket_instances[socket.socket_id] = content
