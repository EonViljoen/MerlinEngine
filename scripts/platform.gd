extends StaticBody2D

@export var platformHeight: float
@export var platformLength: float

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	var collissionShape = RectangleShape2D.new()
	collissionShape.size = Vector2(platformHeight, platformLength)
	collision.shape = collissionShape
	
	#sprite. = platformHeight
	
