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
	if MAIN_MENU == null:
		print("Error: MAIN_MENU scene failed to load!")
		return
	get_tree().change_scene_to_packed(MAIN_MENU)
	#queue_free()
