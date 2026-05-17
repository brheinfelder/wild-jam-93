extends Node2D

@export var resource: inventoryResource
var keys: Array[String] = ["W", "A", "S", "D"]
var actionNames: Array[String] = ["move_up","move_left","move_down","move_right"]
var angles: Array[float] = [90,180,270,0]
var clothOffset: float = 50
var currentPosition: int
var direction: int
var angle: float
var speed: float
var animDuration: float = 0.1
var inputEnable = false
var animTimer: float = 0
var gameFinished: bool = false
@onready var cloth: Sprite2D = $Cloth
@onready var animatedRes: AnimatedSprite2D = $Node2D/Resource
@onready var progressBar: ProgressBar = $CanvasLayer/Panel/MarginContainer/ProgressBar
@onready var glow: PointLight2D = $Node2D/PointLight2D

var invSlot: int
var gameScene: Node

func _ready() -> void:
	initResource()
	currentPosition = randi_range(0,3)
	direction = [-1,1][randi_range(0,1)]
	angle = deg_to_rad(angles[wrap(currentPosition-direction,0,4)])
	speed = 10 + gameStateManager.stats["POLISHING_SPEED"]*10
	setState(currentPosition)
	cloth.global_position = animatedRes.global_position + Vector2(cos(angle),-sin(angle))*clothOffset
	glow.energy = 0
	glow.color = Color.WHITE
	inputEnable = true
	
func initResource() -> void:
	animatedRes.sprite_frames = resource.sprite
	
func _process(delta: float) -> void:
	if progressBar.value >= 100:
		gameFinished = true
		inputEnable = false
		await finishGame()
	if !gameFinished:
		progressBar.value -= delta
		
func finishGame() -> void:
	cloth.visible = false
	process_mode = PROCESS_MODE_DISABLED
	var endTimer = 0
	var endDuration = 0.5
	var newResource = resource.duplicate()
	newResource.polished = true
	newResource.id = newResource.id + "Polished"
	resource = newResource
	initResource()
	$PolishOverlay.visible = true
	while endTimer <= endDuration:
		glow.energy = lerp(10,1,min(endTimer/endDuration,1))
		print(glow.energy)
		await get_tree().process_frame
		endTimer += get_process_delta_time()
	gameStateManager.inventory.setInvSlot(resource,invSlot)
	gameStateManager.sceneManager.sceneTransition(gameScene)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(actionNames[currentPosition]) and inputEnable:
		inputEnable = false
		currentPosition = wrap(currentPosition+direction,0,4)
		setState(currentPosition)
		await animateCloth()
		print(currentPosition)
		inputEnable = true
		pass

func setState(index: int) -> void:
	$W.visible = false
	$A.visible = false
	$S.visible = false
	$D.visible = false
	match keys[index]:
		"W":
			$W.visible = true
		"A":
			$A.visible = true
		"S":
			$S.visible = true
		"D":
			$D.visible = true
			
func animateCloth() -> void:
	var animTimer = 0;
	var currentAngle = angle
	var newAngle = deg_to_rad(rad_to_deg(angle) + 90*direction)
	var currentProgress = $CanvasLayer/Panel/MarginContainer/ProgressBar.value
	var newProgress = currentProgress + speed/4
	while animTimer < animDuration:
		var progress = animTimer/animDuration
		var placementAngle = lerp(currentAngle, newAngle, progress)
		var polishProgress = lerp(currentProgress,newProgress,progress)
		$CanvasLayer/Panel/MarginContainer/ProgressBar.value = polishProgress
		cloth.global_position = animatedRes.global_position + Vector2(cos(placementAngle),-sin(placementAngle))*clothOffset
		await get_tree().process_frame
		animTimer += get_process_delta_time()
	angle = newAngle
	
