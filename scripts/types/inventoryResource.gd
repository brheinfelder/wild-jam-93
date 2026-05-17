class_name inventoryResource
extends Resource

@export var qualityString: String
@export var sprite: SpriteFrames
@export var color: Color
@export var split: inventoryResource
@export var cut: inventoryResource
@export var polished: inventoryResource
var dropScene := load("res://scenes/drop.tscn") as PackedScene

func spawn(useCrater: bool = false) -> Node2D:
	var drop := dropScene.instantiate()
	drop.resource = self
	drop.crater = useCrater
	return drop
