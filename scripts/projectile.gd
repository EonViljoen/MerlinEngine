extends RigidBody2D

@onready var polygon : Polygon2D = $Polygon2D

@export var projectileRadius : int
@export var segments : int

func _ready() -> void:
	$Area2D.connect("body_entered", _on_rigid_body_2d_body_entered)
	create_circle(projectileRadius)


func _on_rigid_body_2d_body_entered(body: RigidBody2D) -> void:
	if body.is_in_group("Targets"):
		body.take_damage(10)
		queue_free()

func create_circle(radius):
	var polyPoints = []
	
	for i in range(segments):
		var angle = i * (TAU / segments)
		polyPoints.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	
	polygon.polygon = polyPoints
