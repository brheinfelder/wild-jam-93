extends Node

# Globals
var inventory_size: int = 3
var inventoryItems: Array[inventoryResource] = []
var balance: int = 0

# References
var inventory: Node
var orderManager: Node
var primaryUI: Node
var sceneManager: Node

#GameState
var gameActive: bool = false
var day: int = 1

func _ready() -> void:
	inventoryItems.resize(inventory_size)
