extends Sprite2D
@onready var tex_height = texture.get_height()
@onready var tex_width = texture.get_width()
@onready var cam: Camera2D = $"../../van/Camera2D"
@onready var signPos = global_position
func _physics_process(delta: float) -> void:
	var camPos = cam.global_position
	var dif_vector = (camPos - signPos).normalized()
	pass
