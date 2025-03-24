extends CanvasLayer

signal heatUp

func show_message(message):
	$MessageLabel.text = message
	$MessageLabel.show()
	$MessageTimer.start()
		

func _on_message_timer_timeout():
	$MessageLabel.hide()

func _on_enemy_enemy_damage(amount):
	$DamageLabel.text = str(amount)
		
#func _mana_regen(amount):
	#$DamageLabel.text = str(manaRegenRate)


func _on_player_set_mana_hud(currentManaAmount, maxManaAmount):
	$ManaLabel.text = str(currentManaAmount) + ' / ' + str(maxManaAmount)


func _on_player_set_message_hud(message) -> void:
	show_message(message)


func _on_heat_up_button_pressed() -> void:
	emit_signal("heatUp")
