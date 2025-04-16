extends RigidBody2D
class_name Character

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var characterHealthBar: TextureProgressBar = $CharacterHealthBar
@export var characterStats: CharacterStatResource

func setCharacterAnimation(animationName: String) -> void:
	sprite.sprite_frames = characterStats.characterSpriteFrames
	sprite.animation = animationName

func take_damage(amount) -> void:
	characterStats.currentHealthAmount -= amount
	characterHealthBar.value = (characterStats.currentHealthAmount * 100) / characterStats.maxHealthAmount
	characterStats.currentHealthAmount -= amount

func die(character: RigidBody2D) -> void:
	if character == self:
		queue_free()
