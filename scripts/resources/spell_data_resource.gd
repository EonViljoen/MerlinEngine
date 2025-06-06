extends Resource
class_name SpellDataResource

@export var spellName: String
@export var color: Color = Color.WHITE
@export var spellEdgeCount: float = 36.0
@export var spellSize: float = 5.0

@export var baseShootSpeed: float = 0.0
@export var damage: float = 0.0
@export var criticalDamage: float = 0.0
@export var knockBack: float = 0.0

@export var directionCount: float = 1.0
@export var redirectDelay: float = 0.0

@export var statusAffliction: Array

@export var cost: float = 0.0
@export var cooldown: float = 0.0
@export var criticalChance: float = 0.0
@export var pierceChance: float = 0.0
@export var bounce: float = 0.0

@export var spawnOffset: Vector2 = Vector2.ZERO

@export var spellScene: PackedScene
@export var coreShaderMaterial: ShaderMaterial
@export var auraShaderMaterial: ShaderMaterial
@export var trailShaderMaterial: ShaderMaterial

@export var unlocked: bool = false
