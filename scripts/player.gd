extends RigidBody2D

@export var spriteFrames : SpriteFrames
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var colShape: CollisionShape2D = $CollisionShape2D
@export var projectileModifierManager: ProjectileModifierManager
@export var characterStatManager: CharacterStatManager

@export var projectileScene: PackedScene
@export var decimalRoundingStep: float

var castedSpell: SpellDataResource  # The selected spell (SpellDataResource)
@onready var spellManager = $Managers/SpellManager

@onready var shield = $Shield

var characterStats: CharacterStatResource

signal setHealthHUD
signal setManaHUD
signal setMessageHUD
signal playerDamage

func _ready():
	characterStats = characterStatManager.characterStatResource
	
	SignalBus.updateModifiers.connect(_on_projectile_modifier_manager_active_modifiers_updated)
	SignalBus.currentSpellInUse.connect(_on_spell_manager_current_spell_in_use)

	
	setCurrentHealth()
	setCurrentMana()
	setPlayerAnimation()
	spellManager.loadSpells()

func _process(_delta):
	if Input.is_action_just_released("ShootProjectile"):
		if get_viewport().gui_get_focus_owner():
			return
		shootProjectile()
		
	setShield()
		
func setCurrentHealth():
	setHealthHUD.emit(characterStats.currentHealthAmount, characterStats.maxHealthAmount)
	
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
		
	print(castedSpell.spellName)
	
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
			projectile.target = "Targets"
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
	
func take_damage(amount):
	characterStats.currentHealthAmount -= amount
	playerDamage.emit(characterStats.currentHealthAmount, characterStats.maxHealthAmount)

func _on_timer_timeout():
	regenMana()
	
func _on_spell_manager_current_spell_in_use(currentSpellInUse: SpellDataResource) -> void:
	print("current spell: ", currentSpellInUse.spellName)
	castedSpell = currentSpellInUse
	
func _on_projectile_modifier_manager_active_modifiers_updated(updatedModifiers: Array[ProjectileModifier]) -> void:
	projectileModifierManager.activeModifiersArray = updatedModifiers
