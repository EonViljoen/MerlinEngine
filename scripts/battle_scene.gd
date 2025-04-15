extends Node2D

@onready var player: RigidBody2D = $Player

func _ready() -> void:
	# look at below maybe?
	#var playerScene = load("res://scenes/Player.tscn") 
	#var playerInstance = playerScene.instantiate()
	#playerInstance.characterStatResource = load("res://resources/CharacterStatResource.tres")
	#add_child(playerInstance)
	
	player.setPlayer()
