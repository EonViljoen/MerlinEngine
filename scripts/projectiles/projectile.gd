extends RigidBody2D

@onready var polygon : Polygon2D = $Polygon2D
@onready var collission: CollisionShape2D = $CollisionShape2D

@export var projectileRadius : float
@export var projectileEdgesInput: float

@onready var projectileEdges: float

func _ready() -> void:
	$DummyTest.queue_free()
	projectileEdges = projectileEdgesInput + GlobalProjectileModifiers.modifier_resource.edgeCountMod
	create_circle(projectileRadius + GlobalProjectileModifiers.modifier_resource.sizeMod)

func create_circle(radius):
	var polyPoints = []
	
	for i in range(projectileEdges):
		var angle = i * (TAU / projectileEdges)
		polyPoints.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	
	polygon.polygon = polyPoints
