extends Node3D
## Firefly family translated into dimensional profiles. No decorative collision.
const A = preload("res://assets/neon-mansion/scripts/architecture.gd")
const G = preload("res://assets/neon-mansion/scripts/visual_geometry.gd")
const TEAL = preload("res://assets/neon-mansion/materials/frame_teal.tres")
const BLACK = preload("res://assets/neon-mansion/materials/near_black.tres")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
const MAGENTA = preload("res://assets/neon-mansion/materials/magenta_trim.tres")
const CYAN = preload("res://assets/neon-mansion/materials/cyan_indicator.tres")
const GREEN = preload("res://assets/neon-mansion/materials/acid_green.tres")
const GLASS = preload("res://assets/neon-mansion/materials/smoked_glass.tres")
const FROST = preload("res://assets/neon-mansion/materials/frosted_glass.tres")

func frame(parent: Node3D, style: Resource) -> void:
	var w: float = style.leaf_width*style.leaf_count
	var h: float = style.leaf_height
	var grand: bool = style.leaf_count == 2
	var casing := 0.34 if grand else 0.24
	# Jamb reveal connects the two architraves, wholly outside the swinging leaf.
	for x in [-w/2-casing/2,w/2+casing/2]:
		A.box(parent,Vector3(casing,h+0.15,0.72),Vector3(x,(h+0.15)/2,0),TEAL)
	A.box(parent,Vector3(w+casing*2,0.18,0.72),Vector3(0,h+0.09,0),TEAL)
	A.box(parent,Vector3(w,0.018,0.68),Vector3(0,0.01,0),METAL)
	for side in [-1,1]:
		var z: float = side*0.40
		for x in [-w/2-casing/2,w/2+casing/2]:
			A.box(parent,Vector3(casing+0.14,h+0.27,0.12),Vector3(x,(h+0.27)/2,z),TEAL)
			A.box(parent,Vector3(0.055,h+0.24,0.06),Vector3(x+signf(x)*casing*0.42,(h+0.24)/2,z+side*0.085),METAL)
			A.box(parent,Vector3(0.035,h+0.10,0.035),Vector3(signf(x)*(w/2+0.045),(h+0.10)/2,z+side*0.08),MAGENTA)
			A.box(parent,Vector3(casing+0.22,0.28,0.23),Vector3(x,0.14,z),TEAL)
			A.box(parent,Vector3(casing+0.20,0.10,0.22),Vector3(x,h+0.22,z),METAL)
		A.box(parent,Vector3(w+casing*2+0.14,0.25,0.16),Vector3(0,h+0.16,z),TEAL)
		A.box(parent,Vector3(w+casing*2+0.3,0.07,0.24),Vector3(0,h+0.33,z),METAL)
		A.box(parent,Vector3(w+0.09,0.035,0.035),Vector3(0,h+0.10,z+side*0.10),MAGENTA)
		if style.pointed_profile:
			# Shallow applied crown keeps the approved rectangular aperture intact.
			G.outline(parent,G.arch(0,w+0.45,h+0.28,h+0.30,h+0.48),z+side*0.04,0.06,0.07,TEAL)
		var access := Vector3(w/2+casing+0.22,1.52,z+side*0.06)
		A.box(parent,Vector3(0.29,0.48,0.10),access,TEAL)
		A.box(parent,Vector3(0.22,0.39,0.05),access+Vector3(0,0,side*0.075),BLACK)
		A.box(parent,Vector3(0.15,0.10,0.025),access+Vector3(0,0.10,side*0.11),GREEN)
		for row in range(2):
			for col in range(3):
				A.box(parent,Vector3(0.024,0.024,0.02),access+Vector3((col-1)*0.055,-0.04-row*0.055,side*0.11),METAL)
		A.box(parent,Vector3(0.12,0.012,0.02),access+Vector3(0,-0.15,side*0.11),CYAN)
		# Black inset plaque supports the existing literal room-name label.
		var sign_y: float = h+(0.64 if style.pointed_profile else 0.49)
		A.box(parent,Vector3(minf(w+0.3,4.0),0.30,0.07),Vector3(0,sign_y,side*0.54),BLACK)

	G.batch(parent)

func leaf(parent: Node3D, style: Resource, direction: float, number: String) -> void:
	var w: float = style.leaf_width
	var h: float = style.leaf_height
	var cx: float = direction*w/2
	A.box(parent,Vector3(w,h,0.16),Vector3(cx,h/2,0),BLACK)
	for side in [-1,1]:
		var z: float = side*0.10
		var fancy: bool = style.family in ["luxury","grand_double","grand_anchor"]
		var outline := G.arch(cx,w*0.78,0.22,h*0.72,h-0.20) if style.pointed_profile and not style.privacy_insert else G.rectangle(Vector2(cx,h/2),Vector2(w*0.78,h-0.42))
		G.outline(parent,outline,z,0.075,0.04,TEAL)
		G.outline(parent,outline,z+side*0.026,0.021,0.018,MAGENTA if style.family != "standard" else METAL)
		# Narrow raised stiles and a lower field give real depth at oblique angles.
		for x in [cx-w*0.43,cx+w*0.43]:
			A.box(parent,Vector3(0.045,h-0.15,0.035),Vector3(x,h/2,z),METAL)
		if fancy:
			for offset in [-w*0.19,w*0.19]:
				G.outline(parent,G.arch(cx+offset,w*0.30,0.42,h*0.67,h-0.40),z+side*0.025,0.035,0.035,TEAL)
			A.box(parent,Vector3(w*0.70,0.06,0.04),Vector3(cx,0.34,z),BRASS)
		if style.family == "security_cyber":
			for y in [0.45,h*0.42,h*0.76]:
				A.box(parent,Vector3(w*0.76,0.022,0.025),Vector3(cx,y,z+side*0.02),METAL)
			for x in [cx-w*0.37,cx+w*0.37]:
				for y in [0.32,h-0.30]:
					G.cylinder(parent,Vector3(x,y,z+side*0.035),0.025,0.02,BRASS,Vector3(PI/2,0,0))
		var latch := Vector3(direction*w*0.85,1.27,z+side*0.035)
		G.cylinder(parent,latch,0.075,0.03,BRASS,Vector3(PI/2,0,0))
		G.cylinder(parent,latch+Vector3(0,-0.18,0),0.043,0.035,METAL,Vector3(PI/2,0,0))
		A.box(parent,Vector3(0.015,0.037,0.01),latch+Vector3(0,-0.18,side*0.025),BLACK)
		match style.hardware:
			"pull":
				A.box(parent,Vector3(0.105,0.50,0.025),latch,BRASS)
				for y in [-0.17,0.17]:
					G.cylinder(parent,latch+Vector3(0,y,side*0.07),0.034,0.12,BRASS,Vector3(PI/2,0,0))
				G.cylinder(parent,latch+Vector3(0,0,side*0.14),0.025,0.34,BRASS)
			"push_plate":
				A.box(parent,Vector3(w*0.66,0.24,0.055),Vector3(cx,1.27,z+side*0.03),BRASS)
				text(parent,"PUSH",Vector3(cx,1.27,z+side*0.065),side,0.0035)
			"keypad":
				A.box(parent,Vector3(0.21,0.32,0.06),latch+Vector3(-direction*0.16,0.10,side*0.035),METAL)
				for row in range(3):
					for col in range(3):
						A.box(parent,Vector3(0.025,0.025,0.012),latch+Vector3(-direction*0.16+(col-1)*0.043,0.03+row*0.05,side*0.075),CYAN if row==2 else BRASS)
			_:
				G.cylinder(parent,latch+Vector3(0,0,side*0.06),0.026,0.12,BRASS,Vector3(PI/2,0,0))
				A.box(parent,Vector3(0.23,0.042,0.045),latch+Vector3(-direction*0.085,0,side*0.12),BRASS)
		for y in [0.30,h*0.50,h-0.30]:
			G.cylinder(parent,Vector3(direction*0.025,y,side*0.11),0.035,0.16,METAL)
		if style.privacy_insert:
			if style.family == "kitchen_service":
				var at := Vector3(cx,h*0.72,z+side*0.045)
				G.cylinder(parent,at,0.26,0.035,FROST,Vector3(PI/2,0,0))
				G.ring(parent,at+Vector3(0,0,side*0.025),0.27,0.06,METAL)
			else:
				var size := Vector2(w*0.49,h*0.32)
				var at := Vector3(cx,h*0.70,z+side*0.025)
				A.box(parent,Vector3(size.x,size.y,0.025),at,FROST if style.family == "bedroom_bathroom" else GLASS)
				G.outline(parent,G.rectangle(Vector2(at.x,at.y),size),at.z+side*0.03,0.055,0.035,TEAL)
				if style.family == "exterior_garden":
					A.box(parent,Vector3(0.035,size.y,0.035),at+Vector3(0,0,side*0.04),BRASS)
		if style.cyan_spine:
			A.box(parent,Vector3(0.025,h*0.53,0.018),Vector3(cx,h*0.55,z+side*0.04),CYAN)
		var plaque_y: float = 0.65 if style.family == "kitchen_service" else (h*0.84 if not style.privacy_insert else h*0.43)
		var plaque := Vector3(cx,plaque_y,z+side*0.05)
		A.box(parent,Vector3(0.45,0.19,0.04),plaque,BRASS)
		A.box(parent,Vector3(0.39,0.14,0.015),plaque+Vector3(0,0,side*0.025),BLACK)
		text(parent,number if not number.is_empty() else style.room_symbol,plaque+Vector3(0,0,side*0.04),side,0.0035)

	G.batch(parent)

func text(parent: Node3D, value: String, at: Vector3, side: int, pixel_size: float) -> void:
	var label := Label3D.new()
	label.text = value
	label.double_sided = false
	label.position = at
	label.font_size = 28
	label.pixel_size = pixel_size
	label.modulate = Color(0.48,1,0.07)
	if side == -1:
		label.rotation.y = PI
	parent.add_child(label)
