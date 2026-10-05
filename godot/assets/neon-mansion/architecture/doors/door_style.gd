extends Resource
## Visual family and aperture dimensions; shared presets are never mutated at runtime.
@export var family: String = "standard"
@export var leaf_width: float = 1.92
@export var leaf_height: float = 2.78
@export_range(1, 2) var leaf_count: int = 1
@export var pointed_profile: bool = false
@export_enum("lever", "pull", "push_plate", "keypad") var hardware: String = "lever"
@export var privacy_insert: bool = false
@export var cyan_spine: bool = false
@export var room_symbol: String = ""
