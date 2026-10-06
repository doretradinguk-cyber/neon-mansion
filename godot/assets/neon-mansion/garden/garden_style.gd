extends Node3D
## Adds the benchmark garden without editing the foundation or player resources.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const ROLES := ["ink", "ground", "shadow", "stone", "teal", "leaf", "mint", "magenta"]
const HEX := ["000000", "08070D", "211C2D", "303C48", "28534E", "438B76", "8ACCB3", "B82D87"]
var materials: Dictionary = {}
var foundation: Node3D
var camera: Camera3D
var outline: MeshInstance3D
var environment: Environment

func _ready() -> void:
    call_deferred("build")

func build() -> void:
    foundation = get_parent().get_node("Foundation")
    camera = foundation.get_node("Player/Camera3D")
    for role in ROLES:
        materials[role] = load("res://assets/neon-mansion/garden/materials/" + role + ".tres")
    # Remove only old outdoor ornaments from this running instance, including their bodies.
    for child in foundation.get_children():
        if not child is Node3D:
            continue
        var p: Vector3 = child.position
        var old_column := absf(absf(p.x) - 7.0) < 0.1 and p.z >= 20.0 and p.z <= 66.0
        var old_bed := absf(absf(p.x) - 24.0) < 0.1 and p.z in [24.0, 42.0, 60.0]
        if old_column or old_bed:
            child.queue_free()
        elif child is MeshInstance3D and child.mesh is BoxMesh:
            var size: Vector3 = child.mesh.size
            if p.y < 0.1 and size.x > 50.0:
                child.material_override = materials.ground
    slab(Vector3(80, 0.04, 56), Vector3(0, 0.02, 40), "ground")
    # Keep the full central arrival route clear, from spawn to the existing front door.
    for side in [-1.0, 1.0]:
        for z in [21.0, 33.0, 45.0, 57.0]:
            bed(Vector3(side * 13.0, 0, z), Vector2(6, 8))
            hedge(Vector3(side * 13.0, 0.66, z + 1.4), 4.0)
            urn(Vector3(side * 13.0, 0.66, z - 2.3))
            tree(Vector3(side * 23.0, 0, z), 8.0)
        wall_run(side * 39.0, 12.0, 68.0)
    gate(Vector3(0, 0, 68.0))
    rear_garden()
    pool_garden()
    restyle_existing_exterior(foundation)
    install_camera_style()
    set_process(true)

func slab(size: Vector3, at: Vector3, role: String, solid: bool = false) -> MeshInstance3D:
    return A.box(self, size, at, materials[role], solid)

func face(size: Vector2, at: Vector3, across: Vector3, up: Vector3, role: String) -> void:
    var part := MeshInstance3D.new()
    var mesh := QuadMesh.new()
    mesh.size = size
    part.mesh = mesh
    part.material_override = materials[role]
    add_child(part)
    part.transform = Transform3D(Basis(across, up, across.cross(up)), at)

func bed(at: Vector3, size: Vector2) -> void:
    slab(Vector3(size.x, 0.6, size.y), at + Vector3(0, 0.3, 0), "shadow", true)
    # A single hard colour step on one side, never lighting or a gradient.
    face(Vector2(size.y, 0.6), at + Vector3(size.x / 2 + 0.001, 0.3, 0), Vector3.FORWARD, Vector3.UP, "teal")
    for side in [-1.0, 1.0]:
        slab(Vector3(0.16, 0.1, size.y), at + Vector3(side * size.x / 2, 0.61, 0), "leaf")
        slab(Vector3(size.x, 0.1, 0.16), at + Vector3(0, 0.61, side * size.y / 2), "leaf")
    slab(Vector3(size.x - 0.2, 0.02, size.y - 0.2), at + Vector3(0, 0.61, 0), "ground")

func hedge(at: Vector3, height: float) -> void:
    slab(Vector3(1.5, height, 1.5), at + Vector3(0, height / 2, 0), "shadow", true)
    face(Vector2(1.5, height), at + Vector3(0.751, height / 2, 0), Vector3.FORWARD, Vector3.UP, "teal")
    slab(Vector3(1.5, 0.05, 1.5), at + Vector3(0, height, 0), "leaf")

func cylinder(at: Vector3, bottom: float, top: float, height: float, role: String) -> void:
    var part := MeshInstance3D.new()
    var mesh := CylinderMesh.new()
    mesh.bottom_radius = bottom
    mesh.top_radius = top
    mesh.height = height
    mesh.radial_segments = 32
    part.mesh = mesh
    part.material_override = materials[role]
    add_child(part)
    part.position = at + Vector3(0, height / 2, 0)

func urn(at: Vector3) -> void:
    slab(Vector3(1.4, 0.14, 1.4), at + Vector3(0, 0.07, 0), "stone")
    cylinder(at + Vector3(0, 0.14, 0), 0.5, 0.25, 0.25, "teal")
    cylinder(at + Vector3(0, 0.39, 0), 0.23, 0.23, 0.2, "stone")
    cylinder(at + Vector3(0, 0.59, 0), 0.3, 0.8, 0.7, "teal")
    cylinder(at + Vector3(0, 1.29, 0), 0.84, 0.84, 0.09, "mint")
    cylinder(at + Vector3(0, 1.385, 0), 0.68, 0.68, 0.006, "ground")

func branch(from: Vector3, to: Vector3, width: float) -> void:
    var part := slab(Vector3(width, from.distance_to(to), width), (from + to) / 2.0, "stone")
    part.quaternion = Quaternion(Vector3.UP, (to - from).normalized())

func tree(at: Vector3, height: float) -> void:
    branch(at, at + Vector3(0.1, height, 0), 0.35)
    for level in range(4):
        for side in [-1.0, 1.0]:
            var start := at + Vector3(0, height * (0.3 + level * 0.15), 0)
            var end := start + Vector3(side * (1.8 - level * 0.2), 1.2, side * 0.45)
            branch(start, end, 0.1)
            branch(end, end + Vector3(side * 0.6, 0.8, 0.25), 0.06)
            branch(start.lerp(end, 0.6), end + Vector3(-side * 0.15, 1, -0.35), 0.055)

func wall_run(x: float, start: float, end: float) -> void:
    slab(Vector3(0.4, 2.8, end - start), Vector3(x, 1.4, (start + end) / 2), "shadow", true)
    slab(Vector3(0.5, 0.13, end - start), Vector3(x, 2.82, (start + end) / 2), "stone")
    for z in range(int(start), int(end) + 1, 7):
        slab(Vector3(0.8, 3.2, 0.8), Vector3(x, 1.6, z), "stone", true)
        slab(Vector3(0.95, 0.16, 0.95), Vector3(x, 3.22, z), "shadow")
        slab(Vector3(0.02, 2.85, 0.09), Vector3(x - signf(x) * 0.411, 1.6, z), "mint")

func gate(at: Vector3) -> void:
    # Open leaves frame the drive; arrival remains walkable.
    for side in [-1.0, 1.0]:
        slab(Vector3(1, 5.5, 1), at + Vector3(side * 6, 2.75, 0), "stone", true)
        slab(Vector3(1.3, 0.25, 1.3), at + Vector3(side * 6, 5.5, 0), "mint")
        for bar in range(7):
            slab(Vector3(0.075, 4.4, 0.075), at + Vector3(side * 6, 2.2, -bar * 0.48), "magenta")
        for y in [0.35, 4.1]:
            slab(Vector3(0.12, 0.12, 3), at + Vector3(side * 6, y, -1.5), "magenta")

func rear_garden() -> void:
    slab(Vector3(136, 0.04, 40), Vector3(56, 0.02, -106), "ground")
    for x in [0.0, 24.0, 48.0, 72.0, 96.0, 120.0]:
        for z in [-116.0, -96.0]:
            bed(Vector3(x, 0, z), Vector2(5, 5))
            hedge(Vector3(x, 0.66, z), 3.5)
    gazebo(Vector3(56, 0, -120))

func gazebo(at: Vector3) -> void:
    slab(Vector3(8, 0.16, 8), at + Vector3(0, 0.08, 0), "stone", true)
    for x in [-3.0, 3.0]:
        for z in [-3.0, 3.0]:
            slab(Vector3(0.24, 4.5, 0.24), at + Vector3(x, 2.4, z), "stone", true)
            slab(Vector3(0.04, 4.3, 0.03), at + Vector3(x, 2.4, z + 0.13), "mint")
    slab(Vector3(8, 0.25, 8), at + Vector3(0, 4.65, 0), "stone")
    var roof := MeshInstance3D.new()
    var mesh := CylinderMesh.new()
    mesh.radial_segments = 4
    mesh.bottom_radius = 5.7
    mesh.top_radius = 0
    mesh.height = 2.2
    roof.mesh = mesh
    roof.material_override = materials.shadow
    add_child(roof)
    roof.position = at + Vector3(0, 5.85, 0)
    roof.rotation.y = PI / 4
    cylinder(at + Vector3(0, 6.95, 0), 0.16, 0, 0.55, "magenta")

func pool_garden() -> void:
    slab(Vector3(16, 0.02, 16), Vector3(40, 0.025, -14), "stone")
    slab(Vector3(10, 0.02, 8), Vector3(40, 0.065, -13), "teal")
    for x in [33.5, 46.5]:
        for z in [-19.0, -15.0, -11.0, -7.0]:
            urn(Vector3(x, 0.05, z))

func install_camera_style() -> void:
    outline = MeshInstance3D.new()
    outline.name = "GardenOutline"
    var quad := QuadMesh.new()
    quad.size = Vector2(2, 2)
    outline.mesh = quad
    outline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    outline.extra_cull_margin = 16384
    var material := ShaderMaterial.new()
    material.shader = preload("res://assets/neon-mansion/garden/garden_outline.gdshader")
    var colours := PackedColorArray()
    for hex in HEX:
        colours.append(Color.html(hex))
    material.set_shader_parameter("palette", colours)
    material.set_shader_parameter("ink", Color.BLACK)
    outline.material_override = material
    camera.add_child(outline)
    environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color.html("211C2D")
    environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED

func _process(_delta: float) -> void:
    if not is_instance_valid(camera) or not is_instance_valid(outline):
        return
    var p := camera.global_position
    var front := p.x > -40 and p.x < 40 and p.z > 12 and p.z < 76
    var rear := p.x > -12 and p.x < 124 and p.z > -126 and p.z < -86
    var pool := p.x > 32 and p.x < 48 and p.z > -22 and p.z < -6
    var outside := front or rear or pool
    outline.visible = outside
    camera.environment = environment if outside else null

func restyle_existing_exterior(node: Node) -> void:
    if node is Node3D:
        var p: Vector3 = node.global_position
        var exterior := (p.z >= 11.7 and p.z <= 76) or (p.z <= -86 and p.z >= -132)
        exterior = exterior or (p.x >= 32 and p.x <= 48 and p.z >= -22 and p.z <= -6)
        if exterior and node is Light3D:
            node.visible = false
        if exterior and node is MeshInstance3D:
            if node.material_override:
                node.material_override = mapped_material(node.material_override)
            elif node.mesh:
                # Batched architecture keeps separate roles on each surface.
                for surface in range(node.mesh.get_surface_count()):
                    var old: Material = node.get_active_material(surface)
                    if old:
                        node.set_surface_override_material(surface, mapped_material(old))
    for child in node.get_children():
        restyle_existing_exterior(child)

func mapped_material(old: Material) -> Material:
    var source := old.resource_path.get_file().get_basename()
    var roles := {"dark_tile": "ground", "dark_marble": "stone", "dark_teal": "stone", "charcoal": "shadow", "dark_metal": "shadow", "walnut": "shadow", "garden_ground": "teal", "brass": "mint", "frame_teal": "magenta", "cyan_indicator": "mint", "acid_green": "mint", "lamp_warm": "mint", "frosted_glass": "ground", "smoked_glass": "ground", "near_black": "ground", "magenta_trim": "magenta"}
    return materials[roles[source]] if roles.has(source) else old

