extends RigidBody2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var colShape: CollisionShape2D = $CollisionShape2D

@export var projectileScene: PackedScene
@export var spawnRange : float

func castSpell():
	var spell: Node2D = projectileScene.instantiate()
	self.add_child(spell)
	spell.global_position.x = self.global_position.x + spawnRange
	

func _on_timer_timeout() -> void:
	castSpell()
