extends Control

@export var upgradeName: String #Display Name
@export var upgradeSlug: String #Stat Name (as in game state manager)
@export var baseCost: int #cost of first upgrade
@export var costScaling: int #cost per level after the first
@export var maxLevel: int

@onready var level: Label = $Button/HBoxContainer/Level
@onready var upgrade_name: Label = $Button/HBoxContainer/UpgradeName
@onready var costLabel: Label = $Button/HBoxContainer/Cost
@onready var button: Button = $Button
@onready var container: HBoxContainer = $Button/HBoxContainer

var cost: int

func _process(delta: float) -> void:
	button.disabled = gameStateManager.stats[upgradeSlug] >= maxLevel or gameStateManager.balance < cost
	var style := button.get_theme_stylebox("disabled") as StyleBoxTexture
	container.modulate = style.modulate_color if button.disabled else Color.WHITE

func _ready() -> void:
	upgrade_name.text = upgradeName
	updateButton()

func _on_button_pressed() -> void:
	if gameStateManager.balance >= cost:
		gameStateManager.balance -= cost
		gameStateManager.stats[upgradeSlug] += 1
		updateButton()

func updateButton() -> void:
	level.text = "MAX" if (gameStateManager.stats[upgradeSlug] >= maxLevel) else "("+str(gameStateManager.stats[upgradeSlug])+")"
	cost = baseCost + gameStateManager.stats[upgradeSlug] * costScaling
	costLabel.text = "MAX" if (gameStateManager.stats[upgradeSlug] >= maxLevel) else str(cost)
