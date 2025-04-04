extends Node2D

@onready var rBody: RigidBody2D = $RigidBody2D
@onready var drop: float = 100

@onready var arcCount: float #Arcs to calculate and track
@onready var absoluteArcPoints: float = 10.0 #Arcs to happen, only for tracking
@onready var projectileGravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Projectile path variables
var angle: int
var dest: Vector2
var _start: Vector2

# Projectile shooting animation variable
var tween: Tween

# Projectile collision variables
var hasCollided: bool = false

# Projectile shot speed variables
var baseShootSpeed: float
var adjustedSpeed: float

func _ready() -> void:
	# Random angle shot
	randomize()
	angle = randi_range(-1, 1)
	
	# Freeze shot then move it with tween
	rBody.freeze = true
	_start = global_position
	
	tween = get_tree().create_tween()
	
	# Shot speed to keep the initial variable small
	adjustedSpeed = baseShootSpeed * 100
	
	# Actual shot
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
	
	# Midpoint calculation
	midPoint.y += angle * (drop * (1 - (2 * t - 1) ** 2))
	distance = currentPoint.distance_to(midPoint)
	
	# Arc tracking
	arcCount += 1.0;
	
	# Moving shot
	tween.tween_property(self, "global_position", midPoint,  distance/adjustedSpeed)
	
	# Recurse until done
	arc_shot(endPoint, midPoint)

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	# Error catching
	if hasCollided:
		return
		
	# If target has been hit, damage, kill animation and set collided to true
	if body.is_in_group("Targets"):
		body.take_damage($RigidBody2D.damage)
		tween.kill()
		hasCollided = true
		
		# Bounce effect to be added somewhere
		var bounce = func() : 
			rBody.freeze = false
			rBody.apply_impulse(Vector2.LEFT * 100)
		bounce.call_deferred()
		
		# Timer to despawn projectiles, add somewhere
		#var timer = get_tree().create_timer(1.0)
		#timer.timeout.connect(
			#func(): queue_free()
			#)
			
		# Despawn
		queue_free()
		
		
		
