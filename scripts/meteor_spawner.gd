extends Node2D

@export var spawn_radius_min := 50
@export var spawn_radius_max := 400
@export var meteor_scene: PackedScene
@export var spawn_interval := 2
@onready var player: Node2D = $".."
var _timer := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		_spawn_meteor()
	pass

func _spawn_meteor() -> void:
	var angle := randf() * TAU
	var dist  := randf_range(spawn_radius_min, spawn_radius_max)
	var land_pos := player.global_position + Vector2(cos(angle), sin(angle)) * dist
	
	var meteor: Node2D = meteor_scene.instantiate()
	get_tree().current_scene.add_child(meteor)
	meteor.global_position = land_pos
