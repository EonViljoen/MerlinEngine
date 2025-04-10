extends Resource
class_name ProjectileModifierResource

# Projectile Appearance
@export var colorMod: Color = Color.MEDIUM_PURPLE
@export var edgeCountMod: float= 0.0
@export var sizeMod: float = 0.0

# Projectile Damage
@export var damageMod: float = 0.0
@export var criticalDamageMod: float= 0.0

# Projectile Behaviour
@export var speedMod: float = 0.0
@export var redirectionModCount: float= 0.0
@export var redirectionModDelay: float= 0.0
@export var bounceMod: float= 0.0

# Projectile Miscellaneous Properties
@export var temperatureMod: float = 0.0

# Projectile Constraints
@export var costMod: float = 0.0
@export var criticalChanceMod: float = 0.0
@export var pierceChanceMod: float= 0.0
@export var knockbackChanceMod: float= 0.0

# Meta Properties
@export var activated: bool = false
