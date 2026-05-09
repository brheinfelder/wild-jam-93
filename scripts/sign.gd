extends Sprite2D
@onready var tex_height = texture.get_height()
@onready var tex_width = texture.get_width()
@onready var cam: Camera2D = $"../../van/Camera2D"
@onready var signPos = global_position

func _physics_process(delta: float) -> void:
	var camPos = cam.get_screen_center_position()
	var viewSize = get_viewport().get_visible_rect().size/cam.zoom
	global_position = clampVector(camPos, signPos, viewSize - Vector2(tex_width,tex_height))
	return
	
func clampVector(camera_pos: Vector2, world_pos: Vector2, view_size: Vector2) -> Vector2:
	var direction := world_pos - camera_pos
	var half_view := view_size / 2
	if abs(direction.x) <= half_view.x and abs(direction.y) <= half_view.y:
		return world_pos
		
	var t := INF
	if direction.x != 0.0:
		t = minf(t, half_view.x/abs(direction.x))
	if direction.y != 0.0:
		t = minf(t, half_view.y/abs(direction.y))
		
	return camera_pos + direction*t
