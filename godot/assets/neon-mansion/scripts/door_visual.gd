extends Node3D
## Modelled from reviewed Firefly studies; all decoration is collision-free.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const TEAL = preload("res://assets/neon-mansion/materials/dark_teal.tres")
const BLACK = preload("res://assets/neon-mansion/materials/near_black.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const MAGENTA = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const GREEN = preload("res://assets/neon-mansion/materials/acid_green.tres")
const GLASS = preload("res://assets/neon-mansion/materials/smoked_glass.tres")

func frame(parent: Node3D, style: Resource) -> void:
	var w: float = style.leaf_width * style.leaf_count
	var h: float = style.leaf_height
	for side in [-1, 1]:
		var z: float = side * 0.35
		for x in [-w / 2 - 0.08, w / 2 + 0.08]:
			A.box(parent, Vector3(0.18, h + 0.12, 0.12), Vector3(x, (h + 0.12) / 2, z), TEAL)
			A.box(parent, Vector3(0.025, h + 0.09, 0.035), Vector3(x - signf(x) * 0.06, (h + 0.09) / 2, z + side * 0.075), MAGENTA)
		A.box(parent, Vector3(w + 0.34, 0.16, 0.12), Vector3(0, h + 0.08, z), TEAL)
		A.box(parent, Vector3(w + 0.22, 0.025, 0.035), Vector3(0, h + 0.10, z + side * 0.075), MAGENTA)
		if style.pointed_profile:
			line(parent, Vector2(-w * 0.48, h + 0.13), Vector2(0, h + 0.34), z + side * 0.07, 0.065, TEAL)
			line(parent, Vector2(0, h + 0.34), Vector2(w * 0.48, h + 0.13), z + side * 0.07, 0.065, TEAL)
		var access_at := Vector3(w / 2 + 0.22, h * 0.58, z + side * 0.08)
		A.box(parent, Vector3(0.22, 0.32, 0.08), access_at, METAL)
		A.box(parent, Vector3(0.055, 0.07, 0.025), access_at + Vector3(0, 0.06, side * 0.055), GREEN)
		A.box(parent, Vector3(0.11, 0.018, 0.025), access_at + Vector3(0, -0.06, side * 0.055), CYAN)

func leaf(parent: Node3D, style: Resource, direction: float, number: String) -> void:
	var w: float = style.leaf_width
	var h: float = style.leaf_height
	var center: float = direction * w / 2
	for side in [-1, 1]:
		var z: float = side * 0.135
		var lower := 0.25
		var shoulder: float = h - (0.6 if style.pointed_profile else 0.3)
		var peak: float = h - 0.25
		var points: Array[Vector2] = [
			Vector2(center - w * 0.34, lower), Vector2(center - w * 0.34, shoulder)]
		if style.pointed_profile:
			points.append(Vector2(center, peak))
		points.append(Vector2(center + w * 0.34, shoulder))
		points.append(Vector2(center + w * 0.34, lower))
		points.append(points[0])
		for i in range(points.size() - 1):
			line(parent, points[i], points[i + 1], z, 0.035, METAL)
		if style.pointed_profile:
			for i in range(1, 3):
				line(parent, points[i], points[i + 1], z + side * 0.02, 0.012, MAGENTA)
		var latch_x: float = direction * w * 0.86
		var latch := Vector3(latch_x, 1.3, z + side * 0.03)
		A.box(parent, Vector3(0.11, 0.26, 0.045), latch, BRASS)
		match style.hardware:
			"pull":
				A.box(parent, Vector3(0.045, 0.3, 0.10), latch + Vector3(0, 0, side * 0.07), BRASS)
			"push_plate":
				A.box(parent, Vector3(w * 0.62, 0.22, 0.06), Vector3(center, 1.3, z), METAL)
				text(parent, "SERVICE", Vector3(center, 1.3, z + side * 0.05), side, 0.004)
			"keypad":
				A.box(parent, Vector3(0.24, 0.34, 0.055), latch + Vector3(-direction * 0.12, 0.1, side * 0.055), METAL)
				for row in range(3):
					for col in range(3):
						A.box(parent, Vector3(0.022, 0.024, 0.025), latch + Vector3(-direction * 0.12 + (col - 1) * 0.05, 0.06 + row * 0.05, side * 0.105), CYAN if row == 2 else BRASS)
			_:
				A.box(parent, Vector3(0.19, 0.04, 0.09), latch + Vector3(-direction * 0.07, 0, side * 0.06), BRASS)
		if style.privacy_insert:
			var insert_at := Vector3(center, h * 0.7, z)
			A.box(parent, Vector3(w * 0.47, h * 0.24, 0.02), insert_at, METAL)
			A.box(parent, Vector3(w * 0.44, h * 0.21, 0.025), insert_at + Vector3(0, 0, side * 0.02), GLASS)
			A.box(parent, Vector3(w * 0.40, 0.015, 0.02), insert_at + Vector3(0, h * 0.10, side * 0.04), CYAN)
		if style.cyan_spine:
			A.box(parent, Vector3(0.025, h * 0.60, 0.025), Vector3(center, h * 0.56, z + side * 0.02), CYAN)
		var plaque_text: String = number if not number.is_empty() else style.room_symbol
		if not plaque_text.is_empty():
			var plaque_at := Vector3(center, h * 0.80 if not style.privacy_insert else h * 0.47, z + side * 0.065)
			A.box(parent, Vector3(w * 0.32, 0.18, 0.035), plaque_at, BLACK)
			text(parent, plaque_text, plaque_at + Vector3(0, 0, side * 0.03), side, 0.005)

func line(parent: Node3D, start: Vector2, end: Vector2, z: float, thickness: float, material: Material) -> void:
	var delta := end - start
	var part := A.box(parent, Vector3(delta.length(), thickness, 0.025), Vector3((start.x + end.x) / 2, (start.y + end.y) / 2, z), material)
	part.rotation.z = atan2(delta.y, delta.x)

func text(parent: Node3D, value: String, at: Vector3, side: int, pixel_size: float) -> void:
	var label := Label3D.new()
	label.text = value
	label.double_sided = false
	label.position = at
	label.font_size = 28
	label.pixel_size = pixel_size
	label.modulate = Color(0.55, 1, 0.01)
	if side == -1:
		label.rotation.y = PI
	parent.add_child(label)
