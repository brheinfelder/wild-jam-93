extends CanvasLayer
const MENU = preload("uid://c78bdy8risevo")

func _ready() -> void:
	if gameStateManager.balance <= 0:
		$Label.text = "YOU LOSE!"
	else:
		$Label.text = "YOU WIN! CONGRATULATIONS"
	await get_tree().create_timer(3).timeout
	gameStateManager.sceneManager.sceneTransition(MENU.instantiate())
