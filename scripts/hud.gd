extends CanvasLayer

@onready var debugLabel: Label = $Labels/DebugLabel
@onready var displayDebugLabelControl: bool = false

@onready var healthBar: TextureProgressBar = $Bars/HealthBar
@onready var healthBarLabel: Label = $Bars/HealthBar/healthBarLabel
@onready var manaBar: TextureProgressBar = $Bars/ManaLabel
@onready var manaBarLabel: Label = $Bars/ManaLabel/manaBarLabel

@onready var activeModPanel: Panel = $ActiveModifiers/Panel
@onready var activeModBoxContainer: HFlowContainer = $ActiveModifiers/Panel/VBoxContainer 

var characterStats: CharacterStatResource
var activeProjectileMods: Array[ProjectileModifier]

func _ready() -> void:
	SignalBus.displayHUDMessage.connect(_on_player_set_message_hud)
	SignalBus.enemyDamage.connect(_on_enemy_enemy_damage)
	SignalBus.respondCharacterStat.connect(_on_respond_character_stat)
	SignalBus.respondProjectileModifiers.connect(_on_response_projectile_modifiers)
	
	activeModPanel.size.y = (activeModBoxContainer.size.y * 1.5)
		
func _process(_delta: float) -> void:
	activeProjectileModifierIndicator()
	
	if Input.is_action_just_released("EnableDebug"):
		displayDebugLabelControl = !displayDebugLabelControl
		
	if displayDebugLabelControl:
		displayDebugLabel()
	else:
		hideDisplayLabel()
		

func show_message(message) -> void:
	$Labels/MessageLabel.text = message
	$Labels/MessageLabel.show()
	$MessageTimer.start()
	
func displayDebugLabel() -> void:
	SignalBus.requestCharacterStat.emit()
	
	$Labels/DebugLabel.text = """
	Character Stats:
		Current Mana Amount: {currentMana}
		Max Mana Amount: {maxMana}
		Mana Regen Rate: {manaRegen}
		Projectile Shot Speed: {shotSpeed}
		Projectile Shot Damage: {shotDamage}
		Projectile Spawn Range: {spawnRange}
	""".format({
		"currentMana": characterStats.currentManaAmount,
		"maxMana": characterStats.maxManaAmount,
		"manaRegen": characterStats.manaRegenRate,
		"shotSpeed": characterStats.projectileShotSpeed,
		"shotDamage": characterStats.projectileShotDamage,
		"spawnRange": characterStats.projectileSpawnRange
	})
	
	$Labels/DebugLabel.show()
	
func hideDisplayLabel() -> void:
	$Labels/DebugLabel.hide()
	
func activeProjectileModifierIndicator() -> void: #entire method needs rework
	SignalBus.requestProjectileModifiers.emit() 
	
	if !activeModBoxContainer.get_children().is_empty():
		
		activeModPanel.size.y = (activeModBoxContainer.size.y * 1.5)
		
		for child in activeModBoxContainer.get_children():
			child.queue_free()
	
	if !activeProjectileMods.is_empty():
		var displayedModNames := []
		
		for mod in activeProjectileMods:
			if mod.modName in displayedModNames:
				continue
			
			var modCount = activeProjectileMods.filter(func(m): return m.modName == mod.modName).size()
			var modText = "%s (%d)" % [mod.modDisplayName, modCount]
			
			var modTextBlock = Label.new()
			modTextBlock.text = modText
			activeModPanel.size.y += modTextBlock.size.y
			activeModBoxContainer.add_child(modTextBlock)
			
			displayedModNames.append(mod.modName)
	
	
func _on_message_timer_timeout() -> void:
	$Labels/MessageLabel.hide()

func _on_enemy_enemy_damage(amount) -> void:
	$Labels/DamageLabel.text = str(amount)

func _on_player_set_health_hud(currentHealthAmount, maxHealthAmount) -> void:
	healthBar.value = (currentHealthAmount * 100) / maxHealthAmount
	healthBarLabel.text = str(currentHealthAmount) + ' / ' + str(maxHealthAmount)

func _on_player_set_mana_hud(currentManaAmount, maxManaAmount) -> void:
	manaBar.value = (currentManaAmount * 100) / maxManaAmount
	manaBarLabel.text = str(currentManaAmount) + ' / ' + str(maxManaAmount)

func _on_player_set_message_hud(message) -> void:
	show_message(message)
	
func _on_respond_character_stat(characterStatResponse: CharacterStatResource):
	characterStats = characterStatResponse

func _on_response_projectile_modifiers(activeProjectileModifiersResponse: Array[ProjectileModifier]):
	if !activeProjectileModifiersResponse.is_empty():
		activeProjectileMods = activeProjectileModifiersResponse
