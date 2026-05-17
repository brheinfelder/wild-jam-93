extends Control

@export var bounty: order
@onready var quote: Label = $Panel/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Quote
@onready var author: Label = $Panel/MarginContainer/HBoxContainer/MarginContainer/VBoxContainer/Author
@onready var gain: Label = $Panel/MarginContainer/VBoxContainer2/Control/gain
@onready var loss: Label = $Panel/MarginContainer/VBoxContainer2/Control/loss
@onready var time: Label = $Panel/MarginContainer/VBoxContainer2/Time


func _ready() -> void:
	if bounty.quote:
		quote.text = "\"" + bounty.quote + "\""
	if bounty.author:
		author.text = "-"+bounty.author
	gain.text = str(bounty.moneyGain)
	loss.text = str(bounty.moneyLoss)
	$Panel/MarginContainer/HBoxContainer/Panel/SubViewportContainer.spriteFrames = bounty.resource.sprite
	if bounty.resource.color:
		$Panel/MarginContainer/HBoxContainer/Panel/SubViewportContainer.badgeColor = bounty.resource.color
	$Panel/MarginContainer/HBoxContainer/Panel/SubViewportContainer.polishOverlay = bounty.resource.polished
	$Panel/MarginContainer/HBoxContainer/Panel/SubViewportContainer.init()
	time.text = str(bounty.time) + " sec"
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			gameStateManager.orderManager.addBounty(bounty)
			queue_free()
