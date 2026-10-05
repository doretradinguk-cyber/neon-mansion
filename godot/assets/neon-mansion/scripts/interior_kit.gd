extends RefCounted
## Shared architectural grammar derived from reviewed pack 2, built as geometry.
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
	A.box(root, Vector3(width, height, 0.06), Vector3.ZERO, material)
	for x in [-width/2, width/2]:
		A.box(root, Vector3(0.06, height, 0.08), Vector3(x, 0, 0.05), BRASS)
	for y in [-height/2, height/2]:
		A.box(root, Vector3(width, 0.06, 0.08), Vector3(0, y, 0.05), BRASS)

static func column(parent: Node3D, at: Vector3, height: float) -> void:
	for data in [[Vector3(0.7, height, 0.5), Vector3(0,height/2,0)], [Vector3(1.1,0.3,0.8),Vector3(0,0.15,0)], [Vector3(1.1,0.35,0.8),Vector3(0,height-0.175,0)]]:
		A.box(parent, data[0], at+data[1], CHARCOAL)
	A.box(parent, Vector3(0.75,0.08,0.55), at+Vector3(0,height-0.4,0), BRASS)

static func coffer(parent: Node3D, center: Vector3, width: float, depth: float) -> void:
	for x in [-width/2, width/2]:
		A.box(parent, Vector3(0.2,0.18,depth), center+Vector3(x,0,0), CHARCOAL)
		A.box(parent, Vector3(0.035,0.02,depth-0.2), center+Vector3(x*0.96,-0.1,0), BRASS)
	for z in [-depth/2,depth/2]:
		A.box(parent, Vector3(width,0.18,0.2), center+Vector3(0,0,z), CHARCOAL)
		A.box(parent, Vector3(width-0.2,0.02,0.035), center+Vector3(0,-0.1,z*0.96), BRASS)

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
	panel(parent, at, yaw, 2.2, 3.2, GLASS)
	var bars := Node3D.new()
	bars.position = at
	bars.rotation.y = yaw
	parent.add_child(bars)
	A.box(bars, Vector3(0.10,3.2,0.10), Vector3(0,0,0.08), METAL)
	A.box(bars, Vector3(2.2,0.10,0.10), Vector3(0,0,0.08), METAL)

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

