extends Node2D

@onready var light: DirectionalLight2D = $DirectionalLight2D
var atmosphereGradient: Gradient = (load("res://assets/lighting/atmosphere.tres") as GradientTexture1D).gradient
var animTime: float = 2
@onready var animPlayer: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var screenText: Label = $CanvasLayer/Label

func _ready() -> void:
	if !gameStateManager.gameActive:
		startRound()
	pass

func _process(delta: float) -> void:
	var orderProgress = gameStateManager.orderManager.orderCount/gameStateManager.orderManager.maxOrders
	var activeOrders = gameStateManager.orderManager.orders.size()
	if orderProgress == 1 and activeOrders == 0 and gameStateManager.gameActive:
		endRound()

func startRound() -> void:
	sunset()
	screenText.text = "Night " + str(gameStateManager.day) + "\nTime to collect..."
	animPlayer.play("label_in")
	await animPlayer.animation_finished
	await get_tree().create_timer(animTime/2 - 0.4).timeout
	animPlayer.play("label_out")
	await animPlayer.animation_finished
	animPlayer.play("RESET")
	await get_tree().create_timer(animTime - (animTime/2 - 0.4)).timeout
	screenText.text = "GO!"
	animPlayer.play("label_in")
	gameStateManager.primaryUI.showUI()
	gameStateManager.gameActive = true
	await get_tree().create_timer(1).timeout
	animPlayer.play("label_out")
	await animPlayer.animation_finished
	animPlayer.play("RESET")
	
func endRound() -> void:
	gameStateManager.gameActive = false
	screenText.text = "Sunrise Comes..."
	sunrise()
	animPlayer.play("label_in")
	await animPlayer.animation_finished
	await get_tree().create_timer(1).timeout
	animPlayer.play("label_out")
	await animPlayer.animation_finished
	animPlayer.play("RESET")
	await gameStateManager.primaryUI.hideUI()

func sunset() -> void:
	var time: float = 0
	while time < animTime:
		time += get_process_delta_time()
		var progress = time/animTime
		light.color = atmosphereGradient.sample(1-progress)
		await get_tree().process_frame

func sunrise() -> void:
	var time: float = 0
	while time < animTime:
		time += get_process_delta_time()
		var progress = time/animTime
		light.color = atmosphereGradient.sample(progress)
		await get_tree().process_frame
