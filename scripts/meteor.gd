extends Node2D

const animDuration = 1
var cam: Camera2D
var sprite: AnimatedSprite2D
var spawnOffset: Vector2
var spawnLight: PointLight2D
var state: String = "falling"
var lifetime: float = 5.0
@onready var collider := $Sprite2D/Area2D/CollisionShape2D
var meteor: MeteorType
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cam = get_tree().get_first_node_in_group("camera")
	sprite = $Sprite2D
	var viewSize = get_viewport().get_visible_rect().size/cam.zoom
	spawnOffset = Vector2(randf_range(-200,200),-viewSize.y-100)
	var angle = 45 - rad_to_deg(atan2(abs(spawnOffset.y),spawnOffset.x))
	sprite.rotation_degrees = angle
	spawnLight = $PointLight2D
	spawnLight.energy = 0.0
	spawnLight.visible = true
	sprite.sprite_frames = meteor.sprite
	sprite.play()
	sprite.position = spawnOffset
	sprite.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0

func _process(delta: float) -> void:
	spawnLight.color = meteor.color
	$Sprite2D/PointLight2D.color = meteor.color
	if state == "falling":
		time+=delta
		var progress = clampf(time/animDuration,0,1)
		spawnLight.energy = lerp(0.0,2.0,progress)
		sprite.position = spawnOffset.lerp(Vector2(0,0),progress)
		if progress >= 1.0:
			var pickup = meteor.invRes.spawn(true)
			pickup.global_position = global_position
			get_parent().add_child(pickup)
			queue_free()
