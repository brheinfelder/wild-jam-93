extends Control

@export var polishing: unlock
@export var splitting: unlock
@export var cutting: unlock
@onready var unlockName: Label = $Panel/MarginContainer/VBoxContainer/Name
@onready var desc: Label = $Panel/MarginContainer/VBoxContainer/Desc
@onready var icon: TextureRect = $Panel/MarginContainer/VBoxContainer/TextureRect

func _ready() -> void:
	var chosenUnlock := chooseUnlock()
	unlockName.text = chosenUnlock.Name
	desc.text = chosenUnlock.Description
	icon.texture = chosenUnlock.Icon
	for mat: inventoryResource in chosenUnlock.Materials:
		var icon := TextureRect.new()
		icon.texture = mat.sprite.get_frame_texture("default", 0)
		$Panel/MarginContainer/VBoxContainer/HBoxContainer.add_child(icon)
	
func chooseUnlock() -> unlock:
	if !gameStateManager.unlocks["cracking"]:
		gameStateManager.unlocks["cracking"] = true
		return splitting
	if !gameStateManager.unlocks["polishing"]:
		gameStateManager.unlocks["polishing"] = true
		return polishing
	if !gameStateManager.unlocks["slicing"]:
		gameStateManager.unlocks["slicing"] = true
		return cutting
	return
