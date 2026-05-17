extends VBoxContainer

@onready var button: Button = $"../Control/Button"
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
var SHOP_SCREEN: PackedScene = load("uid://dhc8tgxs2o23j")


func _ready() -> void:
	button.disabled = true
	await get_tree().process_frame
	for child in get_children():
		if child is HBoxContainer:
			print("playing on: ", child)
			print_stack()  # prints the full call stack
			child.get_child(2).play("drop")
			await get_tree().create_timer(1).timeout
	await get_tree().create_timer(1).timeout
	if gameStateManager.balance > 0:
		button.disabled = false
		animation_player.play("pass")
	else:
		animation_player.play("bankrupt")
		

func _on_button_pressed() -> void:
	gameStateManager.sceneManager.sceneTransition(SHOP_SCREEN.instantiate())
	pass # Replace with function body.
