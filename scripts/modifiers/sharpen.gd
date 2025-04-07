extends ProjectileModifier

@export var modDisplayName: String = "Sharpen"
@export var modName: String = "Sharpen"
@export var damageMod: float = 10
@export var criticalMod: float= 5
@export var activated: bool = false
@export var characterStateResource: CharacterStatResource

func apply_modifier():
	characterStateResource.projectileShotDamage += damageMod
	SignalBus.statUpdate.emit(characterStateResource, "projectileShotDamage", characterStateResource.projectileShotDamage)
