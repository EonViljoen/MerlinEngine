extends ProjectileModifier

@export var modDisplayName: String = "Sharpen"
@export var modName: String = "Sharpen"
@export var damageMod: float = 10
@export var criticalMod: float = 5
@export var projectileEdgesMod : float = -2
@export var activated: bool = false
@export var projectileModifierResource : ProjectileModifierResource

func apply_modifier():
	projectileModifierResource.damageMod += damageMod
	projectileModifierResource.criticalMod += criticalMod
	projectileModifierResource.edgeCountMod += projectileEdgesMod
	#SignalBus.stackProjectileModifier.emit(projectileModifierResource)
	
func unapply_modifier():
	projectileModifierResource.damageMod -= damageMod
	projectileModifierResource.criticalMod -= criticalMod
	projectileModifierResource.edgeCountMod -= projectileEdgesMod
	#SignalBus.unstackProjectileModifier.emit(projectileModifierResource)
