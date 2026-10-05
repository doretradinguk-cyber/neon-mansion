extends Node3D
## Flat comic Grand Stair Hall. Unshaded palette fills only; pen lines come from the camera's outline pass.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const NAVY = preload("res://assets/neon-mansion/materials/flat_deep_navy.tres")
const PETROL = preload("res://assets/neon-mansion/materials/flat_petrol_teal.tres")
const MAGENTA = preload("res://assets/neon-mansion/materials/flat_neon_magenta.tres")
const AQUA = preload("res://assets/neon-mansion/materials/flat_electric_aqua.tres")
const INK = preload("res://assets/neon-mansion/materials/flat_abyss_black.tres")
# Metres, judged by eye from the benchmark. Depths run from the camera towards the far wall.
const AISLE := 2.63
const HALL := 4.4
const BACK := 1.0
const LENGTH := 23.0
const HEIGHT := 4.8
# Outer and far walls run up out of frame; only the aisle between the beams has a ceiling.
const TALL := 20.0
const STEPS := 18
const RISE := 0.19
const GOING := 0.29
const STAIR_START := 5.0
const PLATE_DEPTHS := [10.9, 13.0, 15.8, 19.1]
const SEAM_X := [-1.55, 0.0, 1.55]
# Beyond the outline pass's four lengthwise seams; drawn as thin ink strips in front of the stairs.
const WIDE_SEAM_X := [3.1]
const SEAM_DEPTHS := [3.7, 5.0, 7.2, 9.0, 11.4, 13.4, 15.8, 18.6, 20.8]
# Cornice bars as [inward offset, height].
const CORNICE := [[0.02, 4.42], [0.12, 4.58], [0.24, 4.74]]
const PANEL := Vector2(4.0, 2.95)
const PANEL_HEIGHT := 2.19

func _ready() -> void:
	var run := BACK + LENGTH
	var middle := (BACK - LENGTH) / 2.0
	var landing := STAIR_START + STEPS * GOING
	face(Vector2(HALL * 2, run), Vector3(0, 0, middle), Vector3.RIGHT, Vector3.FORWARD, PETROL)
	face(Vector2(AISLE * 2 + 0.6, run), Vector3(0, HEIGHT, middle), Vector3.RIGHT, Vector3.BACK, NAVY)
	face(Vector2(HALL * 2, TALL), Vector3(0, TALL / 2, -LENGTH), Vector3.RIGHT, Vector3.UP, NAVY)
	A.box(self, Vector3(AISLE * 2, 0.12, 0.04), Vector3(0, 0.06, -LENGTH + 0.02), MAGENTA)
	# Far-wall panel: a raised frame around a recessed field, so the pen line falls between them.
	face(PANEL, Vector3(0, PANEL_HEIGHT, -LENGTH + 0.004), Vector3.RIGHT, Vector3.UP, MAGENTA)
	for end in [-1.0, 1.0]:
		A.box(self, Vector3(0.12, PANEL.y, 0.06), Vector3(end * (PANEL.x / 2 - 0.06), PANEL_HEIGHT, -LENGTH + 0.03), MAGENTA)
		A.box(self, Vector3(PANEL.x, 0.12, 0.06), Vector3(0, PANEL_HEIGHT + end * (PANEL.y / 2 - 0.06), -LENGTH + 0.03), MAGENTA)
	for bar in CORNICE:
		A.box(self, Vector3(AISLE * 2, 0.06, 0.05), Vector3(0, bar[1], -LENGTH + bar[0] + 0.025), MAGENTA)
	for side in [-1.0, 1.0]:
		var along := Vector3(0, 0, side)
		face(Vector2(run, TALL), Vector3(side * HALL, TALL / 2, middle), along, Vector3.UP, NAVY)
		# Past the stair head the aisle is walled; the Upper Landing lies behind these walls.
		face(Vector2(LENGTH - landing, HEIGHT), Vector3(side * AISLE, HEIGHT / 2, -(landing + LENGTH) / 2), along, Vector3.UP, NAVY)
		A.box(self, Vector3(0.3, 0.4, run), Vector3(side * (AISLE + 0.15), HEIGHT - 0.2, middle), NAVY)
		for bar in CORNICE:
			A.box(self, Vector3(0.05, 0.06, run), Vector3(side * (AISLE - bar[0] - 0.025), bar[1], middle), MAGENTA)
		A.box(self, Vector3(0.04, 0.12, LENGTH - STAIR_START), Vector3(side * (AISLE - 0.02), 0.06, -(STAIR_START + LENGTH) / 2), MAGENTA)
		for depth: float in PLATE_DEPTHS:
			face(Vector2(0.45, 0.3), Vector3(side * (AISLE - 0.003), 1.6, -depth), along, Vector3.UP, AQUA)
		for x: float in WIDE_SEAM_X:
			A.box(self, Vector3(0.006, 0.002, BACK + STAIR_START), Vector3(side * x, 0.001, (BACK - STAIR_START) / 2), INK)
		stairs(side)
	var seams := PackedFloat32Array()
	for depth: float in SEAM_DEPTHS:
		seams.append(-depth)
	var outline: ShaderMaterial = $Camera3D/Outline.material_override
	outline.set_shader_parameter("gallery_from_world", global_transform.affine_inverse())
	outline.set_shader_parameter("seam_x", PackedFloat32Array(SEAM_X))
	outline.set_shader_parameter("seam_x_count", SEAM_X.size())
	outline.set_shader_parameter("seam_z", seams)
	outline.set_shader_parameter("seam_z_count", seams.size())

func face(size: Vector2, at: Vector3, across: Vector3, up: Vector3, material: Material) -> void:
	var part := MeshInstance3D.new()
	var mesh := QuadMesh.new()
	mesh.size = size
	part.mesh = mesh
	part.material_override = material
	part.transform = Transform3D(Basis(across, up, across.cross(up)), at)
	add_child(part)

func stairs(side: float) -> void:
	var width := HALL - AISLE
	var centre := side * (AISLE + width / 2)
	var rail := side * (AISLE + 0.06)
	for i in range(STEPS):
		var top := RISE * (i + 1)
		var front := -(STAIR_START + GOING * i)
		# Navy block with petrol riser and tread; the aisle-side end stays navy.
		A.box(self, Vector3(width, top, GOING), Vector3(centre, top / 2, front - GOING / 2), NAVY)
		face(Vector2(width, RISE), Vector3(centre, top - RISE / 2, front + 0.002), Vector3.RIGHT, Vector3.UP, PETROL)
		face(Vector2(width, GOING), Vector3(centre, top + 0.002, front - GOING / 2), Vector3.RIGHT, Vector3.FORWARD, PETROL)
		A.box(self, Vector3(width + 0.04, 0.035, 0.03), Vector3(centre - side * 0.02, top - 0.0175, front + 0.015), MAGENTA)
		A.box(self, Vector3(0.05, 0.9, 0.05), Vector3(rail, top + 0.45, front - GOING / 2), MAGENTA)
	var slope := atan2(RISE, GOING)
	var length := STEPS * Vector2(RISE, GOING).length()
	var mid_depth := -(STAIR_START + GOING * STEPS / 2.0)
	var mid_height := RISE * (STEPS + 1) / 2.0
	var handrail := A.box(self, Vector3(0.08, 0.07, length + 0.3), Vector3(rail, mid_height + 0.93, mid_depth), MAGENTA)
	handrail.rotation.x = slope
	var stringer := A.box(self, Vector3(0.03, 0.35, length), Vector3(side * (HALL - 0.015), mid_height + 0.2, mid_depth), MAGENTA)
	stringer.rotation.x = slope
	A.box(self, Vector3(0.14, 1.2, 0.14), Vector3(rail, 0.6, -(STAIR_START - 0.2)), MAGENTA)
	A.box(self, Vector3(0.2, 0.08, 0.2), Vector3(rail, 1.24, -(STAIR_START - 0.2)), NAVY)
