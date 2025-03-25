extends Node2D

@onready var rBody: RigidBody2D = $RigidBody2D
@onready var drop: float = 100
@onready var baseShootSpeed: float = 10
@onready var arcCount: float #Arcs to calculate and track
@onready var absoluteArcPoints: float = 10.0 #Arcs to happen, only for tracking
@onready var projectileGravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var angle: int = randi_range(-1, 1)

var dest: Vector2
var _start: Vector2
var tween: Tween
var hasCollided: bool = false
var adjustedSpeed: float

func _ready() -> void:
	rBody.freeze = true
	_start = global_position
	tween = get_tree().create_tween()
	adjustedSpeed = baseShootSpeed * 100
	
	arc_shot(dest, _start)

func arc_shot(endPoint: Vector2, currentPoint: Vector2):
	var distance: float
	
	# Break out case
	if arcCount == absoluteArcPoints:
		distance = currentPoint.distance_to(endPoint)
		tween.tween_property(self, "global_position", endPoint, distance/adjustedSpeed)
		return
		
	# Find midpoint
	var t : float = float(arcCount/absoluteArcPoints)
	var midPoint : Vector2 = (1 - t) * currentPoint + t * endPoint
	
	midPoint.y += angle * (drop * (1 - (2 * t - 1) ** 2))
	distance = currentPoint.distance_to(midPoint)
	arcCount += 1.0;
	
	tween.tween_property(self, "global_position", midPoint,  distance/adjustedSpeed)
	arc_shot(endPoint, midPoint)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if hasCollided:
		return
		
	if body.is_in_group("Targets"):
		body.take_damage($RigidBody2D.damage)
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
		
		
		
