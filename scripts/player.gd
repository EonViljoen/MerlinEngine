extends RigidBody2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var colShape: CollisionShape2D = $CollisionShape2D
@onready var spellSpawnPos: Node2D = $SpellSpawnPos

@export var magicBoltScene: PackedScene
@export var spawnRange = 30

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func castSpell():
	var spell: RigidBody2D = magicBoltScene.instantiate()
	self.add_child(spell)
	spell.global_position = spellSpawnPos.global_position
	spell.global_position.x = self.global_position.x + spawnRange

func _on_timer_timeout() -> void:
	castSpell()
