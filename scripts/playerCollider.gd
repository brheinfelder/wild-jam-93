extends Area2D

func _physics_process(_delta: float) -> void:
	var areas := get_overlapping_areas()
	for area in areas:
		if area.is_in_group("staticCollision"):
			handleStaticCollisions(area)
		if area.is_in_group("dynamicCollision"):
			pass

func handleStaticCollisions(area: Area2D) -> void:
	var myShape := $CollisionShape2D
	var otherShape := area.get_node("CollisionShape2D")
	var contacts = myShape.shape.collide_and_get_contacts(
		myShape.global_transform,
		otherShape.shape,
		otherShape.global_transform)
	if contacts.is_empty():
		return

	var contact_point := Vector2.ZERO
	for point in contacts:
		contact_point += point
	contact_point /= contacts.size()
		
	var pairCount : int = contacts.size() / 2
	var totalDepth := 0.0
	for i in pairCount:
		totalDepth += contacts[i * 2].distance_to(contacts[i * 2 + 1])
	var penetrationDepth := totalDepth / pairCount
	
	var normal := (global_position - contact_point).normalized()
	$"..".global_position += normal * penetrationDepth
	
	var velocity: Vector2 = $"..".velocity
	var velocityAlongNormal := velocity.dot(normal)
	if velocityAlongNormal < 0:
		velocity -= normal * velocityAlongNormal
	$"..".velocity = velocity
