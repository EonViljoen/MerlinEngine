extends ProjectileModifier

@export var modDisplayName: String = "Heat Up"
@export var modName: String = "HeatUp"
@export var colorMod: Color = Color.ORANGE_RED
@export var damageMod: float = 15
@export var temperatureMod: float = 10.0
@export var activated: bool = false
@export var projectileModifierResource : ProjectileModifierResource
@export var characterStateResource: CharacterStatResource

func apply_modifier():
	projectileModifierResource.damageMod += damageMod
	#projectileModifierResource.colorMod *= colorMod
	projectileModifierResource.temperatureMod += temperatureMod
	
func unapply_modifier():
	projectileModifierResource.damageMod -= damageMod
	projectileModifierResource.temperatureMod -= temperatureMod
