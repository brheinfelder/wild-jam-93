extends MarginContainer

@onready var board: VBoxContainer = $VBoxContainer
@export var bounties: Array[order]
var bountyCount: int = 5
@onready var bountyFlyer = load("res://scenes/ui components/bounty_posting.tscn")

func _ready() -> void:
	for orderChoice in gameStateManager.orderManager.cutOrderPool:
		var newOrder: order = orderChoice.duplicate()
		newOrder.resource.polished = true
		newOrder.resource.id += "Polished"
		newOrder.moneyGain *= 3
		newOrder.moneyLoss *= 4
		newOrder.time = int(newOrder.time/3)
		bounties.append(newOrder)
	pickBounties()

func pickBounties() -> void:
	var cumProb = 0
	for item in bounties:
		cumProb += item.probability
	for i in range(bountyCount):
		randomize()
		var prob = randf_range(0,cumProb)
		var chosenOrder: order = bounties.back()
		for order in bounties:
			prob -= order.probability
			if prob <= 0:
				chosenOrder = order
				break
		var bounty = bountyFlyer.instantiate()
		bounty.bounty = chosenOrder
		board.add_child(bounty)
	
