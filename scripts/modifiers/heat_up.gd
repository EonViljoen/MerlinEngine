extends ProjectileModifier

@export var damageMod: float = 15
@export var activated: bool = false

var stack: int = 0

signal updateShotDamage

func apply_modifier(projectile: Node2D):
	pass
	#projectile.get_node() *= speedMod
	#updateShotDamage.emit(damageMod)
	#SignalBus.statUpdate()
