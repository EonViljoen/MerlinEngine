extends RigidBody2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var colShape: CollisionShape2D = $CollisionShape2D
@onready var modifierManager: ProjectileModifierManager = $ProjectileModifierManager
@onready var statManager: CharacterStatManager = $CharacterStatManager

@onready var heatUp: float = 0.0
@onready var stat: PackedScene

@export var projectileScene: PackedScene
@export var decimalRoundingStep: float

var characterStats: CharacterStatResource


signal setManaHUD
signal setMessageHUD

func _ready():
	characterStats = statManager.characterStatResource
	SignalBus.updateModifiers.connect(_on_projectile_modifier_manager_active_modifiers_updated)
	setCurrentMana()

func _process(_delta):
	if Input.is_action_just_released("ShootProjectile"):
		if get_viewport().gui_get_focus_owner():
			return
		castSpell()
	
func setCurrentMana():
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)
	
func regenMana():
	if characterStats.currentManaAmount != characterStats.maxManaAmount:
		characterStats.currentManaAmount += snapped(characterStats.maxManaAmount * characterStats.manaRegenRate, decimalRoundingStep)
		
		if characterStats.currentManaAmount > characterStats.maxManaAmount:
			characterStats.currentManaAmount = characterStats.maxManaAmount
		
		setManaHUD.emit(characterStats.currentManaAmount, characterStats.maxManaAmount)
	

func castSpell():
	modifierManager.apply_modifiers()

	if characterStats.currentManaAmount >= 10:
		
		characterStats.currentManaAmount -= 10 # Have to do something like using spells nodes which stores cost etc
		setCurrentMana()
		
		var spell: Node2D = projectileScene.instantiate()
		spell.baseShootSpeed = characterStats.projectileShotSpeed
		#modifierManager.apply_modifiers(spell)
		var activeTarget = get_tree().get_nodes_in_group("Targets").filter(
			func(x):
				return x.activeTarget == true 
		).get(0)
		
		if activeTarget == null:
			return
			
		else:
			spell.dest = Vector2(activeTarget.global_position.x, activeTarget.global_position.y)
			self.add_child(spell)
			spell.get_node("RigidBody2D").damage += characterStats.projectileShotDamage
			spell.global_position.x = self.global_position.x + characterStats.projectileSpawnRange
			
	else:
		setMessageHUD.emit('Not Enough Mana')
	

func _on_timer_timeout():
	regenMana()

func _on_projectile_modifier_manager_active_modifiers_updated(updatedModifiers: Array[ProjectileModifier]) -> void:
	modifierManager.activeModifiersArray = updatedModifiers
