extends Node

# Globals
var inventoryItems: Array[inventoryResource] = []
var balance: int = 0
var seed: int

# References
var inventory: Node
var orderManager: Node
var primaryUI: Node
var sceneManager: Node
var biomeManager: Node
var player: Node

#GameState
var gameActive: bool = false
var day: int = 1

# Stats
var stats := {
	"TRUCK_SPEED": 0,
	"TRUCK_ACCEL": 0,
	"INVENTORY": 0,
	"SHARP_CHISEL": 0
}

var gameStats := {
	"previous": 0,
	"gains": 0,
	"losses": 0,
	"damages": 0,
	"operating": 0,
	"total": 0
}

var unlocks := {
	"cracking": false,
	"slicing": false,
	"polishing": false
}

func _ready() -> void:
	inventoryItems.resize(stats["INVENTORY"]+3)
