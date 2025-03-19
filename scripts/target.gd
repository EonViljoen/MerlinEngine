extends RigidBody2D

@export var isDummy: bool

signal enemyDamage

func _ready() -> void:
	contact_monitor = true
	if isDummy:
		self.freeze = true

func take_damage(amount):
	enemyDamage.emit(amount)
