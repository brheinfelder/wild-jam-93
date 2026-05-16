extends Node2D

@onready var light: DirectionalLight2D = $DirectionalLight2D
var atmosphereGradient: Gradient = (load("res://assets/lighting/atmosphere.tres") as GradientTexture1D).gradient
var animTime: float = 2
@onready var animPlayer: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var screenText: Label = $CanvasLayer/Label
var nextScene: PackedScene = load("res://scenes/round_summary.tscn")

var operatingTimer : float = 0

func _ready() -> void:
	operatingTimer = 0
	if !gameStateManager.gameActive:
		startRound()
	pass

func _process(delta: float) -> void:
	if gameStateManager.gameActive:
		operatingTimer += delta
		if operatingTimer >= 5:
			operatingTimer = 0
			var cost = 4 + gameStateManager.day
			gameStateManager.balance -= cost
			gameStateManager.gameStats["operating"] -= cost
		var orderProgress = gameStateManager.orderManager.orderCount/gameStateManager.orderManager.maxOrders
		var activeOrders = gameStateManager.orderManager.orders.size()
		if orderProgress == 1 and activeOrders == 0:
			endRound()

func startRound() -> void:
	for key in gameStateManager.gameStats.keys():
		gameStateManager.gameStats[key] = 0
	gameStateManager.gameStats["previous"] = gameStateManager.balance
	process_mode = Node.PROCESS_MODE_DISABLED
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
	gameStateManager.orderManager.orderCount = 0
	gameStateManager.primaryUI.showUI()
	gameStateManager.gameActive = true
	process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().create_timer(1).timeout
	animPlayer.play("label_out")
	await animPlayer.animation_finished
	animPlayer.play("RESET")
	
func endRound() -> void:
	gameStateManager.gameActive = false
	gameStateManager.gameStats["total"] = gameStateManager.balance
	screenText.text = "Sunrise Comes..."
	sunrise()
	animPlayer.play("label_in")
	await animPlayer.animation_finished
	await get_tree().create_timer(1).timeout
	animPlayer.play("label_out")
	await animPlayer.animation_finished
	animPlayer.play("RESET")
	await gameStateManager.primaryUI.hideUI()
	gameStateManager.sceneManager.sceneTransition(nextScene)

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
