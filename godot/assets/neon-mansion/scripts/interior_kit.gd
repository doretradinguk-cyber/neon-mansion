extends RefCounted
## Shared architectural grammar derived from reviewed pack 2, built as geometry.
const G = preload("res://assets/neon-mansion/scripts/visual_geometry.gd")
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const TEAL = preload("res://assets/neon-mansion/materials/dark_teal.tres")
const CHARCOAL = preload("res://assets/neon-mansion/materials/charcoal.tres")
const WOOD = preload("res://assets/neon-mansion/materials/walnut.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const GLASS = preload("res://assets/neon-mansion/materials/smoked_glass.tres")
const FIXTURE = preload("res://assets/neon-mansion/architecture/light_fixture.tscn")
const ART = preload("res://assets/neon-mansion/scripts/firefly_artwork.gd")
const VENDOR = "res://addons/kaykit_furniture_bits/Assets/gltf/"

static func fixture(parent: Node3D, at: Vector3, yaw: float = 0, kind: String = "sconce", energy: float = 1.8, reach: float = 7, warm: bool = false) -> Node3D:
	var f = FIXTURE.instantiate()
	f.position = at
	f.rotation.y = yaw
	f.kind = kind
	f.energy = energy
	f.range_metres = reach
	f.warm = warm
	parent.add_child(f)
	return f

static func panel(parent: Node3D, at: Vector3, yaw: float, width: float = 3.0, height: float = 2.2, material: Material = WOOD) -> void:
	var root := Node3D.new()
	root.position = at
	root.rotation.y = yaw
	parent.add_child(root)
	A.box(root,Vector3(width,height,0.07),Vector3.ZERO,CHARCOAL)
	A.box(root,Vector3(width-0.24,height-0.24,0.045),Vector3(0,0,0.04),material)
	G.outline(root,G.rectangle(Vector2.ZERO,Vector2(width,height)),0.065,0.10,0.10,CHARCOAL)
	G.outline(root,G.rectangle(Vector2.ZERO,Vector2(width-0.18,height-0.18)),0.11,0.035,0.045,BRASS)
	G.outline(root,G.rectangle(Vector2.ZERO,Vector2(width-0.33,height-0.33)),0.085,0.045,0.04,CHARCOAL)

static func column(parent: Node3D, at: Vector3, height: float) -> void:
	A.box(parent,Vector3(0.7,height,0.5),at+Vector3(0,height/2,0),CHARCOAL)
	for y in [0.12,0.30,height-0.34,height-0.12]:
		A.box(parent,Vector3(1.04,0.13,0.78),at+Vector3(0,y,0),CHARCOAL)
	for x in [-0.22,0.0,0.22]:
		A.box(parent,Vector3(0.035,height-1.1,0.04),at+Vector3(x,height/2,0.27),METAL)
	A.box(parent,Vector3(0.79,0.045,0.61),at+Vector3(0,height-0.44,0),BRASS)

static func coffer(parent: Node3D, center: Vector3, width: float, depth: float) -> void:
	# Nested stepped profiles create visible shadow lines below the existing ceiling.
	for layer in range(3):
		var inset := layer*0.16
		var w := width-0.08-inset*2
		var d := depth-0.08-inset*2
		var y := -0.06-layer*0.07
		for x in [-w/2,w/2]:
			A.box(parent,Vector3(0.13,0.11,d),center+Vector3(x,y,0),CHARCOAL)
		for z in [-d/2,d/2]:
			A.box(parent,Vector3(w,0.11,0.13),center+Vector3(0,y,z),CHARCOAL)
	for x in [-width/2+0.39,width/2-0.39]:
		A.box(parent,Vector3(0.023,0.025,depth-0.78),center+Vector3(x,-0.23,0),BRASS)
	for z in [-depth/2+0.39,depth/2-0.39]:
		A.box(parent,Vector3(width-0.78,0.025,0.023),center+Vector3(0,-0.23,z),BRASS)
static func prop(parent: Node3D, asset: String, at: Vector3, yaw: float = 0, material: Material = WOOD, solid: bool = true, scale_value: float = 1) -> Node3D:
	var source := load(VENDOR + asset + ".gltf") as PackedScene
	assert(source != null, "Inspected vendor asset missing: " + asset)
	var p := source.instantiate() as Node3D
	p.position = at
	p.rotation.y = yaw
	p.scale = Vector3.ONE * scale_value
	parent.add_child(p)
	var meshes: Array[MeshInstance3D] = []
	A._collect(p, meshes)
	for mesh in meshes:
		mesh.material_override = material
		if solid:
			mesh.create_trimesh_collision()
	p.add_to_group("mansion_props")
	return p

static func painting(parent: Node3D, at: Vector3, yaw: float, index: int = 0) -> void:
	var frame := prop(parent, "pictureframe_large_A", at, yaw, BRASS, false, 1.4)
	var art := Node3D.new()
	art.set_script(ART)
	art.set("artwork_index", index)
	art.position.z = 0.215
	frame.add_child(art)

static func window(parent: Node3D, at: Vector3, yaw: float) -> void:
	panel(parent,at,yaw,2.2,3.2,GLASS)
	var bars := Node3D.new()
	bars.position = at
	bars.rotation.y = yaw
	parent.add_child(bars)
	for x in [-0.52,0.52]:
		G.outline(bars,G.arch(x,0.86,-1.42,0.65,1.40),0.16,0.055,0.07,METAL)
		A.box(bars,Vector3(0.66,1.7,0.016),Vector3(x,-0.2,0.10),GLASS)
	A.box(bars,Vector3(0.10,3.2,0.10),Vector3(0,0,0.17),METAL)
	A.box(bars,Vector3(2.2,0.08,0.10),Vector3(0,-0.45,0.17),METAL)
	A.box(bars,Vector3(2.5,0.12,0.35),Vector3(0,-1.65,0.12),CHARCOAL)
static func sign(parent: Node3D, value: String, at: Vector3, yaw: float = 0) -> Label3D:
	var label := Label3D.new()
	label.text = value
	label.position = at
	label.rotation.y = yaw
	label.double_sided = false
	label.modulate = Color(0.55,1,0.04)
	label.font_size = 38
	label.pixel_size = 0.008
	parent.add_child(label)
	label.add_to_group("nightmare_sign_hooks")
	return label

