extends RigidBody2D

@export var isDummy: bool
@export var activeTarget: bool

signal enemyDamage

func _ready() -> void:
	contact_monitor = true
	if isDummy:
		self.freeze = true

func take_damage(amount):
	enemyDamage.emit(amount)

func is_target():
	if activeTarget:
		return self
