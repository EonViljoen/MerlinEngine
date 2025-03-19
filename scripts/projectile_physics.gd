extends Node2D

@export var speed: float
@export var angle: float

@onready var projectileGravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	shoot()
	
func shoot():
	#var targetPos = 
	
	
	
	var radians = deg_to_rad(angle)
	var direction = Vector2(cos(radians), -sin(radians))
	
	$RigidBody2D.apply_impulse(speed * direction)
