extends RigidBody2D

@export var isDummy: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	if isDummy:
		self.freeze = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func take_damage(amount):
	print("Damage: ", amount)
