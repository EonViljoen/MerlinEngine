extends Node
class_name CharacterStatManager

@export var characterStatResource: CharacterStatResource

func _ready() -> void:
	SignalBus.statUpdate.connect(_on_stat_update)
	SignalBus.requestCharacterStat.connect(_on_character_request)
	
func _on_stat_update(statName: String, newStatValue: float) -> void:
	if(characterStatResource.get(statName)):
		characterStatResource.set(statName, newStatValue)
	
func _on_character_request() -> void :
	SignalBus.respondCharacterStat.emit(characterStatResource)
	
