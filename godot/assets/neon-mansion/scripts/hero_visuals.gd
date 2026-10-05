extends RefCounted
## Visual overlays only: no collision, map records, doors or room assignments change.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const G = preload("res://assets/neon-mansion/scripts/visual_geometry.gd")
const K = preload("res://assets/neon-mansion/scripts/interior_kit.gd")
const TEAL = preload("res://assets/neon-mansion/materials/frame_teal.tres")
const DARK = preload("res://assets/neon-mansion/materials/charcoal.tres")
const WOOD = preload("res://assets/neon-mansion/materials/dark_wood_panel.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const CARPET = preload("res://assets/neon-mansion/materials/burgundy_carpet.tres")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const MAGENTA = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
const FROST = preload("res://assets/neon-mansion/materials/frosted_glass.tres")

static func build(level: Node3D) -> void:
	for id in ["entrance_hall","foyer_reception","grand_stair_hall","long_gallery","drawing_room"]:
		var room: Node3D = level.rooms_by_id[StringName(id)]
		var root := Node3D.new()
		root.name = "ArchitecturalDress"
		room.add_child(root)
		var d: Dictionary = room.definition
		var w: float = d.size[0]
		var depth: float = d.size[1]
		var h: float = d.height
		for edge in ["north","south","east","west"]:
			var length: float = w if edge in ["north","south"] else depth
			var wall := Node3D.new()
			wall.position = room.edge_position(edge,0,0)
			wall.rotation.y = {"north":0.0,"south":PI,"east":-PI/2,"west":PI/2}[edge]
			root.add_child(wall)
			# Full crown remains above every authored opening; no doorway is dressed across.
			for band in [[h-0.14,0.21,0.28],[h-0.35,0.16,0.19],[h-0.49,0.07,0.12]]:
				A.box(wall,Vector3(length,band[1],band[2]),Vector3(0,band[0],0.20),DARK)
			A.box(wall,Vector3(length,0.025,0.03),Vector3(0,h-0.47,0.28),BRASS)
			var count := int(ceil(length/3.5))
			for i in range(count):
				var x: float = -length/2+(i+0.5)*length/count
				var along: float = -x if edge in ["south","east"] else x
				if not level.clear_edge(d,edge,along,length/count/2+0.18):
					continue
				K.panel(wall,Vector3(x,0.66,0.22),0,length/count-0.16,0.90,WOOD if id in ["drawing_room","foyer_reception"] else TEAL)
				A.box(wall,Vector3(length/count,0.12,0.15),Vector3(x,0.11,0.26),DARK)
				A.box(wall,Vector3(length/count,0.11,0.18),Vector3(x,1.22,0.27),DARK)
				if id in ["entrance_hall","grand_stair_hall"] and edge in ["north","south"]:
					K.panel(wall,Vector3(x,4.1,0.23),0,length/count-0.40,4.6,TEAL)
		# Non-emissive brass inlay defines a generous central floor field.
		for x in [-w/2+1.0,w/2-1.0]:
			A.box(root,Vector3(0.055,0.016,depth-2),Vector3(x,0.012,0),BRASS)
		for z in [-depth/2+1.0,depth/2-1.0]:
			A.box(root,Vector3(w-2,0.016,0.055),Vector3(0,0.012,z),BRASS)
		if id == "long_gallery":
			rug(root,Vector3(0,0.018,0),Vector2(w-4,2.7))
			for x in range(-48,49,8):
				for z in [-3.45,3.45]:
					A.box(root,Vector3(0.25,1.35,0.25),Vector3(x,h-1.1,z),DARK)
				A.box(root,Vector3(0.25,0.18,7),Vector3(x,h-0.48,0),DARK)
		elif id == "foyer_reception":
			rug(root,Vector3(0,0.018,0),Vector2(3.8,7.0))
			K.painting(root,Vector3(-5.42,3,0),PI/2,0)
		elif id == "entrance_hall":
			# Compass-like marble inlay; physical floor and route remain untouched.
			G.ring(root,Vector3(0,0.025,1),3.2,0.045,BRASS,true)
			for yaw in [0.0,PI/4,PI/2,PI*0.75]:
				var line := A.box(root,Vector3(4.2,0.014,0.045),Vector3(0,0.026,1),BRASS)
				line.rotation.y = yaw
			# Paired salon benches occupy the side bays, keeping the arrival axis open.
			for x in [-6.0, 6.0]:
				A.box(root,Vector3(2.6,0.22,0.78),Vector3(x,0.34,0.0),WOOD)
				A.box(root,Vector3(2.42,0.14,0.62),Vector3(x,0.52,0.0),CARPET)
				A.box(root,Vector3(2.48,0.62,0.16),Vector3(x,0.84,-0.28),WOOD)
				A.box(root,Vector3(2.28,0.38,0.08),Vector3(x,0.91,-0.18),CARPET)
				for end in [-1.0,1.0]:
					A.box(root,Vector3(0.16,0.58,0.82),Vector3(x+end*1.18,0.52,0.02),WOOD)
		elif id == "grand_stair_hall":
			rug(root,Vector3(0,0.018,11.0),Vector2(4.6,7.4))
			# Applied stained-glass triptych on the intact rear wall, above landing.
			for x in [-5.0,0.0,5.0]:
				stained_window(root,Vector3(x,10.0,-17.58))
		elif id == "drawing_room":
			rug(root,Vector3(0,0.055,2),Vector2(6.0,5.3))
			for x in [-4.4,4.4]:
				K.window(root,Vector3(x,2.9,7.55),PI)
			G.ring(root,Vector3(0,4.94,2),1.3,0.07,BRASS,true)
			# Small decorative objects sit on the existing table, collision-free.
			A.box(root,Vector3(0.6,0.05,0.40),Vector3(-0.45,0.73,2.1),WOOD)
			G.cylinder(root,Vector3(0.48,0.81,2.0),0.11,0.24,BRASS)
		G.batch_tree(root)
	# Six localized magenta pools, rather than new lights on every door.
	for at in [Vector3(-3.3,2,-11),Vector3(3.3,2,-23),Vector3(-3.6,1,-36),Vector3(3.6,5,-53),Vector3(18,2,-42),Vector3(24,2,-37)]:
		var fill := OmniLight3D.new()
		fill.name = "NeonSpill"
		fill.position = at
		fill.light_color = Color(1,0.025,0.23)
		fill.light_energy = 0.75
		fill.light_specular = 0.25
		fill.omni_range = 5.0
		fill.distance_fade_enabled = true
		fill.distance_fade_begin = 24
		fill.distance_fade_length = 8
		level.add_child(fill)

	# Low-specular stair fill keeps dark risers and balusters readable from the foyer.
	for x in [-5.0,5.0]:
		var fill := OmniLight3D.new()
		fill.name = "StairReadabilityFill"
		fill.position = Vector3(x,5.0,-45)
		fill.light_color = Color(0.40,0.60,0.72)
		fill.light_energy = 1.6
		fill.light_specular = 0.1
		fill.omni_range = 13.0
		fill.distance_fade_enabled = true
		fill.distance_fade_begin = 30
		fill.distance_fade_length = 12
		level.add_child(fill)

static func rug(parent: Node3D, at: Vector3, size: Vector2) -> void:
	A.box(parent,Vector3(size.x,0.012,size.y),at,CARPET)
	for x in [-size.x/2+0.09,size.x/2-0.09]:
		A.box(parent,Vector3(0.035,0.008,size.y-0.16),at+Vector3(x,0.012,0),BRASS)
	for z in [-size.y/2+0.09,size.y/2-0.09]:
		A.box(parent,Vector3(size.x-0.16,0.008,0.035),at+Vector3(0,0.012,z),BRASS)

static func stained_window(parent: Node3D, at: Vector3) -> void:
	var node := Node3D.new()
	node.position = at
	parent.add_child(node)
	K.panel(node,Vector3.ZERO,0,3.0,4.8,METAL)
	for x in [-0.8,0.0,0.8]:
		A.box(node,Vector3(0.62,2.5,0.025),Vector3(x,-0.2,0.15),FROST)
		G.outline(node,G.arch(x,0.69,-1.7,0.9,1.6),0.20,0.065,0.045,DARK)
		A.box(node,Vector3(0.035,2.4,0.02),Vector3(x,-0.2,0.19),MAGENTA if x==0 else CYAN)
	G.ring(node,Vector3(0,1.75,0.18),0.28,0.06,BRASS)
