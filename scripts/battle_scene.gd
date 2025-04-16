extends Node2D

var battleSceneReady: bool = false

@onready var player: RigidBody2D = $Player

func _ready() -> void:
	# look at below maybe?
	#var playerScene = load("res://scenes/Player.tscn") 
	#var playerInstance = playerScene.instantiate()
	#playerInstance.characterStatResource = load("res://resources/CharacterStatResource.tres")
	#add_child(playerInstance)
	await  get_tree().process_frame
	get_viewport().gui_release_focus()
	battleSceneReady = true
	
	player.setPlayer()
