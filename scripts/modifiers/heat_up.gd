extends ProjectileModifier

@export var modDisplayName: String = "Heat Up"
@export var modName: String = "HeatUp"
@export var damageMod: float = 15
@export var activated: bool = false
@export var projectileModifierResource : ProjectileModifierResource
@export var characterStateResource: CharacterStatResource

func apply_modifier():
	projectileModifierResource.damageMod += damageMod
func unapply_modifier():
	projectileModifierResource.damageMod -= damageMod
