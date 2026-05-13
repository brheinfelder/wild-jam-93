extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	gameStateManager.primaryUI = self

func showUI() -> void:
	anim.play_backwards("hide")
	await anim.animation_finished
	pass

func hideUI() -> void:
	anim.play("hide")
	await anim.animation_finished
	pass
