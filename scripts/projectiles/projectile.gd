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
	if coreShaderMaterialData == null :
		$CoreShaderSprite.texture = null;
	else:
		coreShaderMaterial = coreShaderMaterialData
	if auraShaderMaterialData == null :
		$AuraShaderSprite.texture = null;
	else:
		auraShaderMaterial = auraShaderMaterialData
	if trailShaderMaterialData == null :
		pass
	else:
		trailShaderMaterial = trailShaderMaterialData

func SetupEffects() -> void:
	if coreShaderMaterial:
		coreShaderSprite.material = coreShaderMaterial
		scaleTexture(coreShaderSprite, false)
		coreShaderSprite.z_index = 3

	if auraShaderMaterial:
		auraShaderSprite.material = auraShaderMaterial
		scaleTexture(auraShaderSprite, true)
		var offset = coreShaderSprite.texture.get_width() / 4;
		auraShaderSprite.offset = Vector2(0, (offset*-1.75));
		auraShaderSprite.z_index = 4
	
func scaleTexture(sprite: Sprite2D, extend: bool) -> void:
	var textureSize = sprite.texture.get_width()
	var scaleFactor = (projectileRadius*2) / textureSize
	if extend:
		sprite.scale = Vector2((scaleFactor*1.1), (scaleFactor*2.5))
	else:
		sprite.scale = Vector2(scaleFactor, scaleFactor)
