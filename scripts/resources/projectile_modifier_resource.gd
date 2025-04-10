extends Resource
class_name ProjectileModifierResource

# Projectile Appearance
@export var colorMod: Color = Color.MEDIUM_PURPLE
@export var edgeCountMod: float= 36.0
@export var sizeMod: float = 5.0

# Projectile Damage
@export var damageMod: float = 10.0
@export var criticalMod: float= 0.5
@export var knockbackMod: float= 1.0
@export var pierceMod: float= 0.0

# Projectile Behaviour
@export var speedMod: float = 5.0
@export var redirectionModCount: float= 0.0
@export var redirectionModDelay: float= 0.0
@export var bounceMod: float= 0.0

# Projectile Constraints
@export var costMod: float = 10.0

# Meta Properties
@export var activated: bool = false
