extends HBoxContainer

var currentInventory := gameStateManager.inventoryItems
var slotSize: int = 50
var inventorySlots: Array[Panel] = []
var activeSlot: int = 0

@onready var hotbar := $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameStateManager.inventory = $"."
	inventorySlots.resize(gameStateManager.inventory_size)
	for i in gameStateManager.inventory_size:
		var slot := Panel.new()
		slot.custom_minimum_size = Vector2(slotSize,slotSize)
		hotbar.add_child(slot)
		
		var icon := TextureRect.new()
		icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		slot.add_child(icon)
		
		var inset := slotSize * 0.125  # 12.5% on each side = 75% total size
		icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		icon.offset_left   =  inset
		icon.offset_right  = -inset
		icon.offset_top    =  inset
		icon.offset_bottom = -inset
		
		inventorySlots[i] = slot
	redrawInv()
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
	activeSlot = wrapi(activeSlot+dif,0,gameStateManager.inventory_size)
	redrawInv()

func setInvSlot(item: inventoryResource, slot: int) -> void:
	currentInventory[slot] = item
	inventorySlots[slot].get_child(0).texture = item.icon
	
func getInvSlot(slot: int) -> inventoryResource:
	return currentInventory[slot]
	
func eraseSlot(slot: int) -> void:
	currentInventory[slot] = null
	redrawInv()
	
func redrawInv() -> void:
	for i in currentInventory.size():
		inventorySlots[i].remove_theme_stylebox_override("panel")
		inventorySlots[i].get_child(0).texture = currentInventory[i].icon if currentInventory[i] else null
		if i == activeSlot:
			var style := (inventorySlots[i].get_theme_stylebox("panel") as StyleBoxFlat).duplicate()
			style.bg_color += Color(50,50,50,0)
			inventorySlots[i].add_theme_stylebox_override("panel", style)
