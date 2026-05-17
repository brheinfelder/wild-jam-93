extends Button

@onready var SHOP_SCREEN = load("res://scenes/shop_screen.tscn")

func _on_pressed() -> void:
	gameStateManager.sceneManager.sceneTransition(SHOP_SCREEN.instantiate())
