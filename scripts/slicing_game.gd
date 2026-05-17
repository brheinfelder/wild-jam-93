extends Node2D

@export var resource: inventoryResource
@onready var animatedRes: AnimatedSprite2D = $Node2D/Resource
@onready var progressBar: ProgressBar = $CanvasLayer/Panel/MarginContainer/ProgressBar
@onready var glow: PointLight2D = $Node2D/PointLight2D
@onready var line: Line2D = $Line2D
@onready var riseText: PackedScene = load("res://scenes/ui components/risingText.tscn")
@onready var slice: ColorRect = $Slice

var inputEnable = false

var invSlot: int
var gameScene: Node

var drawing: bool = false
var startPoint: Vector2 = Vector2.ZERO

var cutGoalStart: Vector2
var cutGoalEnd: Vector2

var maxError: float = 15

var gameFinished: bool = false

func _ready() -> void:
	maxError = maxError + gameStateManager.stats["CUT_ACCURACY"] * 10
	initResource()
	initCutGuide()
	inputEnable = true
	
func initCutGuide() -> void:
	$ProgressBar.rotation = 0
	$ProgressBar.global_position = animatedRes.global_position - $ProgressBar.size/2
	$ProgressBar.rotation = randf_range(0,TAU)
	cutGoalStart = $ProgressBar.get_global_transform() * Vector2(0, $ProgressBar.size.y/2)
	cutGoalEnd = $ProgressBar.get_global_transform() * Vector2($ProgressBar.size.x, $ProgressBar.size.y/2)

func evalCut() -> void:
	inputEnable = false
	$Line2D.visible = false
	slice.global_position = line.get_point_position(0)
	slice.rotation = (line.get_point_position(1) - line.get_point_position(0)).angle()
	slice.visible = true
	var animTimer = 0.0
	var animDuration = 0.2
	var cutLength := (line.get_point_position(1) - line.get_point_position(0)).length()
	while animTimer <= animDuration:
		var progress :float = animTimer/animDuration
		if progress <= 0.5:
			slice.size.x = lerp(0.0,cutLength,progress*2)
		else:
			slice.size.x = lerp(cutLength,0.0,(progress - 0.5)*2)
			slice.global_position = lerp(line.get_point_position(0), line.get_point_position(1), (progress - 0.5)*2)
			pass
		await get_tree().process_frame
		animTimer += get_process_delta_time()	
	slice.size.x = 0
	slice.visible = false
	var error := (line.get_point_position(0).distance_to(cutGoalStart) + line.get_point_position(1).distance_to(cutGoalEnd))/2
	var accuracy = clampf(1.0 - error / maxError, 0.0, 1.0)
	if accuracy <= 0.2:
		var text = riseText.instantiate() as Label
		text.content = "DO BETTER"
		text.color = Color(0.5,0,0,1)
		text.fontSize = 48
		text.visible = false
		add_child(text)
		await get_tree().process_frame
		text.global_position = get_viewport_rect().size/2 - text.get_minimum_size()/2 + Vector2(0,-100)
		text.visible = true
		pass
	elif accuracy <= 0.8:
		var text = riseText.instantiate() as Label
		text.content = "NICE"
		text.color = Color(200.0/255.0,0.5,0,1)
		text.fontSize = 48
		text.visible = false
		add_child(text)
		await get_tree().process_frame
		text.global_position = get_viewport_rect().size/2 - text.get_minimum_size()/2 + Vector2(0,-100)
		text.visible = true
		pass
	elif accuracy <= 1:
		var text = riseText.instantiate() as Label
		text.content = "PERFECT"
		text.color = Color(0.0,0.5,0,1)
		text.fontSize = 48
		text.visible = false
		add_child(text)
		await get_tree().process_frame
		text.global_position = get_viewport_rect().size/2 - text.get_minimum_size()/2 + Vector2(0,-100)
		text.visible = true
		pass
	progressBar.value += 100/3*accuracy
	initCutGuide()
	inputEnable = true

func initResource() -> void:
	animatedRes.sprite_frames = resource.sprite
	
func _process(delta: float) -> void:
	if drawing:
		line.set_point_position(1, get_global_mouse_position())
	if progressBar.value >= 100:
		gameFinished = true
		inputEnable = false
		await finishGame()
	if !gameFinished:
		progressBar.value -= delta

func finishGame() -> void:
	$Line2D.visible = false
	$ProgressBar.visible = false
	process_mode = PROCESS_MODE_DISABLED
	var endTimer = 0
	var endDuration = 0.5
	resource = resource.cut
	initResource()
	while endTimer <= endDuration:
		glow.energy = lerp(10,1,min(endTimer/endDuration,1))
		print(glow.energy)
		await get_tree().process_frame
		endTimer += get_process_delta_time()
	gameStateManager.inventory.setInvSlot(resource,invSlot)
	gameStateManager.sceneManager.sceneTransition(gameScene)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and inputEnable:
		if event.pressed:
			$Line2D.visible = true
			line.width = 4.0
			line.default_color = Color(1,1,1,0.1)
			drawing = true
			startPoint = get_global_mouse_position()
			line.clear_points()
			line.add_point(startPoint)
			line.add_point(startPoint)
		else:
			drawing = false
			line.set_point_position(1, get_global_mouse_position())
			evalCut()
		pass
