extends Label

@export var color: Color = Color.WHITE
@export var fontSize: int = 16
@export var content: String = "text"
var animDuration: float = 1
var distance: float = -50
var timer: float = 0
var speed: float

func _ready() -> void:
	speed = distance/animDuration
	text = content.to_upper()
	var settings: LabelSettings = label_settings.duplicate()
	settings.font_size = fontSize
	settings.font_color = color
	label_settings = settings
	pass
	
func _process(delta: float) -> void:
	timer += delta
	position.y += speed*delta
	if timer >= animDuration - 0.1:
		var progress = inverse_lerp(animDuration, animDuration-0.1, timer)
		modulate.a = lerp(0,1,progress)
		pass
	if timer >= animDuration:
		queue_free()
	pass
