extends Resource
## Shared immutable resources. Future variants must duplicate before changing parameters.
const NORMAL = {
	"frame_teal": preload("res://assets/neon-mansion/materials/frame_teal.tres"),
	"dark_wood_panel": preload("res://assets/neon-mansion/materials/dark_wood_panel.tres"),
	"frosted_glass": preload("res://assets/neon-mansion/materials/frosted_glass.tres"),
	"upholstery_teal": preload("res://assets/neon-mansion/materials/upholstery_teal.tres"),
	"upholstery_black": preload("res://assets/neon-mansion/materials/upholstery_black.tres"),
	"burgundy_carpet": preload("res://assets/neon-mansion/materials/burgundy_carpet.tres"),
	"lamp_warm": preload("res://assets/neon-mansion/materials/lamp_warm.tres"),
	"wall_teal": preload("res://assets/neon-mansion/materials/dark_teal.tres"),
	"wall_charcoal": preload("res://assets/neon-mansion/materials/charcoal.tres"),
	"black_door": preload("res://assets/neon-mansion/materials/near_black.tres"),
	"dark_tile": preload("res://assets/neon-mansion/materials/dark_tile.tres"),
	"dark_marble": preload("res://assets/neon-mansion/materials/dark_marble.tres"),
	"walnut": preload("res://assets/neon-mansion/materials/walnut.tres"),
	"brass": preload("res://assets/neon-mansion/materials/brass.tres"),
	"dark_metal": preload("res://assets/neon-mansion/materials/dark_metal.tres"),
	"smoked_glass": preload("res://assets/neon-mansion/materials/smoked_glass.tres"),
	"magenta_trim": preload("res://assets/neon-mansion/materials/magenta_trim.tres"),
	"cyan_trim": preload("res://assets/neon-mansion/materials/cyan_indicator.tres"),
	"acid_green": preload("res://assets/neon-mansion/materials/acid_green.tres")
}
const NIGHTMARE = {
	"corruption_base": preload("res://assets/neon-mansion/nightmare-fx/materials/corruption_base.tres"),
	"corruption_emissive": preload("res://assets/neon-mansion/nightmare-fx/materials/corruption_emissive.tres")
}
## Unshaded eight-colour comic palette for the flat Long Gallery. Never add a ninth.
const FLAT = {
	"wall": preload("res://assets/neon-mansion/materials/flat_wall.tres"),
	"ceiling": preload("res://assets/neon-mansion/materials/flat_ceiling.tres"),
	"floor": preload("res://assets/neon-mansion/materials/flat_floor.tres"),
	"ink": preload("res://assets/neon-mansion/materials/flat_ink.tres"),
	"trim_light": preload("res://assets/neon-mansion/materials/flat_trim_light.tres"),
	"trim_mid": preload("res://assets/neon-mansion/materials/flat_trim_mid.tres"),
	"accent_panel": preload("res://assets/neon-mansion/materials/flat_accent_panel.tres"),
	"accent_signal": preload("res://assets/neon-mansion/materials/flat_accent_signal.tres")
}
