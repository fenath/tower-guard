extends Node2D


@onready var level_manager: LevelManager = LevelManager.new()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_rect: ColorRect = $CanvasLayer/FadeRect


func start_game():
	fade_rect.visible = true
	var tween = create_tween()
	tween.tween_property(fade_rect, "color", Color(0,0,0,1), 0.2)
	await tween.finished
	var scene = level_manager.next_level()
	get_tree().change_scene_to_packed(scene)


func _on_button_pressed() -> void:
	start_game()


func _ready() -> void:
	animation_player.play('breath')
	fade_rect.visible = false
