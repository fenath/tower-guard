class_name LevelManager extends Node


var LEVELS: Array[PackedScene] = []
var current_level: int = -1

func _init() -> void: 
	current_level = -1
	LEVELS.append(load("res://scenes/test/test_scene.tscn"))
	LEVELS.append(load("res://scenes/main2.tscn"))
	
	
func next_level() -> PackedScene:
	current_level += 1
	
	if LEVELS.size() < current_level+1:
		print('no level to show')
		return null
	
	return LEVELS[current_level]
