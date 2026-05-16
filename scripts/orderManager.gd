extends VBoxContainer

var orders: Array[Node] = []
var orderScene: PackedScene = load("res://scenes/ui components/order.tscn")
@export var orderPool: Array[order] = []
var maxOrders: int = 1
var maxDisplayOrders: int = 8
var orderCount: int
var orderGenChance: float = 0.3
var orderGenDelay: float = 1
var orderTimer: float

func _ready() -> void:
	gameStateManager.orderManager = $"."
	
func _process(delta: float) -> void:
	if gameStateManager.gameActive:
		orderTimer += delta
	if orderTimer >= orderGenDelay and orderCount < maxOrders and orders.size() < maxDisplayOrders:
		orderTimer = 0
		if randf() <= orderGenChance:
			createNewOrder()
	
func createNewOrder() -> void:
	var choice = randi_range(0,orderPool.size() - 1)
	var newOrder = orderScene.instantiate()
	newOrder.orderResource = orderPool[choice].duplicate()
	orders.append(newOrder)
	add_child(newOrder)
	orderCount += 1
	pass
