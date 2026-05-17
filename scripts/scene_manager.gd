extends Node2D

@onready var shade : AnimationPlayer = $CanvasLayer/ColorRect/AnimationPlayer
@onready var loadedScene: Node = $LoadedScene

func _ready() -> void:
	gameStateManager.sceneManager = self

func sceneTransition(scene: Node, transitionAnimation: bool = true, freeQueue = true) -> void:
	if transitionAnimation:
		shade.play("show_shade")
	scene.process_mode = Node.PROCESS_MODE_DISABLED
	scene.name = "LoadedScene"
	if transitionAnimation:
		await shade.animation_finished
	await get_tree().create_timer(1).timeout
	add_child(scene)
	if freeQueue:
		loadedScene.queue_free()
	else:
		remove_child(loadedScene)
	loadedScene = scene
	if transitionAnimation:
		shade.play("hide_shade")
		await shade.animation_finished
	loadedScene.process_mode = Node.PROCESS_MODE_INHERIT
	pass
