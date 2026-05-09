extends Node

# Globals
var inventory_size: int = 5
var inventoryItems: Array[inventoryResource] = []
var balance: int = 0

# References
var inventory: Node

func _ready() -> void:
	inventoryItems.resize(inventory_size)
