extends RigidBody2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var colShape: CollisionShape2D = $CollisionShape2D

@export var projectileScene: PackedScene
@export var roundingStep: float

@export var spawnRange : float
@export var currentManaAmount: float
@export var maxManaAmount: float
@export var manaRegenRate: float

signal setManaHUD
signal setMessageHUD

func _ready():
	setCurrentMana()
	#setSpawnRange()

func _process(_delta):
	if Input.is_action_just_released("LeftMouseClick"):
		castSpell()
	
func setCurrentMana():
		setManaHUD.emit(currentManaAmount, maxManaAmount)
	
func regenMana():
	if currentManaAmount != maxManaAmount:
		currentManaAmount += snapped(maxManaAmount * manaRegenRate, roundingStep)
		
		if currentManaAmount > maxManaAmount:
			currentManaAmount = maxManaAmount
		
		setManaHUD.emit(currentManaAmount, maxManaAmount)
	

func castSpell():
	if currentManaAmount >= 10:
		
		currentManaAmount -= 10 # Have to do something like using spells nodes which stores cost etc
		setCurrentMana()
		
		var spell: Node2D = projectileScene.instantiate()
		self.add_child(spell)
		spell.global_position.x = self.global_position.x + spawnRange
		
		
	else:
		setMessageHUD.emit('Not Enough Mana')
	

func _on_timer_timeout():
	regenMana()
