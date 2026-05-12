extends Sprite2D
@onready var tex_height = texture.get_height()
@onready var tex_width = texture.get_width()
@onready var cam: Camera2D = $"../../van/Camera2D"
@onready var signPos = global_position
@onready var canvas_modulate: CanvasModulate = $"../../CanvasModulate"
@onready var worldLight: DirectionalLight2D = $"../../DirectionalLight2D"
var lightDistance: float = 100.0

func _physics_process(_delta: float) -> void:
	var camPos = cam.get_screen_center_position()
	var viewSize = get_viewport().get_visible_rect().size/cam.zoom
	global_position = clampVector(camPos, signPos, viewSize - Vector2(tex_width*scale.x,tex_height*scale.y))
	updateVisuals(signPos)
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
	
func updateVisuals(world_pos: Vector2) -> void:
	var distance = (world_pos - global_position).length()
	var progress = clampf(distance/lightDistance,0.0,1.0)
	var brightness = smoothstep(1.0,0.0,progress)
	var night_color := worldLight.color * worldLight.energy
	var inverse := Color(1.0 / night_color.r, 1.0 / night_color.g, 1.0 / night_color.b)
	modulate = inverse.lerp(Color.DARK_GRAY, brightness)
	scale = Vector2(1.0,1.0) * lerp(1.0,1.5,1-brightness)
	if progress>0:
		light_mask = 10
	else:
		light_mask = 1
	pass
