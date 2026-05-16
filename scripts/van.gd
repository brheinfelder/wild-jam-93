extends CharacterBody2D

@onready var SPEED = 300.0 + gameStateManager.stats["TRUCK_SPEED"]*50
@onready var ACCEL = 300 + gameStateManager.stats["TRUCK_ACCEL"]*100
const DECEL = 100

@onready var sprite = $sprite

func _physics_process(delta: float) -> void:
	var lrdirection := Input.get_axis("move_left", "move_right")
	var uddirection := Input.get_axis("move_up", "move_down")
	if !gameStateManager.gameActive:
		lrdirection = 0
		uddirection = 0
	
	var direction = Vector2(lrdirection,uddirection).normalized()
	if direction.length() == 0:
		velocity.x = move_toward(velocity.x,0,DECEL*delta);
		velocity.y = move_toward(velocity.y, 0,DECEL*delta);
	else:
		velocity.x = move_toward(velocity.x,direction.x*SPEED,ACCEL*delta);
		velocity.y = move_toward(velocity.y, direction.y*SPEED,ACCEL*delta);
	
	var speed_fraction = velocity.length()/SPEED
	sprite.speed_scale = lerp(1, 3, speed_fraction)
	if velocity.length() > 3:
		if velocity.x>0:
			#sprite.flip_h = true
			sprite.scale = Vector2(-abs(scale.x), scale.y)
		elif velocity.x<0:
			sprite.scale = Vector2(abs(scale.x), scale.y)
			#sprite.flip_h = false
		
	move_and_slide()
