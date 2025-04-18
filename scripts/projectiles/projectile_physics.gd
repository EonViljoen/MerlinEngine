extends Node2D

@onready var rBody: RigidBody2D = $RigidBody2D
@onready var drop: float = 100
var spellData: SpellDataResource

@onready var arcCount: float #Arcs to calculate and track
@onready var absoluteArcPoints: float = spellData.directionCount
@onready var projectileGravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# Projectile path variables
var angle: int
var dest: Vector2
var start: Vector2

# Projectile shooting animation variable
var tween: Tween

# Projectile collision variables
var hasCollided: bool = false

# Projectile shot variables
@export var adjustedSpeedFactor: float
var adjustedSpeed: float
var cost: float
var cooldown: float
var target: String

func _ready() -> void:
	if !spellData:
		return

	add_to_group("Projectiles")
	


		
	#rBody.shaderMaterial = spellData.material
	#rBody.modulate = rBody.modulate.blend(spellData.color * GlobalProjectileModifiers.modifier_resource.colorMod)
	start = global_position + spellData.spawnOffset
	adjustedSpeed = (spellData.baseShootSpeed + GlobalProjectileModifiers.modifier_resource.speedMod) * adjustedSpeedFactor
	
	
	# Freeze shot then move it with tween
	rBody.freeze = true	

	# Tween for movement animation
	tween = get_tree().create_tween()

	# Random angle shot
	randomize()
	angle = randi_range(-1, 1)
	
	# Actual shot
	arc_shot(dest, start)

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
	if body.is_in_group(target):
		body.take_damage(spellData.damage + GlobalProjectileModifiers.modifier_resource.damageMod)
		tween.kill()
		hasCollided = true
		queue_free()

		# Bounce effect to be added somewhere
		#var bounce = func() : 
			#rBody.freeze = false
			#rBody.apply_impulse(Vector2.LEFT * 100)
		#bounce.call_deferred()
		
		# Timer to despawn projectiles, add somewhere
		#var timer = get_tree().create_timer(1.0)
		#timer.timeout.connect(
			#func(): queue_free()
			#)
			
		# Despawn
		
		
		
