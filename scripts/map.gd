extends Node2D
const TILESIZEX := 32
const TILESIZEY := 32
var last_cam_tile := Vector2(INF, INF)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@onready var camera: Camera2D = $"../van/Camera2D"
@onready var map = $"."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var cam_tile := Vector2(floor(camera.get_screen_center_position().x/TILESIZEX),floor(camera.get_screen_center_position().y/TILESIZEY))
	if cam_tile != last_cam_tile:
		last_cam_tile = cam_tile
		map.global_position = Vector2(cam_tile.x*TILESIZEX,cam_tile.y*TILESIZEY)
	pass
