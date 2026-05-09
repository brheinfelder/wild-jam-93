extends Node2D

const animDuration = 0.5
var cam: Camera2D
var sprite: Sprite2D
var spawnOffset: Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam = $"../van/Camera2D"
	sprite = $Sprite2D
	var viewSize = get_viewport().get_visible_rect().size/cam.zoom
	spawnOffset = Vector2(randf_range(-100,100),-viewSize.y-100)
	sprite.position = spawnOffset
	sprite.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0
func _process(delta: float) -> void:
	time+=delta
	var progress = clampf(time/animDuration,0,1)
	sprite.position = spawnOffset.lerp(Vector2(0,0),progress)
	pass
