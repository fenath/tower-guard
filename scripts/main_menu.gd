extends Node2D

@onready var TEST_SCENE = load("res://scenes/test/test_scene.tscn")

@onready var level_manager: LevelManager = LevelManager.new()


func start_game():
	var scene = level_manager.next_level()
	get_tree().change_scene_to_packed(scene)


func _on_button_pressed() -> void:
	start_game()
