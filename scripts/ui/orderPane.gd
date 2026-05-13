extends Node

var orderResource: order
@onready var timer: ProgressBar = $Panel/timer
@onready var gradient: Gradient = (load("res://assets/ui/progress.tres") as GradientTexture1D).gradient
@onready var gain: Label = $Panel/Control/gain
@onready var loss: Label = $Panel/Control/loss
@onready var icon: SubViewportContainer = $Panel/SubViewportContainer
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var failLabel: Label = $Fail/Label
@onready var successLabel: Label = $Success/Label
var active: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !orderResource.remainingTime:
		orderResource.remainingTime = orderResource.time
	gain.text = str(orderResource.moneyGain)
	loss.text = str(orderResource.moneyLoss)
	icon.spriteFrames = orderResource.resource.sprite
	icon.badgeColor = orderResource.resource.color
	$Panel/BountyBorder.visible = orderResource.bounty
	icon.init()
	anim.play("RESET")
	anim.play("new_order")
	failLabel.text = "-"+str(orderResource.moneyLoss)
	successLabel.text = "+"+str(orderResource.moneyGain)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if gameStateManager.gameActive and active:
		orderResource.remainingTime -= delta
	var progress = clampf(orderResource.remainingTime / float(orderResource.time),0.0,1.0)
	timer.value = progress
	var fill: StyleBoxFlat = timer.get_theme_stylebox("fill").duplicate()
	fill.bg_color = gradient.sample(progress)
	timer.add_theme_stylebox_override("fill", fill)
	if orderResource.remainingTime <= 0 and active:
		active = false
		orderFailed()
	pass

func orderSuccess() -> void:
	active = false
	print("Order success! +"+str(orderResource.moneyGain))
	gameStateManager.orderManager.orders.erase(self)
	gameStateManager.balance += orderResource.moneyGain
	anim.play("pass_order")
	await anim.animation_finished
	anim.play("shrink")
	await anim.animation_finished
	queue_free()
	
func orderFailed() -> void:
	print("Order failed! -"+str(orderResource.moneyLoss))
	gameStateManager.orderManager.orders.erase(self)
	gameStateManager.balance -= orderResource.moneyLoss
	anim.play("fail_order")
	await anim.animation_finished
	anim.play("shrink")
	await anim.animation_finished
	queue_free()
