extends ProjectileModifier

@export var damage: float = 15

func apply_modifier(projectile):
	print(projectile.position)
