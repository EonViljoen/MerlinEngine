extends Node
class_name ProjectileModifierManager

@export var projectileResource: ProjectileModifierResource
@export var activeModifiers: Array[ProjectileModifier] = []

func apply_modifiers(projectile: Node2D):
	for modifier in get_children():
		if modifier is ProjectileModifier:
			modifier.apply_modifier(projectile)

func get_modifiers_list() -> Array[Node]:
	return get_children()

#func apply_modifiers(projectile):
	#for modifier in modifiers:
		#modifier.apply_modifier(projectile)


func _on_button_container_pressed_modifier(modifierName: String) -> void:
	var mod = self.get_node(modifierName)
	activeModifiers.append(mod)
	print(activeModifiers)
