extends VBoxContainer

var orders: Array[Node] = []
var bounties: Array[Node] = []
var orderScene: PackedScene = load("res://scenes/ui components/order.tscn")
var orderPool: Array[order] = []
@export var meteorOrderPool: Array[order] = []
@export var splitOrderPool: Array[order] = []
@export var cutOrderPool: Array[order] = []
var maxOrders: int = 10
var maxDisplayOrders: int = 8
var orderCount: int
var orderGenChance: float = 0.3
var orderGenDelay: float = 1
var orderTimer: float

func _ready() -> void:
	maxOrders += (gameStateManager.day-1)*5
	gameStateManager.orderManager = $"."
	orderPool += meteorOrderPool
	if gameStateManager.unlocks["cracking"]:
		orderPool += splitOrderPool
	if gameStateManager.unlocks["slicing"]:
		orderPool += cutOrderPool

func _process(delta: float) -> void:
	if gameStateManager.gameActive:
		orderTimer += delta
	if orderTimer >= orderGenDelay and orderCount < maxOrders and orders.size() < maxDisplayOrders:
		orderTimer = 0
		if randf() <= orderGenChance:
			createNewOrder()
	
func createNewOrder() -> void:
	randomize()
	var cumProb: float = 0
	for order in orderPool:
		cumProb += order.probability
	var prob = randf_range(0,cumProb)
	var chosenOrder: order = orderPool.back()
	for order in orderPool:
		prob -= order.probability
		if prob <= 0:
			chosenOrder = order
			break
	var newOrder = orderScene.instantiate()
	newOrder.orderResource = chosenOrder.duplicate()
	if randi_range(0,1) > 0 and gameStateManager.unlocks["polishing"]:
		var newResource = newOrder.orderResource.resource.duplicate()
		newResource.polished = true
		newResource.id += "Polished"
		newResource.gain *= 2
		newOrder.orderResource.resource = newResource
	orders.append(newOrder)
	add_child(newOrder)
	orderCount += 1
	pass
	
func addBounty(bounty: order) -> void:
	var newOrder = orderScene.instantiate()
	newOrder.orderResource = bounty
	bounties.append(newOrder)
	add_child(newOrder)
	move_child(newOrder,0)
