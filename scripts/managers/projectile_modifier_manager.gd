extends Node
class_name ProjectileModifierManager

@export var projectileResource: ProjectileModifierResource
@export var activeModifiers: Array[ProjectileModifier] = []  # Holds active modifiers


func apply_modifiers(projectile: Node2D):
	for modifier in get_children():
		if modifier is ProjectileModifier:
			modifier.apply_modifier(projectile)
			
#func apply_modifiers(projectile):
	#for modifier in modifiers:
		#modifier.apply_modifier(projectile)
