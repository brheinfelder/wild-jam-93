extends HBoxContainer

@export var itemName: String
@export var gameStat: String
@onready var label: Label = $Label
@onready var label_2: Label = $Label2

func _ready() -> void:
	label.label_settings = label.label_settings.duplicate()
	label_2.label_settings = label_2.label_settings.duplicate()
	label.text = itemName+" . . . "
	var moneyText: String = str(gameStateManager.gameStats[gameStat])
	if gameStateManager.gameStats[gameStat] < 0:
		label_2.label_settings.font_color = Color(0.5, 0, 0)
	elif gameStateManager.gameStats[gameStat] > 0:
		label_2.label_settings.font_color = Color(0, 0.5, 0)
		moneyText = "+"+moneyText
	label_2.text = moneyText
