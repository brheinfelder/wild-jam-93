extends Node2D

@export var resource: inventoryResource
@onready var glow: PointLight2D = $Node2D/PointLight2D
@onready var animatedRes: AnimatedSprite2D = $Node2D/Resource
@onready var chisel: AnimatedSprite2D = $Node2D/Chisel
@onready var texture_rect: TextureRect = $CanvasLayer/Panel/MarginContainer/TextureRect
@onready var barDisplay: PanelContainer = $CanvasLayer/Panel/PanelContainer
@onready var barIndicator: PanelContainer = $CanvasLayer/Panel/PanelContainer2
@onready var riseText: PackedScene = load("res://scenes/ui components/risingText.tscn")

var invSlot: int
var gameScene: Node

var brightestFrame: int = 4
var redSize = 0.7
var yellowSize = 0.25
var greenSize = 0.05

var barRange: Vector2

var bar: float

var splitProgress: float = 0
var inputEnable: bool = false

func _ready() -> void:
	glow.color = resource.color
	prepareBar()
	await spawnThings()
	inputEnable = true
	gameStateManager.gameActive = true
	pass

var glowTime: float = 0.0
var barTime: float = 0.0

var endTimer = 0
var done = false

func prepareBar() -> void:
	var gradient := (texture_rect.texture as GradientTexture1D).gradient
	gradient = gradient.duplicate()
	(texture_rect.texture as GradientTexture1D).gradient = gradient
	greenSize = greenSize + gameStateManager.stats["SHARP_CHISEL"]*0.05
	var total = greenSize + redSize + yellowSize
	var redPortion = redSize/total
	var yellowPortion = yellowSize/total
	var greenPortion = greenSize/total
	gradient.set_offset(0,0.0)
	gradient.set_offset(1,redPortion/2)
	gradient.set_offset(2,redPortion/2 + yellowPortion/2)
	gradient.set_offset(3,0.5+greenPortion/2)
	gradient.set_offset(4,0.5+greenPortion/2+yellowPortion/2)
	barRange = Vector2(0,barDisplay.get_rect().size.x - barIndicator.get_rect().size.x/2)

func _process(delta: float) -> void:
	if splitProgress >= 1:
		inputEnable = false
		finishGame(delta)
	else:
		var frames := animatedRes.sprite_frames as SpriteFrames
		var frameCount := frames.get_frame_count("default")
		var speed := frames.get_animation_speed("default")
		var duration: float = frameCount / speed
		
		glowTime = fmod(glowTime + delta, duration)
		barTime = fmod(barTime + delta, duration * 2.0)
		var progress := glowTime/duration
		var barProgress := barTime/(duration*2.0)
		
		var peakProgress := brightestFrame/float(frameCount)
		var angle := (progress-peakProgress)*TAU
		var pulse := (cos(angle)+1.0)/2.0
		bar = triangleWave(barProgress - peakProgress)
		barIndicator.position.x = lerp(barRange.x, barRange.y, remap(bar,-1,1,0,1))
		glow.energy = lerp(1.0,2.0,pulse)
		
	
func spawnThings() -> void:
	initResource()
	await get_tree().create_timer(0.5).timeout
	chisel.visible = true
	chisel.play("chisel_spawn")
	await chisel.animation_finished
	chisel.play("hammer_spawn")
	await chisel.animation_finished
	pass
	
func initResource() -> void:
	animatedRes.sprite_frames = resource.sprite
	
func finishGame(delta: float) -> void:
	if done:
		return
	var duration = 0.5
	if endTimer == 0:
		resource = resource.split
		initResource()
	glow.energy = lerp(100,1,min(endTimer/duration,1))
	endTimer += delta
	if endTimer >= 0.5:
		done = true
		chisel.play_backwards("hammer_spawn")
		await chisel.animation_finished
		chisel.play_backwards("chisel_spawn")
		await chisel.animation_finished
		gameStateManager.inventory.setInvSlot(resource, invSlot)
		gameStateManager.sceneManager.sceneTransition(gameScene)
	
func triangleWave(t: float) -> float:
	return 2.0 * abs(t - floor(t + 0.5)) * 2.0 - 1.0
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and inputEnable:
		inputEnable = false
		chisel.play("hit")
		await waitForFrame(chisel,4)
		var val = abs((bar + 1)/2)
		var foldedValue = (1 - abs(bar))/2
		var gradient := (texture_rect.texture as GradientTexture1D).gradient
		var region := 0
		for i in (gradient.get_point_count() + 1) / 2:
			if foldedValue >= gradient.get_offset(i):
				region = i
		match region:
			0:
				var text = riseText.instantiate() as Label
				text.content = "DO BETTER"
				text.color = Color(0.5,0,0,1)
				text.fontSize = 48
				text.visible = false
				add_child(text)
				await get_tree().process_frame
				text.global_position = get_viewport_rect().size/2 - text.get_minimum_size()/2 + Vector2(0,-100)
				text.visible = true
				
				await chisel.animation_finished
				chisel.speed_scale = 5
				chisel.play_backwards("hammer_spawn")
				await chisel.animation_finished
				await get_tree().create_timer(1).timeout
				chisel.speed_scale = 1
				chisel.play("hammer_spawn")
				await chisel.animation_finished
				splitProgress += 0.2
				inputEnable = true
			1:
				var text = riseText.instantiate() as Label
				text.content = "NICE"
				text.color = Color(200.0/255.0,0.5,0,1)
				text.fontSize = 48
				text.visible = false
				add_child(text)
				await get_tree().process_frame
				text.global_position = get_viewport_rect().size/2 - text.get_minimum_size()/2 + Vector2(0,-100)
				text.visible = true
				
				await chisel.animation_finished
				splitProgress += 0.25
				inputEnable = true
			2:
				var text = riseText.instantiate() as Label
				text.content = "PERFECT"
				text.color = Color(0.0,0.5,0,1)
				text.fontSize = 48
				text.visible = false
				add_child(text)
				await get_tree().process_frame
				text.global_position = get_viewport_rect().size/2 - text.get_minimum_size()/2 + Vector2(0,-100)
				text.visible = true
				
				await chisel.animation_finished
				splitProgress += 1
				inputEnable = true
			_:
				inputEnable = true
		
		
		
func waitForFrame(sprite: AnimatedSprite2D, frame: int) -> void:
	while sprite.frame != frame:
		await get_tree().process_frame
