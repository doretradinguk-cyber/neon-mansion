extends Node3D
## Flat comic Long Gallery. Unshaded palette fills only; pen lines come from the camera's outline pass.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const WALL = preload("res://assets/neon-mansion/materials/flat_wall.tres")
const CEILING = preload("res://assets/neon-mansion/materials/flat_ceiling.tres")
const FLOOR = preload("res://assets/neon-mansion/materials/flat_floor.tres")
const INK = preload("res://assets/neon-mansion/materials/flat_ink.tres")
const LIGHT = preload("res://assets/neon-mansion/materials/flat_trim_light.tres")
const MID = preload("res://assets/neon-mansion/materials/flat_trim_mid.tres")
const PANEL = preload("res://assets/neon-mansion/materials/flat_accent_panel.tres")
const SIGNAL = preload("res://assets/neon-mansion/materials/flat_accent_signal.tres")
# Metres, measured from the benchmark. Depths run from the camera towards the far wall.
const HALF_WIDTH := 2.0
const BACK := 1.0
const LENGTH := 38.4
const HEIGHT := 3.9
# Cove profile as [projection, height]; each crease reads as one cornice line.
const COVE := [[0.0, 3.41], [0.07, 3.47], [0.07, 3.60], [0.13, 3.63], [0.18, 3.90]]
const DOOR_DEPTHS := [6.73, 12.7, 19.9, 29.1]
# Blank square number plates as [depth, side]; the fourth door has none.
const PLATES := [[5.48, 0.32], [11.06, 0.40], [17.7, 0.50]]
const SEAM_X := [-1.12, 0.0, 1.12]
const SEAM_DEPTHS := [6.1, 8.4, 12.2, 15.3, 19.6, 23.6, 25.5, 29.1, 33.2]
const LEAF := Vector2(1.25, 2.16)
# Casing steps outward from the leaf as [width, projection].
const CASING := [[0.12, 0.04], [0.17, 0.07]]
# The benchmark draws the jamb further from the camera wider than the near one.
const FAR_JAMB := 2.0

func _ready() -> void:
	var run := BACK + LENGTH
	var middle := (BACK - LENGTH) / 2.0
	face(Vector2(HALF_WIDTH * 2, run), Vector3(0, 0, middle), Vector3.RIGHT, Vector3.FORWARD, FLOOR)
	face(Vector2(HALF_WIDTH * 2, run), Vector3(0, HEIGHT, middle), Vector3.RIGHT, Vector3.BACK, CEILING)
	# The far wall sits one shadow step below the side walls.
	face(Vector2(HALF_WIDTH * 2, HEIGHT), Vector3(0, HEIGHT / 2, -LENGTH), Vector3.RIGHT, Vector3.UP, CEILING)
	face(Vector2(2.79, 1.96), Vector3(0, 1.79, -LENGTH + 0.004), Vector3.RIGHT, Vector3.UP, PANEL)
	A.box(self, Vector3(HALF_WIDTH * 2, 0.15, 0.03), Vector3(0, 0.075, -LENGTH + 0.015), MID)
	A.box(self, Vector3(HALF_WIDTH * 2, 0.04, 0.05), Vector3(0, 0.17, -LENGTH + 0.025), MID)
	for i in range(COVE.size() - 1):
		var rise := Vector2(COVE[i + 1][0] - COVE[i][0], COVE[i + 1][1] - COVE[i][1])
		var out: float = (COVE[i][0] + COVE[i + 1][0]) / 2.0
		var height: float = (COVE[i][1] + COVE[i + 1][1]) / 2.0
		face(Vector2(HALF_WIDTH * 2, rise.length()), Vector3(0, height, -LENGTH + out), Vector3.RIGHT, Vector3(0, rise.y, rise.x).normalized(), CEILING)
		for side in [-1.0, 1.0]:
			face(Vector2(run, rise.length()), Vector3(side * (HALF_WIDTH - out), height, middle), Vector3(0, 0, side), Vector3(-side * rise.x, rise.y, 0).normalized(), WALL)
	var casing: float = CASING[0][0] + CASING[1][0]
	for side in [-1.0, 1.0]:
		face(Vector2(run, HEIGHT), Vector3(side * HALF_WIDTH, HEIGHT / 2, middle), Vector3(0, 0, side), Vector3.UP, WALL)
		var start := BACK
		for depth: float in DOOR_DEPTHS:
			door(side, -depth)
			skirting(side, start, -depth + LEAF.x / 2 + casing)
			start = -depth - LEAF.x / 2 - casing * FAR_JAMB
		skirting(side, start, -LENGTH)
		for plate in PLATES:
			face(Vector2(plate[1], plate[1]), Vector3(side * (HALF_WIDTH - 0.003), 1.27, -plate[0]), Vector3(0, 0, side), Vector3.UP, SIGNAL)
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

func skirting(side: float, from: float, to: float) -> void:
	var length := from - to
	var centre := (from + to) / 2.0
	A.box(self, Vector3(0.03, 0.15, length), Vector3(side * (HALF_WIDTH - 0.015), 0.075, centre), MID)
	A.box(self, Vector3(0.05, 0.04, length), Vector3(side * (HALF_WIDTH - 0.025), 0.17, centre), MID)

func door(side: float, z: float) -> void:
	var along := Vector3(0, 0, side)
	var wall := side * HALF_WIDTH
	face(LEAF, Vector3(wall - side * 0.003, LEAF.y / 2, z), along, Vector3.UP, LIGHT)
	face(Vector2(LEAF.x - 0.10, 1.86), Vector3(wall - side * 0.006, 1.15, z), along, Vector3.UP, INK)
	var near := LEAF.x / 2
	var far := LEAF.x / 2
	var top := LEAF.y
	for step in CASING:
		var width: float = step[0]
		var wide: float = width * FAR_JAMB
		var out: float = step[1]
		var body := wall - side * out / 2
		var front := wall - side * (out + 0.002)
		# Shadow-pink bodies with main-pink corridor-facing fronts: the shadow step is baked per face.
		for jamb in [[z + near + width / 2, width], [z - far - wide / 2, wide]]:
			A.box(self, Vector3(out, top + width, jamb[1]), Vector3(body, (top + width) / 2, jamb[0]), MID)
			face(Vector2(jamb[1], top + width), Vector3(front, (top + width) / 2, jamb[0]), along, Vector3.UP, LIGHT)
		A.box(self, Vector3(out, width, near + far), Vector3(body, top + width / 2, z + (near - far) / 2), MID)
		face(Vector2(near + far, width), Vector3(front, top + width / 2, z + (near - far) / 2), along, Vector3.UP, LIGHT)
		near += width
		far += wide
		top += width
