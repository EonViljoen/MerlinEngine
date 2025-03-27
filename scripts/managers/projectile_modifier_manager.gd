extends Node
class_name ProjectileModifierManager

@export var projectileResource: ProjectileModifierResource
var activeModifiersArray: Array[ProjectileModifier]

func _ready() -> void:
	#SignalBus.updateModifiers.connect()
	pass

func apply_modifiers():
	for mods in activeModifiersArray:
		print(mods)

	#for modifier in get_children():
		#if modifier is ProjectileModifier:
			#modifier.apply_modifier(projectile)

func get_modifiers_list() -> Array[Node]:
	return get_children()

func _on_button_container_pressed_modifier(modifierName: String) -> void:
	var mod = self.get_node(modifierName)
	activeModifiersArray.append(mod)
	
