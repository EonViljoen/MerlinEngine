extends Node
class_name ProjectileModifierManager

@export var projectileResource: ProjectileModifierResource
var activeModifiersArray: Array[ProjectileModifier]

func apply_modifiers():
	for mod in activeModifiersArray:
		if !mod.activated :
			mod.activated = true
			mod.apply_modifier()

func get_modifiers_list() -> Array[Node]:
	return get_children()

func _on_button_container_pressed_modifier(modifierName: String) -> void:
	var mod: ProjectileModifier = self.get_node(modifierName).duplicate()
	activeModifiersArray.append(mod)
	SignalBus.updateModifiers.emit(activeModifiersArray)
	
