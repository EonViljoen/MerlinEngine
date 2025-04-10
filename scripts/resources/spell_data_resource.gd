extends Resource
class_name SpellDataResource

@export var spellName: String
@export var baseShootSpeed: float = 0.0
@export var damage: float = 0.0
@export var color: Color = Color.WHITE
@export var cost: float = 0.0
@export var cooldown: float = 0.0
@export var spawnOffset: Vector2 = Vector2.ZERO
@export var spellScene: PackedScene  # The projectile scene to instantiate
