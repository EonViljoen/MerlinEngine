extends Node

@export var enemyScene: PackedScene
@export var enemyScript: Script

@export var enemiesPerWave: Array[Dictionary]
@export var waveIntermissionTimer: float = 10.0

var currentWave: int = 0
var enemyCount: int

@onready var enemySpawnPoints = get_tree().get_nodes_in_group("EnemySpawnLocation")

func _ready() -> void:
	SignalBus.enemyDeath.connect(_on_enemy_death)

	setupWave()
	
	await get_tree().create_timer(1.0).timeout
	SignalBus.displayHUDMessage.emit(str("Wave ", (currentWave+1)))

	
func startNextWave() -> void:
	currentWave += 1
	SignalBus.displayHUDMessage.emit(str("Wave ,", (currentWave+1)))
	setupWave()
	
func setupWave() -> void:	
	enemyCount = enemiesPerWave[currentWave].size()
	
	for i in enemyCount:
		randomize()
		var spawnPoint = enemySpawnPoints[randi() % enemySpawnPoints.size()]
		spawnEnemy(spawnPoint.global_position, enemiesPerWave[currentWave].get(i))
	

func spawnEnemy(spawnPoint: Vector2, enemyStat: CharacterStatResource):
	var enemyInstance = enemyScene.instantiate()
	
	enemyInstance.position = spawnPoint
	enemyInstance.set_script(enemyScript)
	enemyInstance.characterStats = enemyStat.duplicate()
	enemyInstance.z_index = 5
	enemyInstance.add_to_group("Targets")
	print("Enemy stat resource ID:", enemyInstance.characterStats.get_instance_id())

	await get_tree().current_scene.call_deferred("add_child", enemyInstance)
	
func _on_enemy_death(_enemy: RigidBody2D) -> void:
	enemyCount -= 1
	if enemyCount <= 0:
		SignalBus.displayHUDMessage.emit("Next Wave Incoming...")
		await get_tree().create_timer(3.0).timeout
		startNextWave()
