extends Node2D

@onready var shade : AnimationPlayer = $CanvasLayer/ColorRect/AnimationPlayer
@onready var loadedScene: Node = $LoadedScene

func _ready() -> void:
	gameStateManager.sceneManager = self

func sceneTransition(scene: PackedScene, transitionAnimation: bool = true) -> void:
	if transitionAnimation:
		shade.play("show_shade")
	var newScene = scene.instantiate()
	newScene.process_mode = Node.PROCESS_MODE_DISABLED
	newScene.name = "LoadedScene"
	if transitionAnimation:
		await shade.animation_finished
	add_child(newScene)
	loadedScene.queue_free()
	loadedScene = newScene
	if transitionAnimation:
		shade.play("hide_shade")
		await shade.animation_finished
	loadedScene.process_mode = Node.PROCESS_MODE_INHERIT
	pass
