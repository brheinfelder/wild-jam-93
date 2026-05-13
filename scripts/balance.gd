extends Control

var balance: int = gameStateManager.balance
var speedMult: float = 10.0
var animDuration: float = 1
var floatBalance: float = float(balance)
var cumMult: float = 1

@onready var sprite: AnimatedSprite2D = $SubViewportContainer.get_child(0).get_node("AnimatedSprite2D")
@onready var balanceLabel: Label = $Label
@onready var anim: AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	if balance != gameStateManager.balance:
		updateBalance()
	pass
	
func updateBalance() -> void:
	var dif: int = gameStateManager.balance - balance
	balance = gameStateManager.balance
	await updateAnimation(dif)
	return

func updateAnimation(dif: int) -> void:
	var timer = 0
	var linearProgress = 0
	var progress = 0
	var balanceAdded = 0
	if dif <0:
		anim.play("loss")
	else:
		anim.play("gain")
	while timer < animDuration:
		linearProgress = timer/animDuration
		progress = EaseInOutSine(linearProgress)
		sprite.speed_scale = lerp(1.0,speedMult,pingPong(progress))
		floatBalance += dif*progress - balanceAdded
		balanceAdded = dif*progress
		balanceLabel.text = str(roundi(floatBalance))
		timer += get_process_delta_time()
		await get_tree().process_frame
		pass
	sprite.speed_scale = 1
	floatBalance += dif - balanceAdded
	balanceLabel.text = str(roundi(floatBalance))
	return

func EaseInOutSine(x: float) -> float:
	return -(cos(PI * x) - 1.0) / 2.0
	
func pingPong(x: float) -> float:
	return 1.0 - abs(2.0 * x - 1.0)
