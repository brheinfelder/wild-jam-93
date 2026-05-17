extends Building

@onready var slicingGame: PackedScene = load("res://scenes/slicing_game.tscn")

func processResource(res: inventoryResource) -> bool:
	if !res:
		return false
	if res.cut:
		loadSlicingGame(res)
		return true
	else:
		return false
		
func loadSlicingGame(res: inventoryResource) -> void:
	var scene = slicingGame.instantiate()
	scene.resource = res
	scene.invSlot = gameStateManager.inventory.activeSlot
	scene.gameScene = gameStateManager.sceneManager.loadedScene
	gameStateManager.sceneManager.sceneTransition(scene, true, false)
