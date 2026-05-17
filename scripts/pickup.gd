extends Node2D

@export var crater: bool = false
var resource: inventoryResource
@onready var craterSprite: Sprite2D = $crater
@onready var pickupSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var light: PointLight2D = $PointLight2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var lifetime: float = 5.0
var time: float = 0

func _ready() -> void:
	craterSprite.visible = crater
	if crater:
		animation_player.play("flash")
	pickupSprite.sprite_frames = resource.sprite
	light.color = resource.color
	
func _process(delta: float) -> void:
	time+=delta
	var lifeProgress = clampf(time/lifetime,0,1)
	light.energy = lerp(2,0,lifeProgress)
	pickupSprite.modulate.a = clampf(inverse_lerp(1.0, 0.9,lifeProgress),0,1)
	craterSprite.modulate.a = clampf(inverse_lerp(1.0, 0.9,lifeProgress),0,1)
	if lifeProgress == 1.0:
		queue_free()
