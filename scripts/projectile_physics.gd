extends Node2D

@export var speed: float
@export var angle: float

@onready var area2d: Area2D = $RigidBody2D/Area2D
@onready var rBody: RigidBody2D = $RigidBody2D

var dest: Vector2
var _start: Vector2
var tween: Tween
var hasCollided: bool = false


@onready var projectileGravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	rBody.freeze = true
	_start = global_position
	animate_Shoot()
	
	
func animate_Shoot():
	var midPoint: Vector2 = (dest + _start)/2
	midPoint.y -= 100
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", midPoint, 0.5)
	tween.tween_property(self, "global_position", dest, 0.5)
	
#func bounce():
	#rBody.freeze = false
	#rBody.apply_impulse(Vector2.LEFT * 100)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if hasCollided:
		return
		
	if body.is_in_group("Targets"):
		body.take_damage(10)
		tween.kill()
		hasCollided = true
		
		var bounce = func() : 
			rBody.freeze = false
			rBody.apply_impulse(Vector2.LEFT * 100)
			
		bounce.call_deferred()
		
		#var timer = get_tree().create_timer(1.0)
		#timer.timeout.connect(
			#func(): queue_free()
			#)
		queue_free()
		
		
		
