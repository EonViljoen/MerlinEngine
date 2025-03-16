extends Node2D

@export var speed: float
@export var direction: Vector2

func _ready():
	shoot()
	
func shoot():
	$RigidBody2D.apply_impulse(Vector2(speed*direction))
