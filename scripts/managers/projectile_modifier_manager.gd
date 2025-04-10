extends Node
class_name ProjectileModifierManager

@export var projectileModifierResource: ProjectileModifierResource
var activeModifiersArray: Array[ProjectileModifier]

func _ready() -> void:
	SignalBus.requestProjectileModifiers.connect(_on_projectile_modifiers_request)
	
func apply_modifiers() -> void:
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
		SignalBus.displayHUDMessage.emit(str(mod.modDisplayName, " has been Equipped"))
	else:
		SignalBus.displayHUDMessage.emit("Can't Equip More Modifiers!")


func _on_button_container_subtracted_modifier(modifierName: String) -> void:
	if !activeModifiersArray.is_empty():
		for mod in activeModifiersArray:
			if mod.modName == modifierName:
				var i := activeModifiersArray.find(mod)
				if i != -1:
					mod.activated = false
					activeModifiersArray.pop_at(mod.get_index())
					mod.unapply_modifier()
					break
		SignalBus.updateModifiers.emit(activeModifiersArray)
		SignalBus.displayHUDMessage.emit(str(modifierName, " has been Unequipped"))
	else:
		SignalBus.displayHUDMessage.emit("No Modifiers to Unequipped")	
	

func _on_projectile_modifiers_request() -> void:
	SignalBus.respondProjectileModifiers.emit(activeModifiersArray)
	
func _on_stack_projectile_modifier() -> void:
	pass

func _on_unstack_projectile_modifier() -> void:
	pass
