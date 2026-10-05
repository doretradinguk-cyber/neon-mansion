extends RefCounted
## Collision-free low-poly profiles shared by doors, fixtures and architectural dress.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
static var cylinders: Dictionary = {}

static func cylinder(parent: Node3D, at: Vector3, radius: float, height: float, material: Material, rotation: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var key := Vector2(radius, height)
	if not cylinders.has(key):
		var mesh := CylinderMesh.new()
		mesh.top_radius = radius
		mesh.bottom_radius = radius
		mesh.height = height
		mesh.radial_segments = 12
		cylinders[key] = mesh
	var node := MeshInstance3D.new()
	node.mesh = cylinders[key]
	node.material_override = material
	parent.add_child(node)
	node.position = at
	node.rotation = rotation
	return node

static func beam(parent: Node3D, start: Vector3, end: Vector3, width: float, depth: float, material: Material) -> void:
	var delta := end - start
	var part := A.box(parent, Vector3(width, depth, delta.length()), (start+end)*0.5, material)
	part.basis = Basis.looking_at(delta.normalized(), Vector3.RIGHT if absf(delta.normalized().dot(Vector3.UP)) > 0.99 else Vector3.UP)

static func outline(parent: Node3D, points: PackedVector2Array, z: float, width: float, depth: float, material: Material) -> void:
	for i in range(points.size()-1):
		var a := points[i]
		var b := points[i+1]
		var part := A.box(parent, Vector3(a.distance_to(b)+width*0.15,width,depth), Vector3((a.x+b.x)*0.5,(a.y+b.y)*0.5,z), material)
		part.rotation.z = (b-a).angle()

static func arch(center: float, width: float, bottom: float, spring: float, peak: float) -> PackedVector2Array:
	var points := PackedVector2Array([Vector2(center-width/2,bottom),Vector2(center-width/2,spring)])
	for side in [-1.0,1.0]:
		for i in range(1,9):
			var t := i/8.0
			var a := Vector2(center-width/2,spring) if side < 0 else Vector2(center,peak)
			var b := Vector2(center-width/2,spring+(peak-spring)*0.62) if side < 0 else Vector2(center+width/2,spring+(peak-spring)*0.62)
			var c := Vector2(center,peak) if side < 0 else Vector2(center+width/2,spring)
			points.append(a*(1-t)*(1-t)+b*2*t*(1-t)+c*t*t)
	points.append(Vector2(center+width/2,bottom))
	points.append(points[0])
	return points

static func rectangle(center: Vector2, size: Vector2) -> PackedVector2Array:
	var a := center-size/2
	var b := center+size/2
	return PackedVector2Array([a,Vector2(a.x,b.y),b,Vector2(b.x,a.y),a])

static func ring(parent: Node3D, center: Vector3, radius: float, width: float, material: Material, horizontal: bool = false) -> void:
	for i in range(20):
		var a := i*TAU/20
		var b := (i+1)*TAU/20
		var p := Vector3(cos(a)*radius,sin(a)*radius,0)
		var q := Vector3(cos(b)*radius,sin(b)*radius,0)
		if horizontal:
			p = Vector3(p.x,0,p.y)
			q = Vector3(q.x,0,q.y)
		beam(parent,center+p,center+q,width,width,material)

static func batch(parent: Node3D) -> void:
	# Merge only direct decorative meshes. Collision bodies and child nodes are untouched.
	var groups: Dictionary = {}
	for child in parent.get_children():
		if child is MeshInstance3D and child.visible and child.mesh != null and child.get_child_count() == 0:
			var material: Material = child.material_override
			if material == null:
				continue
			if not groups.has(material):
				groups[material] = []
			groups[material].append(child)
	for material in groups:
		var parts: Array = groups[material]
		if parts.size() < 2:
			continue
		var surface := SurfaceTool.new()
		surface.begin(Mesh.PRIMITIVE_TRIANGLES)
		for part in parts:
			surface.append_from(part.mesh,0,part.transform)
		var merged := MeshInstance3D.new()
		merged.mesh = surface.commit()
		merged.material_override = material
		parent.add_child(merged)
		for part in parts:
			part.hide()
			part.queue_free()

static func batch_tree(parent: Node3D) -> void:
	for child in parent.get_children():
		if child is Node3D and not child is MeshInstance3D and not child is CollisionObject3D:
			batch_tree(child)
	batch(parent)
