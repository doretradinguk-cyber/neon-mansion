extends Node3D
## Walkable twin-stair hall from the corrected benchmark; shared sources stay untouched.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const ROLES := ["ink","deep","wall","shadow","floor","pink","panel","mint"]
const HEX := ["000000","08070D","192F39","14232B","241B2D","AC3A68","690C41","60BEA0"]
var materials: Dictionary = {}
var camera: Camera3D
var outline: MeshInstance3D
var environment: Environment
var screen: MeshInstance3D
var foundation: Node3D

func _ready() -> void:
    call_deferred("build")

func build() -> void:
    foundation = get_parent().get_node("Foundation")
    var room: Node3D = foundation.rooms_by_id[&"grand_stair_hall"]
    position = room.position
    camera = foundation.get_node("Player/Camera3D")
    for role in ROLES:
        materials[role] = load("res://assets/neon-mansion/stair_hall/materials/" + role + ".tres")
    for child in room.get_children():
        if not child is Area3D:
            room.remove_child(child)
            child.queue_free()
    room.floor_material = materials.floor
    room.wall_material = materials.wall
    room.lower_wall_material = materials.wall
    room.build_floor([[-16,-18,32,36]],-0.075,materials.floor)
    for edge in ["north","south","east","west"]:
        room.build_edge(edge)
    room.build_floor([[-16,-18,32,36]],14.1,materials.shadow)
    remap_materials(room)
    # Remove the original central stairs and balcony that occupied the new twin flights.
    for child in foundation.get_children():
        if not child is Node3D:
            continue
        var p: Vector3 = child.position
        var balcony := absf(p.x) <= 16 and p.z >= -60 and p.z <= -34 and p.y >= 6.2 and p.y <= 10
        var columns := absf(absf(p.x)-13) < 0.1 and absf(p.z+34) < 0.1
        if child.name == "GrandStair" or balcony or columns:
            foundation.remove_child(child)
            child.queue_free()
    # Central canopy and dark creases reproduce the reference without lighting effects.
    slab(Vector3(8,0.16,36),Vector3(0,9.4,0),"wall")
    for side in [-1.0,1.0]:
        for y in [8.95,9.16,9.35]:
            slab(Vector3(0.1,0.07,36),Vector3(side*3.94,y,0),"shadow")
        slab(Vector3(0.05,0.12,36),Vector3(side*3.95,0.08,0),"pink")
        flight(side)
        # The upper landing crosses through these openings above the lower aisle walls.
        slab(Vector3(0.12,6.4,6),Vector3(side*4,3.2,-15),"wall",true)
        for z in [-17.0,-13.0]:
            slab(Vector3(0.12,3,2),Vector3(side*4,7.9,z),"wall",true)
        slab(Vector3(0.12,0.6,2),Vector3(side*4,9.1,-15),"wall",true)
        for z in [-2.0,-5.5,-9.0,-12.5]:
            slab(Vector3(0.035,0.3,0.32),Vector3(side*3.97,1.7,z),"mint")
    slab(Vector3(32,0.2,6),Vector3(0,6.3,-15),"floor",true)
    for side in [-1.0,1.0]:
        # Back landing rail leaves the existing upper-landing doorway clear.
        for x in [0.0,1.0,2.0,3.0,10.0,11.0,12.0,13.0,14.0,15.0]:
            slab(Vector3(0.08,1.1,0.08),Vector3(side*x,6.95,-12),"wall",true)
        slab(Vector3(3.5,0.1,0.12),Vector3(side*1.75,7.5,-12),"wall",true)
        slab(Vector3(6,0.1,0.12),Vector3(side*13,7.5,-12),"wall",true)
    screen_panel()
    install_camera_style()
    for door in foundation.doors_by_id.values():
        var local: Vector3 = to_local(door.global_position)
        if absf(local.x) <= 16.1 and absf(local.z) <= 18.5:
            remap_materials(door)

func slab(size: Vector3, at: Vector3, role: String, solid: bool = false) -> MeshInstance3D:
    return A.box(self,size,at,materials[role],solid)

func flight(side: float) -> void:
    const COUNT := 24
    const RUN := 18.0
    const RISE := 6.4
    const START := 6.0
    var x := side*6.5
    for i in range(COUNT):
        var top := (i+1)*RISE/COUNT
        var z := START-(i+0.5)*RUN/COUNT
        slab(Vector3(5,top,RUN/COUNT),Vector3(x,top/2,z),"shadow")
        slab(Vector3(5,0.02,RUN/COUNT),Vector3(x,top+0.01,z),"floor")
        slab(Vector3(5,RISE/COUNT,0.015),Vector3(x,top-RISE/COUNT/2,z+RUN/COUNT/2+0.012),"floor")
        slab(Vector3(5,0.045,0.045),Vector3(x,top+0.025,z+RUN/COUNT/2+0.035),"pink")
        slab(Vector3(0.1,1.1,0.1),Vector3(side*3.94,top+0.55,z+RUN/COUNT/2),"wall",true)
        slab(Vector3(0.12,0.04,RUN/COUNT),Vector3(side*3.94,top+0.06,z),"pink")
    var slope := atan2(RISE,RUN)
    var rail := slab(Vector3(0.16,0.12,sqrt(RUN*RUN+RISE*RISE)),Vector3(side*3.94,RISE/2+1.12,START-RUN/2),"wall")
    rail.rotation.x = slope
    var body := A.add_box_collision(self,Vector3(0.16,0.12,sqrt(RUN*RUN+RISE*RISE)),rail.position)
    body.rotation.x = slope
    # Continuous ramp collision makes the visually stepped flight smooth to walk.
    var stairs := StaticBody3D.new()
    add_child(stairs)
    var collision := CollisionShape3D.new()
    var wedge := ConvexPolygonShape3D.new()
    wedge.points = PackedVector3Array([Vector3(x-2.5,0,START),Vector3(x+2.5,0,START),Vector3(x-2.5,0,START-RUN),Vector3(x+2.5,0,START-RUN),Vector3(x-2.5,RISE,START-RUN),Vector3(x+2.5,RISE,START-RUN)])
    collision.shape = wedge
    stairs.add_child(collision)

func remap_materials(node: Node) -> void:
    if node is Light3D:
        node.visible = false
    if node is Label3D:
        node.visible = false
    if node is MeshInstance3D and node.material_override:
        var source: String = node.material_override.resource_path.get_file().get_basename()
        var roles := {"dark_teal":"wall","charcoal":"shadow","dark_marble":"floor","dark_tile":"floor","dark_metal":"wall","brass":"wall","frame_teal":"wall","magenta_trim":"pink","near_black":"deep","cyan_indicator":"mint","acid_green":"mint","burgundy_carpet":"floor"}
        if roles.has(source):
            node.material_override = materials[roles[source]]
    for child in node.get_children():
        remap_materials(child)

func screen_panel() -> void:
    slab(Vector3(6.2,5.2,0.12),Vector3(0,3.3,-17.6),"panel")
    for side in [-1.0,1.0]:
        slab(Vector3(0.12,5.2,0.12),Vector3(side*3.1,3.3,-17.51),"pink")
        slab(Vector3(6.2,0.12,0.12),Vector3(0,3.3+side*2.6,-17.51),"pink")
    # Full opaque black plate: neither the stills nor crossfades can expose the pink panel.
    slab(Vector3(5.8,4.8,0.08),Vector3(0,3.3,-17.43),"ink")
    screen = MeshInstance3D.new()
    screen.name = "Screen"
    var quad := QuadMesh.new()
    quad.size = Vector2(4.7,4.7)
    screen.mesh = quad
    screen.position = Vector3(0,3.3,-17.37)
    screen.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    var material := ShaderMaterial.new()
    material.shader = preload("res://assets/neon-mansion/stair_hall/screen.gdshader")
    material.render_priority = 2
    screen.material_override = material
    screen.set_script(preload("res://assets/neon-mansion/stair_hall/screen_animation.gd"))
    var frames: Array[Texture2D] = []
    for i in range(4):
        var image := Image.load_from_file(ProjectSettings.globalize_path("res://assets/neon-mansion/stair_hall/textures/screen-frame-%02d.png" % (i+1)))
        frames.append(ImageTexture.create_from_image(image))
    screen.frames = frames
    material.set_shader_parameter("frame_a",frames[0])
    material.set_shader_parameter("frame_b",frames[1])
    add_child(screen)

func install_camera_style() -> void:
    outline = MeshInstance3D.new()
    outline.name = "StairHallOutline"
    var quad := QuadMesh.new()
    quad.size = Vector2(2,2)
    outline.mesh = quad
    outline.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
    outline.extra_cull_margin = 16384
    var material := ShaderMaterial.new()
    material.shader = preload("res://assets/neon-mansion/stair_hall/stair_outline.gdshader")
    var colours := PackedColorArray()
    for hex in HEX:
        colours.append(Color.html(hex))
    material.set_shader_parameter("palette",colours)
    material.set_shader_parameter("ink",Color.BLACK)
    material.set_shader_parameter("gallery_from_world",global_transform.affine_inverse())
    outline.material_override = material
    camera.add_child(outline)
    environment = Environment.new()
    environment.background_mode = Environment.BG_COLOR
    environment.background_color = Color.html("14232B")
    environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_DISABLED

func _process(_delta: float) -> void:
    if not is_instance_valid(outline):
        return
    var p := to_local(camera.global_position)
    var inside := absf(p.x)<16 and absf(p.z)<18 and p.y<14
    outline.visible = inside
    if inside:
        camera.environment = environment





