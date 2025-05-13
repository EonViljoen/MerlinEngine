extends Sprite2D

@export var pulseScaleFactor : float


#func _ready() -> void:
	#pulse()
	
func modify_projectile_animation() -> void:
	pass

func pulse():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()

	tween.tween_property(self, "scale", Vector2(pulseScaleFactor, pulseScaleFactor), 0.1)
	tween.tween_property(self, "scale", Vector2(get_parent().projectileScaleFactor, get_parent().projectileScaleFactor), 0.1)
