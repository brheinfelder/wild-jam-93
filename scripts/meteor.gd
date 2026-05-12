extends Node2D

const animDuration = 1
var cam: Camera2D
var sprite: AnimatedSprite2D
var spawnOffset: Vector2
var spawnLight: PointLight2D
var state: String = "falling"
var lifetime: float = 5.0
@onready var collider := $Sprite2D/Area2D/CollisionShape2D
var resource: inventoryResource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam = $"../van/Camera2D"
	sprite = $Sprite2D
	var viewSize = get_viewport().get_visible_rect().size/cam.zoom
	spawnOffset = Vector2(randf_range(-200,200),-viewSize.y-100)
	var angle = 45 - rad_to_deg(atan2(abs(spawnOffset.y),spawnOffset.x))
	sprite.rotation_degrees = angle
	spawnLight = $PointLight2D
	spawnLight.energy = 0.0
	spawnLight.visible = true
	sprite.position = spawnOffset
	sprite.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0

func _process(delta: float) -> void:
	if state == "falling":
		time+=delta
		var progress = clampf(time/animDuration,0,1)
		spawnLight.energy = lerp(0.0,1.0,progress)
		sprite.position = spawnOffset.lerp(Vector2(0,0),progress)
		if progress == 1.0:
			time = 0
			state = "landed"
	if state == "landed":
		$Sprite2D/Area2D.add_to_group("pickup")
		time+=delta
		var lifeProgress = clampf(time/lifetime,0,1)
		spawnLight.energy = lerp(1,0,lifeProgress)
		$Sprite2D/PointLight2D.energy = lerp(1.0,0.2,lifeProgress)
		sprite.modulate.a = clampf(inverse_lerp(1.0, 0.9,lifeProgress),0,1)
		if lifeProgress == 1.0:
			queue_free()
