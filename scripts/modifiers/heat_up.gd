extends ProjectileModifier

@export var damageMod: float = 15
@export var activated: bool = false

@export var characterStateResource: CharacterStatResource

var stack: int = 0

signal updateShotDamage

func apply_modifier(projectile: Node2D):
	print(characterStateResource.projectileShotDamage)
	characterStateResource.projectileShotDamage += damageMod
	SignalBus.statUpdate.emit(characterStateResource, "projectileShotDamage", characterStateResource.projectileShotDamage)
	print(characterStateResource.projectileShotDamage)

	#updateShotDamage.emit(damageMod)
	#SignalBus.statUpdate()
