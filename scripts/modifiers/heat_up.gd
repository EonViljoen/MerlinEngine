extends ProjectileModifier

@export var modDisplayName: String = "Heat Up"
@export var modName: String = "HeatUp"
@export var damageMod: float = 15
@export var activated: bool = false
@export var characterStateResource: CharacterStatResource

func apply_modifier():
	characterStateResource.projectileShotDamage += damageMod
	SignalBus.statUpdate.emit(characterStateResource, "projectileShotDamage", characterStateResource.projectileShotDamage)
