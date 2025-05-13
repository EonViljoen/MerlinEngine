extends RigidBody2D

@onready var collission: CollisionShape2D = $CollisionShape2D

@onready var coreShaderMaterial: ShaderMaterial
@onready var auraShaderMaterial: ShaderMaterial
@onready var trailShaderMaterial: ShaderMaterial

@onready var auraShaderSprite: Sprite2D = $AuraShaderSprite
@onready var coreShaderSprite: Sprite2D = $CoreShaderSprite

@onready var projectileRadius : float
@onready var projectileEdges: float
var projectileScaleFactor: float


func _ready() -> void:
	call_deferred("setupProjectile")
	
func setupProjectile():
	projectileEdges = projectileEdges + GlobalProjectileModifiers.modifier_resource.edgeCountMod
	SetupEffects()
	
	
func setShaders(coreShaderMaterialData: ShaderMaterial, auraShaderMaterialData: ShaderMaterial, trailShaderMaterialData: ShaderMaterial):
	coreShaderMaterial = coreShaderMaterialData
	auraShaderMaterial = auraShaderMaterialData
	trailShaderMaterial = trailShaderMaterialData

	
func SetupEffects() -> void:
	
	if coreShaderMaterial:
		coreShaderSprite.material = coreShaderMaterial
		scaleTexture(coreShaderSprite, false)
		coreShaderSprite.z_index = 4

	if auraShaderMaterial:
		auraShaderSprite.material = auraShaderMaterial
		scaleTexture(auraShaderSprite, true)
		auraShaderSprite.z_index = 3
	
func scaleTexture(sprite: Sprite2D, extend: bool) -> void:
	var textureSize = sprite.texture.get_width()
	var scaleFactor = (projectileRadius*2) / textureSize
	if extend:
		sprite.scale = Vector2(scaleFactor, scaleFactor + 2)
		print(sprite.scale)
	else:
		sprite.scale = Vector2(scaleFactor, scaleFactor)
		print(sprite.scale)
