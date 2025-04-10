extends ProjectileModifier

@export var modDisplayName: String = "Speed Boost"
@export var modName: String = "SpeedBoost"
@export var colorMod: Color = Color.INDIAN_RED
@export var speedMod: float = 1.5
@export var activated: bool = false
@export var characterStateResource: CharacterStatResource
@export var projectileModifierResource : ProjectileModifierResource


func apply_modifier():
	projectileModifierResource.speedMod += speedMod
	

func unapply_modifier():
	projectileModifierResource.speedMod -= speedMod
