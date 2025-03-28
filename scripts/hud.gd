extends CanvasLayer

@onready var debugLabel: Label = $DebugLabel
@onready var displayDebugLabelControl: bool = false

var characterStats: CharacterStatResource

func _ready() -> void:
	SignalBus.displayHUDMessage.connect(_on_player_set_message_hud)
	SignalBus.respondCharacterStat.connect(_on_respond_character_stat)
	
func _process(delta: float) -> void:
	if Input.is_action_just_released("EnableDebug"):
		displayDebugLabelControl = !displayDebugLabelControl
		
	if displayDebugLabelControl:
		displayDebugLabel()
	else:
		hideDisplayLabel()
		

func show_message(message):
	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()
	
func displayDebugLabel():
	SignalBus.requestCharacterStat.emit()
	$DebugLabel.text = """
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
	$DebugLabel.show()
	
func hideDisplayLabel():
	$DebugLabel.hide()
	
func _on_message_timer_timeout():
	$MessageLabel.hide()

func _on_enemy_enemy_damage(amount):
	$DamageLabel.text = str(amount)

func _on_player_set_mana_hud(currentManaAmount, maxManaAmount):
	$ManaLabel.text = str(currentManaAmount) + ' / ' + str(maxManaAmount)

func _on_player_set_message_hud(message) -> void:
	show_message(message)
	
func _on_respond_character_stat(characterStatResponse: CharacterStatResource):
	characterStats = characterStatResponse
