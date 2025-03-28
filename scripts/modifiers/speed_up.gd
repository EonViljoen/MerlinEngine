extends ProjectileModifier

@export var modDisplayName: String = "Speed Boost"
@export var modName: String = "SpeedBoost"
@export var speedMod: float = 1.5
@export var activated: bool = false
@export var characterStateResource: CharacterStatResource

func apply_modifier():
	characterStateResource.projectileShotSpeed += speedMod
	SignalBus.statUpdate.emit(characterStateResource, "projectileShotSpeed", characterStateResource.projectileShotSpeed)
