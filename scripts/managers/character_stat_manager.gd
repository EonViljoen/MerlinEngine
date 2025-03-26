extends Node
class_name CharacterStatManager

@export var characterStatResource: CharacterStatResource

func _ready() -> void:
	SignalBus.statUpdate.connect(_on_stat_update)
	
func _on_stat_update(statResource: CharacterStatResource, statName: String, newStatValue: float) -> void:
	if(characterStatResource.get(statName)):
		characterStatResource.set(statName, newStatValue)
