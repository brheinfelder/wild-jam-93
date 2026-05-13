extends SubViewportContainer

@export var spriteFrames: SpriteFrames
@export var badgeColor: Color

func _ready() -> void:
	init()

func init() -> void:
	if spriteFrames:
		$SubViewport/AnimatedSprite2D.sprite_frames = spriteFrames
		$SubViewport/AnimatedSprite2D.play()
	else:
		$SubViewport/AnimatedSprite2D.sprite_frames = null
		$SubViewport/AnimatedSprite2D.stop()
	if badgeColor:
		$Sprite2D.modulate = badgeColor
		$Sprite2D.visible = true
