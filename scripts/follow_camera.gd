class_name FollowCamera extends Camera2D

var tilemap: TileMapLayer: set = set_tilemap

func set_tilemap(new_tiles) -> void:
	tilemap = new_tiles
	reset_limits()

func get_tilemap() -> void:
	if tilemap == null:
		return
	if get_tree().root.get_children()[0].has_node('World'):
		tilemap = get_tree().root.get_node('World').limit_tiles

func reset_limits() -> void:
	if tilemap == null:
		return
	
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.tile_set.tile_size.x
	var worldSize = mapRect.size * tileSize
	self.limit_top = 0
	self.limit_left = 0
	self.limit_right = worldSize.x
	self.limit_bottom = worldSize.y	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#tilemap =  $"../../../World".limit_tiles
	get_tilemap()
	reset_limits()
