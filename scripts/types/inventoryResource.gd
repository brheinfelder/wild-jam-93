class_name inventoryResource
extends Resource

@export var id: String
@export var sprite: SpriteFrames
@export var color: Color
@export var polished: bool = false
@export var split: inventoryResource
@export var cut: inventoryResource
var dropScene := load("res://scenes/drop.tscn") as PackedScene

func spawn(useCrater: bool = false) -> Node2D:
	var drop := dropScene.instantiate()
	drop.resource = self
	drop.crater = useCrater
	return drop
