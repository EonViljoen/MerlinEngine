extends RigidBody2D

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@export var spriteFrames : SpriteFrames

@onready var shield = $Shield

@export var isDummy: bool
@export var activeTarget: bool

signal enemyDamage

func _ready() -> void:
	contact_monitor = true
	if isDummy:
		self.freeze = true
		setDummyAnimation()
		disableShield()

func take_damage(amount):
	enemyDamage.emit(amount)

func is_target():
	if activeTarget:
		return self

func setDummyAnimation():
	sprite.sprite_frames = spriteFrames
	sprite.animation = "idle"

func disableShield():
	remove_child(shield)
