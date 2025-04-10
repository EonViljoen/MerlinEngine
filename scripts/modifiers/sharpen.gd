extends ProjectileModifier

@export var modDisplayName: String = "Sharpen"
@export var modName: String = "Sharpen"
@export var colorMod: Color = Color.LIGHT_GRAY
@export var damageMod: float = 10
@export var criticalChanceMod: float = 0.10
@export var projectileEdgesMod : float = -1.5
@export var activated: bool = false
@export var projectileModifierResource : ProjectileModifierResource

func apply_modifier():
	projectileModifierResource.damageMod += damageMod
	projectileModifierResource.criticalChanceMod += criticalChanceMod
	projectileModifierResource.edgeCountMod += projectileEdgesMod
	projectileModifierResource.colorMod *= colorMod
	
func unapply_modifier():
	projectileModifierResource.damageMod -= damageMod
	projectileModifierResource.criticalChanceMod -= criticalChanceMod
	projectileModifierResource.edgeCountMod -= projectileEdgesMod
