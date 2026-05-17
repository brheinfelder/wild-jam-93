extends Button

var game: PackedScene = load("res://scenes/game.tscn")
@onready var button: Button = $"."
var sceneManager = gameStateManager.sceneManager

func _ready() -> void:
	button.text = "Night "+str(gameStateManager.day + 1)+" ->"
	

func _on_pressed() -> void:
	gameStateManager.day += 1
	sceneManager.sceneTransition(game.instantiate())
