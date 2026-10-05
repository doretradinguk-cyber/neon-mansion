extends Node3D
## Reusable KayKit wrapper. Imported resources remain shared and untouched.
const PACK = "res://addons/kaykit_prototype_bits/Assets/gltf/"
@export var asset_name: String = "Primitive_Wall"
@export var dimensions: Vector3 = Vector3(4, 4, 0.3)
@export var surface: Material
@export var solid: bool = true

func _ready() -> void:
	build()

func build() -> void:
	var source = load(PACK + asset_name + ".gltf") as PackedScene
	assert(source != null, "Missing inspected KayKit model: " + asset_name)
	var visual = source.instantiate() as Node3D
	add_child(visual)
	var meshes: Array[MeshInstance3D] = []
	_collect(visual, meshes)
	var bounds := AABB()
	var first := true
	for part in meshes:
		var box: AABB = (visual.global_transform.affine_inverse() * part.global_transform) * part.get_aabb()
		bounds = box if first else bounds.merge(box)
		first = false
		if surface:
			part.material_override = surface
	assert(not first and bounds.size.x > 0 and bounds.size.y > 0 and bounds.size.z > 0)
	visual.scale = dimensions / bounds.size
	visual.position = -(bounds.position + bounds.size * 0.5) * visual.scale
	if solid:
		add_box_collision(self, dimensions)

static func _collect(node: Node, result: Array[MeshInstance3D]) -> void:
	if node is MeshInstance3D:
		result.append(node)
	for child in node.get_children():
		_collect(child, result)

static func add_box_collision(parent: Node3D, size: Vector3, at: Vector3 = Vector3.ZERO) -> StaticBody3D:
	var body := StaticBody3D.new()
	parent.add_child(body)
	body.position = at
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collision.shape = shape
	body.add_child(collision)
	return body

static func box(parent: Node3D, size: Vector3, at: Vector3, material: Material, collision: bool = false) -> MeshInstance3D:
	var part := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	part.mesh = mesh
	part.material_override = material
	parent.add_child(part)
	part.position = at
	if collision:
		add_box_collision(parent, size, at)
	return part
