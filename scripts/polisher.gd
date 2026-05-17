extends Building

@onready var splittingGame: PackedScene = load("res://scenes/polishing_game.tscn")

func processResource(res: inventoryResource) -> bool:
	if !res:
		return false
	loadPolisherGame(res)
	return true
		
func loadPolisherGame(res: inventoryResource) -> void:
	var scene = splittingGame.instantiate()
	scene.resource = res
	scene.invSlot = gameStateManager.inventory.activeSlot
	scene.gameScene = gameStateManager.sceneManager.loadedScene
	gameStateManager.sceneManager.sceneTransition(scene, true, false)
