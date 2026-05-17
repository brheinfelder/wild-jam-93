extends VBoxContainer

var currentInventory := gameStateManager.inventoryItems
var slotSize: int = 50
var inventorySlots: Array[Panel] = []
var activeSlot: int = 0
var spriteDisplay: PackedScene = load("res://scenes/ui components/spriteDisplay.tscn")

@onready var selectedSlot: PanelContainer = $SelectedSlot
@onready var hotbar := $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameStateManager.inventory = $"."
	inventorySlots.resize(gameStateManager.stats["INVENTORY"]+3)
	for i in gameStateManager.stats["INVENTORY"]+3:
		var slot := Panel.new()
		slot.custom_minimum_size = Vector2(slotSize,slotSize)
		hotbar.add_child(slot)
		
		var icon := spriteDisplay.instantiate()
		slot.add_child(icon)
		
		inventorySlots[i] = slot
		redrawSlot(i)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentInventory != gameStateManager.inventoryItems:
		gameStateManager.inventoryItems = currentInventory
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("cycle_slot_up"):
		cycle_slot(-1)
	elif event.is_action_pressed("cycle_slot_down"):
		cycle_slot(1)

func cycle_slot(dif: int) -> void:
	var oldSlot = activeSlot
	activeSlot = wrapi(activeSlot+dif,0,gameStateManager.stats["INVENTORY"]+3)
	redrawSlot(activeSlot)
	redrawSlot(oldSlot)

func setInvSlot(item: inventoryResource, slot: int) -> void:
	if currentInventory[slot]:
		var droppedItem = currentInventory[slot].spawn()
		droppedItem.global_position = gameStateManager.player.global_position
		gameStateManager.sceneManager.loadedScene.add_child(droppedItem)
	currentInventory[slot] = item
	redrawSlot(slot)
	
func getInvSlot(slot: int) -> inventoryResource:
	return currentInventory[slot]
	
func eraseSlot(slot: int) -> void:
	currentInventory[slot] = null
	redrawSlot(slot)
	
func denyInteraction(slot: int) -> void:
	var animController: AnimationPlayer = inventorySlots[slot].get_child(0).get_node("AnimationPlayer")
	animController.play("deny_interaction")
	
func redrawSlot(slot: int) -> void:
	inventorySlots[slot].remove_theme_stylebox_override("panel")
	var slotSprite: Control = inventorySlots[slot].get_child(0)
	if currentInventory[slot]:
		slotSprite.spriteFrames = currentInventory[slot].sprite
		slotSprite.badgeColor = currentInventory[slot].color
		slotSprite.init()
	else:
		slotSprite.spriteFrames = null
		slotSprite.badgeColor = Color(0,0,0,0)
		slotSprite.init()
		pass
	if slot == activeSlot:
		selectedSlot.reparent(inventorySlots[slot], false)
		#var style := (inventorySlots[slot].get_theme_stylebox("panel") as StyleBoxFlat).duplicate()
		#style.bg_color += Color(0.2,0.2,0.2,0)
		#inventorySlots[slot].add_theme_stylebox_override("panel", style)
