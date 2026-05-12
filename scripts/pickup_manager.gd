extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if !event.is_action_pressed("interact"):
		return
	var slot = gameStateManager.inventory.activeSlot
	
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
			break
		elif area.is_in_group("building"):
			var building = obj as Building
			if building.processResource(gameStateManager.inventory.getInvSlot(slot)):
				gameStateManager.inventory.eraseSlot(slot)
			else:
				gameStateManager.inventory.denyInteraction(slot)
			break
