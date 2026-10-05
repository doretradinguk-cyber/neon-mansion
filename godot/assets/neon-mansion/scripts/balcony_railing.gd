extends Node3D
## Open balusters with an invisible continuous guard collider.
const G = preload("res://assets/neon-mansion/scripts/visual_geometry.gd")
const Architecture = preload("res://assets/neon-mansion/scripts/architecture.gd")
const METAL = preload("res://assets/neon-mansion/materials/dark_metal.tres")
const BRASS = preload("res://assets/neon-mansion/materials/brass.tres")
@export var length: float = 5.8
@export var height: float = 1.1

func _ready() -> void:
	Architecture.add_box_collision(self, Vector3(length, height, 0.12), Vector3(0, height / 2, 0))
	for y in [0.12, height]:
		Architecture.box(self, Vector3(length, 0.07, 0.12), Vector3(0, y, 0), BRASS)
	var intervals := maxi(1, int(ceil(length / 0.65)))
	for i in range(intervals + 1):
		var x := -length / 2 + length * i / intervals
		Architecture.box(self, Vector3(0.065, height, 0.065), Vector3(x, height / 2, 0), METAL)
	# Applied collars and newel caps share the original continuous guard collider.
	for i in range(intervals+1):
		var x := -length/2+length*i/intervals
		for y in [0.25,height-0.22]:
			Architecture.box(self,Vector3(0.10,0.06,0.10),Vector3(x,y,0),BRASS)
		if i % 4 == 0 or i == intervals:
			Architecture.box(self,Vector3(0.16,height,0.16),Vector3(x,height/2,0),METAL)
			G.cylinder(self,Vector3(x,height+0.05,0),0.13,0.08,BRASS)
		elif i % 2 == 0:
			G.outline(self,PackedVector2Array([Vector2(x,0.36),Vector2(x-0.12,0.57),Vector2(x,0.78),Vector2(x+0.12,0.57),Vector2(x,0.36)]),0,0.023,0.023,BRASS)
	G.batch(self)
