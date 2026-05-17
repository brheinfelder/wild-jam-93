extends Node2D
const TILESIZEX := 16
const TILESIZEY := 16
var last_cam_tile := Vector2(INF, INF)
var mapSize: Vector2

@export var biomes: Array[Biome] = []
@export var biomeBlendRadius: int = 20

@onready var mm: TileMapLayer = $Terrain
@onready var camera: Camera2D = $"../van/Camera2D"
@onready var map = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameStateManager.biomeManager = self
	prepareBiomeList()
	last_cam_tile = Vector2(floor(camera.get_screen_center_position().x/TILESIZEX),floor(camera.get_screen_center_position().y/TILESIZEY))
	var viewSize := get_viewport_rect().size / camera.zoom
	mapSize = viewSize/Vector2(TILESIZEX,TILESIZEY) + Vector2(10,10)
	generateMap()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var cam_tile := Vector2(floor(camera.get_screen_center_position().x/TILESIZEX),floor(camera.get_screen_center_position().y/TILESIZEY))
	if cam_tile != last_cam_tile:
		var dif = cam_tile - last_cam_tile
		last_cam_tile = cam_tile
		mapDif(dif)
	pass
	
func toTileSpace(coords: Vector2) -> Vector2i:
	return Vector2i(
		floori(coords.x / TILESIZEX),
		floori(coords.y / TILESIZEY)
	)

func prepareBiomeList() -> void:
	var sourceStartID = mm.tile_set.get_source_count()
	for biome in biomes:
		var biomeSources := biome.init(sourceStartID)
		for source in biomeSources:
			mm.tile_set.add_source(source, sourceStartID)
			sourceStartID += 1
	biomes.sort_custom(func(a, b): return a.startDistance < b.startDistance)

func getTileBiome(tileCoord: Vector2i) -> Biome:
	var distance := tileCoord.length()
	var innerDistance := maxf(distance - biomeBlendRadius,0)
	var outerDistance := distance + biomeBlendRadius
	var innerBiome: Biome = biomes[0]
	var outerBiome: Biome = biomes[0]
	for biome in biomes:
		if biome.startDistance < innerDistance:
			innerBiome = biome
		if biome.startDistance < outerDistance:
			outerBiome = biome
	if innerBiome == outerBiome:
		return innerBiome
	var blendStart := outerBiome.startDistance - biomeBlendRadius
	var blendEnd := outerBiome.startDistance + biomeBlendRadius
	var prob := remap(distance, blendStart, blendEnd, 0,1)
	seed(tileCoord.x * 73856093 ^ tileCoord.y * 19349663 ^ gameStateManager.seed)
	var val := randf()
	if val <= prob:
		return outerBiome
	else:
		return innerBiome
	
func generateMap() -> void:
	mm.clear()
	var startCoords = last_cam_tile - mapSize/2
	for i in range(mapSize.x):
		for j in range(mapSize.y):
			var coord = startCoords + Vector2(i, j)
			generateTile(coord)
	
func mapDif(dir: Vector2) -> void:
	if abs(dir.x) > 0:
		var eraseColumn = last_cam_tile.x - dir.x*mapSize.x/2 - dir.x
		var createColumn = last_cam_tile.x + dir.x*mapSize.x/2 - dir.x
		var startY = (last_cam_tile - mapSize/2).y
		for j in range(mapSize.y):
			var coord = Vector2(eraseColumn, startY+j)
			mm.erase_cell(coord)
			generateTile(Vector2(createColumn, startY+j))
	if abs(dir.y) > 0:
		var eraseRow = last_cam_tile.y - dir.y*mapSize.y/2 - dir.y
		var createRow = last_cam_tile.y + dir.y*mapSize.y/2 - dir.y
		var startX = (last_cam_tile - mapSize/2).x
		for i in range(mapSize.x):
			var coord = Vector2(startX+i, eraseRow)
			mm.erase_cell(coord)
			generateTile(Vector2(startX+i, createRow))
		pass
	pass
	
func generateTile(tileCoord: Vector2i) -> void:
	var selectedBiome := getTileBiome(tileCoord)
	var tileSeed = tileCoord.x * 73856093 ^ tileCoord.y * 19349663 ^ gameStateManager.seed
	var key := str(randi_range(0, 1))
	var tileInfo = selectedBiome.randomTile(tileSeed)
	mm.set_cell(tileCoord, tileInfo["sourceID"], tileInfo["atlasCoords"])
