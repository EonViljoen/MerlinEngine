extends Node2D

@onready var player: RigidBody2D = $Player

func _ready() -> void:
	player.setPlayer()
