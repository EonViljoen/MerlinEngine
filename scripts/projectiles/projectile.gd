extends RigidBody2D

@onready var polygon : Polygon2D = $Polygon2D
@onready var collission: CollisionShape2D = $CollisionShape2D

@export var projectileRadius : float
@export var projectileEdgesInput: float
@export var damage: float

@onready var color: Color
@onready var projectileEdges: float

func _ready() -> void:
	projectileEdges = projectileEdgesInput
	create_circle(projectileRadius)

func create_circle(radius):
	var polyPoints = []
	
	for i in range(projectileEdges):
		var angle = i * (TAU / projectileEdges)
		polyPoints.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	
	polygon.polygon = polyPoints
	polygon.color = color
