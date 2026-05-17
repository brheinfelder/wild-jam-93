class_name Biome
extends Resource

@export var name: String
@export var startDistance: int
@export var tileSet: TileSet
@export var meteors: Array[MeteorType]
var initialized: bool = false
var tiles: Array[Dictionary] = []
var sourceID: int
var tileProbabilitySum: float = 0
var meteorProbabilitySum: float = 0

func init(startID: int) -> Array[TileSetAtlasSource]:
	if initialized:
		return []
	var sourceID := startID
	var sourceList: Array[TileSetAtlasSource] = []
	tiles.clear()
	for meteor in meteors:
		meteorProbabilitySum += meteor.probability
	for i in tileSet.get_source_count():
		sourceID += i
		var source := tileSet.get_source(i) as TileSetAtlasSource
		sourceList.append(source)
		for j in source.get_tiles_count():
			var tileData := source.get_tile_data(source.get_tile_id(j),0)
			var tile := {
				"sourceID": sourceID,
				"atlasCoords": source.get_tile_id(j),
				"probability": tileData.probability
			}
			tileProbabilitySum += tileData.probability
			tiles.append(tile)
	tiles.sort_custom(func(a,b): return a.probability < b.probability)
	initialized = true
	return sourceList

func randomTile(seed: int) -> Dictionary:
	seed(seed)
	var prob = randf_range(0,tileProbabilitySum)
	for tile in tiles:
		prob -= tile.probability
		if prob <= 0:
			return tile
	return tiles.back()
	
func randomMeteor() -> MeteorType:
	var prob = randf_range(0,meteorProbabilitySum)
	for meteor in meteors:
		prob -= meteor.probability
		if prob <= 0:
			return meteor
	return meteors.back()
