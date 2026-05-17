extends Node2D

@export var meteorPool: Array[MeteorType] = []
@export var spawn_radius_min := 50
@export var spawn_radius_max := 400
@export var meteor_scene: PackedScene
@export var spawn_interval := 1
@onready var player: Node2D = $".."
var _timer := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !gameStateManager.gameActive:
		return
		
	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		spawnMeteor(1)
	pass

func spawnMeteor(i: int) -> void:
	if i > 3:
		return
	var angle := randf() * TAU
	var dist  := randf_range(spawn_radius_min, spawn_radius_max)
	var land_pos := player.global_position + Vector2(cos(angle), sin(angle)) * dist
	
	var meteor: Node2D = meteor_scene.instantiate()
	var spawnBiome: Biome = gameStateManager.biomeManager.getTileBiome(gameStateManager.biomeManager.toTileSpace(land_pos))
	var selectedMeteor: MeteorType = spawnBiome.randomMeteor()
	if !selectedMeteor:
		spawnMeteor(i+1)
		return
	meteor.meteor = selectedMeteor
	gameStateManager.sceneManager.loadedScene.add_child(meteor)
	meteor.global_position = land_pos
