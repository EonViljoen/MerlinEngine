extends RigidBody2D

@onready var polygon : Polygon2D = $Polygon2D
@onready var collission: CollisionShape2D = $CollisionShape2D
@onready var shaderSprite: Sprite2D = $ShaderSprite

@export var projectileRadius : float
@export var projectileEdgesInput: float

@onready var projectileEdges: float

@export var projectileCoreMaterial: ShaderMaterial
@export var projectileAuraMaterial: ShaderMaterial
@export var baseNoiseTexture: Texture2D

func _ready() -> void:
	projectileEdges = projectileEdgesInput + GlobalProjectileModifiers.modifier_resource.edgeCountMod
	create_circle(projectileRadius + GlobalProjectileModifiers.modifier_resource.sizeMod)
	
	if projectileAuraMaterial and projectileCoreMaterial:
		setupCoreMaterial()
		setupAuraMaterial()
	#setShader(load("res://resources/materials/fire2.tres"))

func create_circle(radius):
	var polyPoints = []
	
	for i in range(projectileEdges):
		var angle = i * (TAU / projectileEdges)
		polyPoints.append(Vector2(cos(angle) * radius, sin(angle) * radius))
	
	polygon.polygon = polyPoints

func setupCoreMaterial():
	var coreMaterial := projectileCoreMaterial.duplicate()
	coreMaterial.set_shader_parameter("noise_tex", baseNoiseTexture)
	coreMaterial.set_shader_parameter("fire_aperture", 0.18)
	coreMaterial.set_shader_parameter("fire_alpha", 1.0)
	polygon.material = coreMaterial
	polygon.z_index = 4

func setupAuraMaterial():
	var auraMaterial := projectileAuraMaterial.duplicate()
	auraMaterial.set_shader_parameter("noise_tex", baseNoiseTexture)
	auraMaterial.set_shader_parameter("fire_aperture", 0.18)
	auraMaterial.set_shader_parameter("fire_alpha", 1.0)
	shaderSprite.material = auraMaterial
	shaderSprite.scale = Vector2.ONE * (projectileRadius*3.0 / 512.0)
	shaderSprite.z_index = 3

#func generateNoiseTexture(width: int, height: int) -> ImageTexture:
	#var noise = FastNoiseLite.new()
	#noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	#noise.frequency = 0.02
	#
	#
	#var noiseImage = Image.create(width, height, false, Image.FORMAT_L8)
	#
	#for y in range(height):
		#for x in range(width):
			#var n= noise.get_noise_2d(x, y)
			#n = (n +1.0) * 0.5
			#noiseImage.set_pixel(x, y, Color(n, n, n))
			#
	#var texture = ImageTexture.create_from_image(noiseImage)
	#return texture

#func setShader(spellDataShaderMaterial: ShaderMaterial):
	#print(spellDataShaderMaterial)
	#polygon.material = spellDataShaderMaterial
	##var shader = load("res://resources/materials/fire2.tres")
	#
	##var shaderMaterial = ShaderMaterial.new()
	##shaderMaterial.shader = shader
	##shaderMaterial.set_shader_parameter("Noise Tex", generateNoiseTexture(512, 512))
	##polygon.material = shaderMaterial
	##get_parent().set_process_input(false)


	
