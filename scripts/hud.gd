class_name Hud extends Control


@onready var current_hp: int = 0

@onready var meat_qty: int = 0: set =  _set_meat
@onready var gold_qty: int = 0: set =  _set_gold
@onready var wood_qty: int = 0: set =  _set_wood

func _set_meat(value):
	meat_qty = value
	$meat/Label.text = label_txt(value)

func _set_gold(value):
	gold_qty = value
	$gold/Label.text = label_txt(value)

func _set_wood(value):
	wood_qty = value
	$wood/Label.text = label_txt(value)

func label_txt(value: int) -> String:
	return str(value) + 'x'

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


func _on_button_3_pressed() -> void:
	$pickupSound.play()
	meat_qty += 1
