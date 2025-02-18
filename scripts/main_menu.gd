extends Node2D

@onready var TEST_SCENE = load("res://scenes/test/test_scene.tscn")


func start_game():
	if TEST_SCENE == null:
		print("Test scene failed to load")
		return
	
	get_tree().change_scene_to_packed(TEST_SCENE)


func _on_button_pressed() -> void:
	start_game()
