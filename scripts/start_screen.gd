extends Control


func _on_start_button_pressed() -> void:
	get_node("/root/Main").loadBattleScene()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
