class_name Hud extends Control


@onready var current_hp: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_current_hp(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func update_current_hp(value: int): 
	current_hp = value
	$HP/HpLabel.text = '❤️ ' + str(current_hp)


func _on_button_pressed() -> void:
	update_current_hp(current_hp + 1)


func _on_button_2_pressed() -> void:
	update_current_hp(current_hp - 1)
