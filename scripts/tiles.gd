class_name WorldTiles extends Node2D


@export var limit_tiles: TileMapLayer

func show_castle() -> void:
	$castle.enabled = true
	$tower.enabled = false
