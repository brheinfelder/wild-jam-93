extends Building

@onready var splittingGame: PackedScene = load("res://scenes/splitting_game.tscn")

func processResource(res: inventoryResource) -> bool:
	if !res:
		return false
	if res.split:
		loadSplitterGame(res)
		return true
	else:
		return false
		
func loadSplitterGame(res: inventoryResource) -> void:
	var scene = splittingGame.instantiate()
	scene.resource = res
	scene.invSlot = gameStateManager.inventory.activeSlot
	scene.gameScene = gameStateManager.sceneManager.loadedScene
	gameStateManager.sceneManager.sceneTransition(scene, true, false)
