extends Node2D

@onready var startButton: Button = $Control/VBoxContainer/Button
@export var nextScene: PackedScene

func _on_button_pressed() -> void:
	gameStateManager.sceneManager.sceneTransition(nextScene, true)
