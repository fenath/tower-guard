extends Camera2D


@export var tilemap: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tilemap =  $"../../../World".limit_tiles
	if tilemap == null:
		return
	var mapRect = tilemap.get_used_rect()
	var tileSize = tilemap.tile_set.tile_size.x
	var worldSize = mapRect.size * tileSize
	self.limit_top = 0
	self.limit_left = 0
	self.limit_right = worldSize.x
	self.limit_bottom = worldSize.y
