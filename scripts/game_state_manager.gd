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
	"SHARP_CHISEL": 0,
	"POLISHING_SPEED":0,
	"CUT_ACCURACY":0
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
	
func reset() -> void:
	gameActive = false
	day = 1
	stats["TRUCK_SPEED"] = 0
	stats["TRUCK_ACCEL"] = 0
	stats["INVENTORY"] = 0
	stats["SHARP_CHISEL"] = 0
	stats["POLISHING_SPEED"] = 0
	stats["CUT_ACCURACY"] = 0
	unlocks["cracking"] = false
	unlocks["slicing"] = false
	unlocks["polishing"] = false
