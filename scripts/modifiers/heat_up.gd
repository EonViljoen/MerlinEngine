extends ProjectileModifier

@export var modDisplayName: String = "Heat Up"
@export var modName: String = "HeatUp"
@export var damageMod: float = 15
@export var activated: bool = false

@export var characterStateResource: CharacterStatResource

var stack: int = 0

signal updateShotDamage

func apply_modifier(projectile: Node2D):
	characterStateResource.projectileShotDamage += damageMod
	SignalBus.statUpdate.emit(characterStateResource, "projectileShotDamage", characterStateResource.projectileShotDamage)
