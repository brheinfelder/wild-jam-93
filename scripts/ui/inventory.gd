extends HBoxContainer

var currentInventory := gameStateManager.inventoryItems
var slotSize: int = 150
var inventoryIcons: Array[TextureRect] = []

@onready var hotbar := $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameStateManager.inventory = $"."
	inventoryIcons.resize(gameStateManager.inventory_size)
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
		
		inventoryIcons[i] = icon
		print("assigned slot ", i, ": ", inventoryIcons[i])  # should not be null
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentInventory != gameStateManager.inventoryItems:
		gameStateManager.inventoryItems = currentInventory
	pass

func setInvSlot(item: inventoryResource, slot: int) -> void:
	print("setting slot ", slot, " item: ", item, " icon: ", item.icon)
	currentInventory[slot] = item
	inventoryIcons[slot].texture = item.icon
