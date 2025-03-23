extends RigidBody2D

@onready var area2d: Area2D = $Area2D

var dest: Vector2
var _start: Vector2
var tween: Tween
var casCollided: bool = false

func _ready() -> void:
	freeze = true
	_start = global_position
	animate()
	

func animate():
	var midPoint: Vector2 = (dest + _start)/2
	midPoint.y -= 100
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", midPoint, 0.5)
	tween.tween_property(self, "global_position", dest, 0.5)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if casCollided:
		return
	if body.is_in_group("Targets"):
		body.take_damage(10)
		tween.kill()
		casCollided = true
		var x = func() : 
			freeze = false
			apply_impulse(Vector2.LEFT * 100)
		x.call_deferred()
		var timer = get_tree().create_timer(1.0)
		timer.timeout.connect(
			func(): queue_free()
			)
		#queue_free()
