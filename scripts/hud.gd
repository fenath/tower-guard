class_name Hud extends Control

# A hud se conecta com o inventário do jogador para ver quantos itens 
# ele tem. Quando atualizamos o inventário do jogador, o sinal é conectado
# à função update_inventory_labels

@onready var current_hp: int = 0

@onready var meat_qty: int = 0: set =  _set_meat
@onready var gold_qty: int = 0: set =  _set_gold
@onready var wood_qty: int = 0: set =  _set_wood

var inventory: Inventory

signal collect

func play_pickup() -> void:
	$pickupSound.play()
	
func assign_inventory(_inventory: Inventory) -> void:
	inventory = _inventory
	inventory.inventory_changed.connect(update_inventory_labels)
	
func update_inventory_labels() -> void:
	wood_qty = inventory.wood_qty
	gold_qty = inventory.gold_qty
	meat_qty = inventory.meat_qty

func _set_meat(value):
	meat_qty = value
	$meat/Label.text = label_txt(value)
	collect.emit()

func _set_gold(value):
	gold_qty = value
	$gold/Label.text = label_txt(value)
	collect.emit()

func _set_wood(value):
	wood_qty = value
	$wood/Label.text = label_txt(value)
	collect.emit()

func label_txt(value: int) -> String:
	return str(value) + 'x'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_current_hp(3)
	meat_qty = 0
	gold_qty = 0
	wood_qty = 0
	collect.connect(play_pickup)


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
	
func _on_gold_up() -> void:
	gold_qty += 1
	
func _on_meat_up() -> void:
	meat_qty += 1
	
func _on_wood_up() -> void:
	wood_qty += 1
