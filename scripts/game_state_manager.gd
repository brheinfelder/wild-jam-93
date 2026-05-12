extends Node

# Globals
var inventory_size: int = 3
var inventoryItems: Array[inventoryResource] = []
var balance: int = 0

# References
var inventory: Node
var orderManager: Node

#GameState
var gameActive: bool = true

func _ready() -> void:
	inventoryItems.resize(inventory_size)
