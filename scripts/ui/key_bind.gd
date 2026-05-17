extends CenterContainer

@export var keybind: String = "E"
@export var pulse: bool = false
@export var bindScale: int = 1

func _ready() -> void:
	$Node2D/Label.text = keybind
	if !pulse:
		$AnimationPlayer.stop()
	var settings: LabelSettings = LabelSettings.new()
	settings.font_size = 16.0*bindScale
	$Node2D/Label.label_settings = settings
	$Node2D.custom_minimum_size = Vector2(1.0,1.0)*(16.0*bindScale+4.0)
