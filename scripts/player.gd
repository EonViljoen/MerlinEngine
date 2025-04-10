extends RigidBody2D

@export var spriteFrames : SpriteFrames
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var colShape: CollisionShape2D = $CollisionShape2D
@export var projectileModifierManager: ProjectileModifierManager
@export var characterStatManager: CharacterStatManager

@export var projectileScene: PackedScene
@export var decimalRoundingStep: float

@export var spellSlots: Array = []  # List of available spell data (BasicBoltSpell, etc.)
var castedSpell: SpellDataResource  # The selected spell (SpellDataResource)

@onready var shield = $Shield

var characterStats: CharacterStatResource

signal setManaHUD
signal setMessageHUD

func _ready():
	characterStats = characterStatManager.characterStatResource
	
	SignalBus.updateModifiers.connect(_on_projectile_modifier_manager_active_modifiers_updated)
	
	setCurrentMana()
	setPlayerAnimation()
	loadSpell()

func _process(_delta):
	if Input.is_action_just_released("ShootProjectile"):
		if get_viewport().gui_get_focus_owner():
			return
		shootProjectile()
		
	setShield()
		
func setCurrentMana():
	setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)
	
func regenMana():
	if characterStats.currentManaAmount != characterStats.maxManaAmount:
		characterStats.currentManaAmount += snapped(characterStats.maxManaAmount * characterStats.manaRegenRate, decimalRoundingStep)
		
		if characterStats.currentManaAmount > characterStats.maxManaAmount:
			characterStats.currentManaAmount = characterStats.maxManaAmount
		
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)


func shootProjectile():
	if castedSpell == null:
		setMessageHUD.emit('No Spell Selected')
		return
		
	if characterStats.currentManaAmount >= castedSpell.cost:
		
		characterStats.currentManaAmount -= castedSpell.cost
		setCurrentMana()
		
		var projectile = castedSpell.spellScene.instantiate()
		projectile.spellData = castedSpell
		projectileModifierManager.apply_modifiers()

		
		var activeTarget = get_tree().get_nodes_in_group("Targets").filter(
			func(x):
				return x.activeTarget == true
		).get(0)
		
		if activeTarget == null:
			return
		else:
			projectile.dest = Vector2(activeTarget.global_position.x, activeTarget.global_position.y)
		
		
		self.add_child(projectile)
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
	
func loadSpell() -> void:
	var basicBolt = preload("res://resources/spells/basic_bolt.tres")
	spellSlots.append(basicBolt)
	castedSpell = spellSlots[0]  # Set the first spell as the active one

#unlock_spell(preload("res://Spells/Fireball.tres"))
#func unlock_spell(new_spell: SpellDataResource):
	#if not spellSlots.has(new_spell):
		#spellSlots.append(new_spell)
		#print("Unlocked new spell:", new_spell.spell_name)

func _on_timer_timeout():
	regenMana()

func _on_projectile_modifier_manager_active_modifiers_updated(updatedModifiers: Array[ProjectileModifier]) -> void:
	projectileModifierManager.activeModifiersArray = updatedModifiers
