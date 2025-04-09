extends RigidBody2D

@export var spriteFrames : SpriteFrames
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D


@onready var colShape: CollisionShape2D = $CollisionShape2D
@export var projectileModifierManager: ProjectileModifierManager
@export var characterStatManager: CharacterStatManager

@onready var stat: PackedScene

@export var projectileScene: PackedScene
@export var decimalRoundingStep: float

@onready var shield = $Shield

var characterStats: CharacterStatResource
var projectileModifier: ProjectileModifierResource

signal setManaHUD
signal setMessageHUD

func _ready():
	characterStats = characterStatManager.characterStatResource
	projectileModifier = projectileModifierManager.projectileModifierResource
	SignalBus.updateModifiers.connect(_on_projectile_modifier_manager_active_modifiers_updated)
	setCurrentMana()
	setPlayerAnimation()

func _process(_delta):
	if Input.is_action_just_released("ShootProjectile"):
		if get_viewport().gui_get_focus_owner():
			return
		castSpell()
		
	setShield()
		
func setCurrentMana():
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)
	
func regenMana():
	if characterStats.currentManaAmount != characterStats.maxManaAmount:
		characterStats.currentManaAmount += snapped(characterStats.maxManaAmount * characterStats.manaRegenRate, decimalRoundingStep)
		
		if characterStats.currentManaAmount > characterStats.maxManaAmount:
			characterStats.currentManaAmount = characterStats.maxManaAmount
		
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)
	

func castSpell():
	projectileModifierManager.apply_modifiers()

	if characterStats.currentManaAmount >= 10:
		
		characterStats.currentManaAmount -= projectileModifier.costMod # Have to do something like using spells nodes which stores cost etc
		setCurrentMana()
		
		var spell: Node2D = projectileScene.instantiate()
		spell.baseShootSpeed = projectileModifier.speedMod
		spell.global_position.x = characterStats.projectileSpawnRange
		spell.get_node("RigidBody2D").color = projectileModifier.colorMod
		
		var activeTarget = get_tree().get_nodes_in_group("Targets").filter(
			func(x):
				return x.activeTarget == true 
		).get(0)
		
		if activeTarget == null:
			return
			
		else:
			spell.dest = Vector2(activeTarget.global_position.x, activeTarget.global_position.y)
			spell.get_node("RigidBody2D").damage += projectileModifier.damageMod

			self.add_child(spell)
			
	else:
		setMessageHUD.emit('Not Enough Mana')

func setPlayerAnimation(): # Temp solution
	sprite.sprite_frames = spriteFrames
	sprite.animation = "idle_no_cape"
	
func setShield():
	var mousePosition = get_global_mouse_position()
	var mouseDirection = (mousePosition - global_position).normalized()
	var angle = mouseDirection.angle()
	
	shield.global_position = global_position + mouseDirection * (characterStats.shieldDistance*10)
	shield.rotation = angle

func _on_timer_timeout():
	regenMana()

func _on_projectile_modifier_manager_active_modifiers_updated(updatedModifiers: Array[ProjectileModifier]) -> void:
	projectileModifierManager.activeModifiersArray = updatedModifiers
