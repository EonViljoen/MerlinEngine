extends RigidBody2D

@onready var polygon : Polygon2D = $Polygon2D

@export var projectileRadius : int
@export var segments : int

func _ready() -> void:
	create_circle(projectileRadius)

func create_circle(radius):
	var polyPoints = []
	
	for i in range(segments):
		var angle = i * (TAU / segments)
		polyPoints.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	
	polygon.polygon = polyPoints
