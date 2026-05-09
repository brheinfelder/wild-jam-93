extends Area2D

signal item_picked_up(resource: inventoryResource, slot: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed:
		return
	var slot = event.keycode - KEY_1
	if slot < 0 or slot >= gameStateManager.inventory_size:
		return
	
	var areas = $".".get_overlapping_areas()
	if areas.is_empty():
		return
		
	areas.sort_custom(func(a,b):
		var da = a.global_position.distance_squared_to(global_position)
		var db = b.global_position.distance_squared_to(global_position)
		return da < db
		)
		
	for area in areas:
		var obj = area.owner
		if area.is_in_group("pickup"):
			gameStateManager.inventory.setInvSlot(obj.resource, slot)
			obj.queue_free()
			print_debug("Picked Up!")
			break
