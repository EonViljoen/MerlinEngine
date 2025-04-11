extends RigidBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var spriteFrames : SpriteFrames

@onready var shield = $Shield

@export var isDummy: bool
@export var activeTarget: bool
@export var shooting: bool = false

@export var enemyProjectile = preload("res://resources/spells/basic_bolt.tres")
@export var enemyProjectileTimer: float = 10.0
@export var enemyProjectileTimerRandomRange: float = 10.0

signal enemyDamage

func _ready() -> void:
	contact_monitor = true
	if isDummy:
		self.freeze = true
		setDummyAnimation()
		disableShield()
	
	shootProjectile()

func take_damage(amount):
	enemyDamage.emit(amount)
	
func shootProjectile():
	if shooting:
		var target = get_tree().get_first_node_in_group("Player")
		randomize()
		var enemyShotTimer = get_tree().create_timer(randi_range(enemyProjectileTimer, enemyProjectileTimer + enemyProjectileTimerRandomRange))
		
		enemyShotTimer.timeout.connect(
			func(): 
				var projectile = enemyProjectile.spellScene.instantiate()
				projectile.target = "Player"
				projectile.spellData = enemyProjectile
				projectile.dest = Vector2(target.global_position.x, target.global_position.y)
				
				self.add_child(projectile)
				shootProjectile()
				)

func is_target():
	if activeTarget:
		return self

func setDummyAnimation():
	sprite.sprite_frames = spriteFrames
	sprite.animation = "idle"

func disableShield():
	remove_child(shield)
