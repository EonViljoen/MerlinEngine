extends Node
class_name ProjectileModifierManager

@export var projectile_resource: ProjectileModifierResource
@export var modifiers: Array[ProjectileModifier] = []  # Holds active modifiers


func apply_modifiers(projectile):
	for modifier in get_children():
		if modifier is ProjectileModifier:
			modifier.apply_modifier(projectile)
			
#func apply_modifiers(projectile):
	#for modifier in modifiers:
		#modifier.apply_modifier(projectile)
