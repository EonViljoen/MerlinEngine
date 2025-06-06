extends Node

@onready var currentScene: Node

func _ready() -> void:
	loadStartScreen()
	
func loadStartScreen() -> void:
	changeScene("res://scenes/start_screen.tscn")
	
func loadBattleScene() -> void:
	changeScene("res://scenes/battle.tscn")

func returnToStart() -> void:
	loadStartScreen()
	
func changeScene(scene: String) -> void:
	if currentScene:
		currentScene.queue_free()
		
	get_tree().change_scene_to_file.call_deferred(scene)
