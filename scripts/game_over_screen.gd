class_name GameOverScreen extends Control

@onready var animation: AnimationPlayer = $Animation
const MAIN_MENU = preload("res://scenes/main_menu.tscn")

func _ready() -> void:
	visible = false
	
func show_game_over() -> void:
	visible = true
	animation.play('blur')


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_button_pressed() -> void:
	var new_scene = MAIN_MENU.instantiate()
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	queue_free()
