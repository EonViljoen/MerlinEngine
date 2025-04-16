extends "res://scripts/character.gd"

@export var isDummy: bool
@export var activeTarget: bool = true
@export var shooting: bool = false

#@export var enemyProjectile = preload("res://resources/spells/basic_bolt.tres")
#@export var enemyProjectileTimer: float = 1.0
#@export var enemyProjectileTimerRandomRange: float = 10.0
@export var enemyProjectile: SpellDataResource
@export var enemyProjectileTimer: float
@export var enemyProjectileTimerRandomRange: float

func _ready() -> void:
	SignalBus.enemyDeath.connect(_on_enemy_death)
	contact_monitor = true
	
	super.setCharacterAnimation("idle")
	
	
	
	#shootProjectile()

func take_damage(amount):
	characterHealthBar.visible = true
	SignalBus.enemyDamage.emit(amount)
	super.take_damage(amount)
	
	if characterStats.currentHealthAmount < 0:
		SignalBus.enemyDeath.emit(self)
	
func shootProjectile():
	if !characterStats.characterSpriteDirectory == "dummy":
		if shooting:
			var target = get_tree().get_first_node_in_group("Player")
			randomize()
			var enemyShotTimer = get_tree().create_timer(randf_range(enemyProjectileTimer, enemyProjectileTimer + enemyProjectileTimerRandomRange)) # Maybe revise
			
			enemyShotTimer.timeout.connect(
				func(): 
					var projectile = enemyProjectile.spellScene.instantiate()
					projectile.target = "Player"
					projectile.spellData = enemyProjectile
					projectile.dest = Vector2(target.global_position.x, target.global_position.y)
					
					self.add_child(projectile)
					shootProjectile()
					)

func is_target():
	if activeTarget:
		return self

func _on_enemy_death(enemy: RigidBody2D) -> void:
	super.die(enemy)
