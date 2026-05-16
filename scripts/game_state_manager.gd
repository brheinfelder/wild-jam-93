extends Node

# Globals
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

# Stats
var stats := {
	"TRUCK_SPEED": 0,
	"TRUCK_ACCEL": 0,
	"INVENTORY": 0
}

var gameStats := {
	"previous": 0,
	"gains": 0,
	"losses": 0,
	"damages": 0,
	"operating": 0,
	"total": 0
}

func _ready() -> void:
	inventoryItems.resize(stats["INVENTORY"]+3)
