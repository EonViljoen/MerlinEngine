extends "res://scripts/character.gd"

@onready var colShape: CollisionShape2D = $CollisionShape2D
@export var projectileModifierManager: ProjectileModifierManager

@export var decimalRoundingStep: float

var castedSpell: SpellDataResource
@onready var spellManager = $Managers/SpellManager

@onready var shield = $Shield
@onready var shieldManaTimer = $Shield/ShieldManaConsumption
var shieldActive := false

signal setHealthHUD
signal setManaHUD
signal setMessageHUD
signal playerDamage

func _ready() -> void:	
	SignalBus.updateModifiers.connect(_on_projectile_modifier_manager_active_modifiers_updated)
	SignalBus.currentSpellInUse.connect(_on_spell_manager_current_spell_in_use)
	
	super.setCharacterAnimation("player_idle")
	setPlayer()
	spellManager.loadSpells()


func _process(_delta) -> void:
	if Input.is_action_just_released("ShootProjectile"):
		shootProjectile()
	if Input.is_action_pressed("UseShield"):
		setShield()
		if !shieldActive and characterStats.currentManaAmount > shield.manaConsumption:
			activateShield()
	else:
		if shieldActive:
			deactivateShield()

func setPlayer() -> void:
	characterStats.currentHealthAmount = characterStats.maxHealthAmount
	characterStats.currentManaAmount = characterStats.maxManaAmount
	
	setCurrentHealth()
	setCurrentMana()
	
 
func setCurrentHealth() -> void:
	setHealthHUD.emit(characterStats.currentHealthAmount, characterStats.maxHealthAmount)

func setCurrentMana() -> void:
	setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)

func regenMana() -> void:
	if characterStats.currentManaAmount != characterStats.maxManaAmount:
		characterStats.currentManaAmount += snapped(characterStats.maxManaAmount * characterStats.manaRegenRate, decimalRoundingStep)
		
		if characterStats.currentManaAmount > characterStats.maxManaAmount:
			characterStats.currentManaAmount = characterStats.maxManaAmount
		
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)

func shootProjectile() -> void:
	if castedSpell == null:
		setMessageHUD.emit('No Spell Selected')
		return
			
	if characterStats.currentManaAmount >= castedSpell.cost:
		
		characterStats.currentManaAmount -= castedSpell.cost
		setCurrentMana()
		
		var projectile = castedSpell.spellScene.instantiate()
		projectile.spellData = castedSpell
		
		projectileModifierManager.apply_modifiers()

		var targets = get_tree().get_nodes_in_group("Targets")
		if targets.size() > 0:
			var activeTarget = targets[0]
			projectile.target = "Targets"
			projectile.dest = Vector2(activeTarget.global_position.x, activeTarget.global_position.y)
		else:
			setMessageHUD.emit("No Target Selected")
			return

		self.add_child(projectile)
	else:
		setMessageHUD.emit('Not Enough Mana')

func activateShield() -> void:
	shieldManaTimer.start()
	
	shieldActive = true
	shield.visible = true
	shield.get_node("StaticBody2D/CollisionShape2D").disabled = false
	shield.get_node("Area2D/CollisionShape2D").disabled = false
	shield.get_node("Area2D").monitoring = true
	
	characterStats.currentManaAmount -= shield.manaConsumption
	setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)

func deactivateShield() -> void:
	shieldManaTimer.stop()
	shieldActive = false
	shield.get_node("StaticBody2D/CollisionShape2D").disabled = true
	shield.get_node("Area2D/CollisionShape2D").disabled = true
	shield.visible = false
	shield.get_node("Area2D").monitoring = false

func setShield() -> void:
	var mousePosition = get_global_mouse_position()
	var mouseDirection = (mousePosition - global_position).normalized()
	var angle = mouseDirection.angle()

	shield.global_position = global_position + mouseDirection * (characterStats.shieldDistance*10)
	shield.rotation = angle

func take_damage(amount) -> void:
	super.take_damage(amount)
	playerDamage.emit(characterStats.currentHealthAmount, characterStats.maxHealthAmount)
	
	if characterStats.currentHealthAmount < 0:
		setMessageHUD.emit("You Died, Returning to Home Screen")
		die(self)

func die(player: RigidBody2D) -> void:
	super.die(player)
	set_process_input(false)
	set_physics_process(false)
	await get_tree().create_timer(3.0).timeout
	MainSceneManager.returnToStart()

func _on_timer_timeout() -> void:
	regenMana()

func _on_spell_manager_current_spell_in_use(currentSpellInUse: SpellDataResource) -> void:
	castedSpell = currentSpellInUse

func _on_projectile_modifier_manager_active_modifiers_updated(updatedModifiers: Array[ProjectileModifier]) -> void:
	projectileModifierManager.activeModifiersArray = updatedModifiers

func _on_shield_mana_consumption_timeout() -> void:
	if characterStats.currentManaAmount > shield.manaConsumption:
		characterStats.currentManaAmount -= shield.manaConsumption
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)
	else:
		deactivateShield()
		shieldActive = false
