extends Node
class_name ProjectileModifierManager

@export var projectileResource: ProjectileModifierResource
var activeModifiersArray: Array[ProjectileModifier]

func _ready() -> void:
	SignalBus.requestProjectileModifiers.connect(_on_projectile_modifiers_request)

func apply_modifiers():
	for mod in activeModifiersArray:
		if !mod.activated :
			mod.activated = true
			mod.apply_modifier()

func get_modifiers_list() -> Array[Node]:
	return get_children()

func _on_button_container_added_modifier(modifierName: String) -> void:
	if activeModifiersArray.size() < 10 : #Make this better in a bit
		var mod: ProjectileModifier = self.get_node(modifierName).duplicate()
		activeModifiersArray.append(mod)
		SignalBus.updateModifiers.emit(activeModifiersArray)
		SignalBus.displayHUDMessage.emit(str(mod.modDisplayName, " has been activated"))
	else:
		SignalBus.displayHUDMessage.emit("Can't Equip More Modifiers!")


func _on_button_container_subtracted_modifier(modifierName: String) -> void:

	for mod in activeModifiersArray:
		if mod.modName == modifierName:
			var i := activeModifiersArray.find(mod)
			if i != -1:
				activeModifiersArray.pop_at(mod.get_index())
				break
	SignalBus.updateModifiers.emit(activeModifiersArray)
	SignalBus.displayHUDMessage.emit(str(modifierName, " has been deactivated"))		
	

func _on_projectile_modifiers_request():
	SignalBus.respondProjectileModifiers.emit(activeModifiersArray)
