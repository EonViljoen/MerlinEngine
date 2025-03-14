extends RigidBody2D

@onready var polygon : Polygon2D = $Polygon2D

@export var speed = 250

var tween: Tween
var boltRadius= 8
var boltScaleFactor = 1.3
var segments = 6

func _ready() -> void:
	$Area2D.connect("body_entered", _on_body_entered)
	tween = get_tree().create_tween()
	create_circle(boltRadius)
	pulse()
	
	self.linear_velocity.x = speed
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func _on_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("Targets"):
		body.take_damage(10)
		queue_free()

func create_circle(radius):
	var polyPoints = []
	
	for i in range(segments):
		var angle = i * (TAU / segments)
		polyPoints.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	
	polygon.polygon = polyPoints
#
func pulse():
	tween.tween_property(self, "scale", Vector2(boltScaleFactor, boltScaleFactor), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween.stop()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	tween.stop()
	pulse()  # Loop the animation
