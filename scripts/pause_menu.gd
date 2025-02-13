extends Control
@onready var animation: AnimationPlayer = $Animation

var _is_paused: bool = false:
	set = set_paused
	
func set_paused(new_pause: bool) -> void:
	_is_paused = new_pause
	get_tree().paused = _is_paused
	if _is_paused:
		visible = _is_paused
		animation.play('blur')
	else:
		animation.play_backwards('blur')
		await animation.animation_finished
		visible = _is_paused
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		_is_paused = !_is_paused


func _on_resume_button_pressed() -> void:
	_is_paused = false

func _ready() -> void:
	visible =false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
