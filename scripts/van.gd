extends CharacterBody2D

const SPEED = 300.0
const ACCEL = 300
const DECEL = 100

@onready var sprite = $sprite

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var lrdirection := Input.get_axis("move_left", "move_right")
	var uddirection := Input.get_axis("move_up", "move_down")
	
	var direction = Vector2(lrdirection,uddirection).normalized()
	if direction.length() == 0:
		velocity.x = move_toward(velocity.x,0,DECEL*delta);
		velocity.y = move_toward(velocity.y, 0,DECEL*delta);
	else:
		velocity.x = move_toward(velocity.x,direction.x*SPEED,ACCEL*delta);
		velocity.y = move_toward(velocity.y, direction.y*SPEED,ACCEL*delta);
	
	var speed_fraction = velocity.length()/SPEED
	sprite.speed_scale = lerp(1, 3, speed_fraction)
	if velocity.x>0:
		#sprite.flip_h = true
		sprite.scale = Vector2(-abs(scale.x), scale.y)
	elif velocity.x<0:
		sprite.scale = Vector2(abs(scale.x), scale.y)
		#sprite.flip_h = false
		
	move_and_slide()
