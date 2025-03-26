extends ProjectileModifier

@export var speedMod: float = 1.5
@export var activated: bool = false
@onready var characterStateResource: CharacterStatResource

#signal updateShotSpeed

func apply_modifier(projectile: Node2D):
	projectile.baseShootSpeed *= speedMod
	SignalBus.statUpdate.emit(characterStateResource, "projectileShotSpeed", projectile.baseShootSpeed)
