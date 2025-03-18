extends CanvasLayer

func _ready() -> void:
	$MessageLabel.connect("enemyDamage", _on_enemy_enemy_damage)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func _on_message_timer_timeout():
	$MessageLabel.hide()


func _on_enemy_enemy_damage(amount):
	$DamageLabel.text = str(amount)
