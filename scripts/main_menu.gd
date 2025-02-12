extends Node2D

const TEST_SCENE = preload("res://scenes/test/test_scene.tscn")


func start_game():
	var new_scene = TEST_SCENE.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	
func _on_button_pressed() -> void:
	start_game()
