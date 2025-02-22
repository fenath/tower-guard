class_name Hud extends Control

# A hud se conecta com o inventário do jogador para ver quantos itens 
# ele tem. Quando atualizamos o inventário do jogador, o sinal é conectado
# à função update_inventory_labels

@onready var current_hp: int = 0

@onready var meat_qty: int = 0: set =  _set_meat
@onready var gold_qty: int = 0: set =  _set_gold
@onready var wood_qty: int = 0: set =  _set_wood
@onready var center_container: CenterContainer = $CenterContainer
@onready var message_label: Label = $CenterContainer/MessageLabel
@onready var tween = get_tree().create_tween()
@onready var key_bindings_label: Label = $KeyBindingsLabel

var player_health_component: HealthComponent = null

var inventory: Inventory

signal collect

func assign_inventory(_inventory: Inventory) -> void:
	inventory = _inventory
	if not inventory.inventory_changed.is_connected(update_inventory_labels):
		inventory.inventory_changed.connect(update_inventory_labels)
	
func assign_player_health_component(_health: HealthComponent) -> void:
	player_health_component = _health

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
	
func set_message(message: String) -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	
	message_label.text = message
	tween.tween_property(center_container, 'modulate', Color(1,1,1,1), 0.1)
	tween.tween_interval(2)
	tween.tween_property(center_container, 'modulate', Color(1,1,1,0), 0.5)

func _on_message(message: String) -> void:
	set_message(message)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_current_hp(3)
	meat_qty = 0
	gold_qty = 0
	wood_qty = 0
	center_container.modulate = Color(1,1,1,0)
	hide_commands()
	
func hide_commands() -> void:
	var commands_tween = get_tree().create_tween()
	commands_tween.tween_interval(4)
	commands_tween.tween_property(key_bindings_label, 'modulate', Color(1,1,1,0), 0.2)
	commands_tween.play()

func update_current_hp(value: int): 
	current_hp = value
	$HP/HpLabel.text = ' ' + str(current_hp)

func _process(_delta: float) -> void:
	if !player_health_component:
		return
	if current_hp != player_health_component.health:
		update_current_hp(player_health_component.health)

func _on_button_pressed() -> void:
	update_current_hp(current_hp + 1)


func _on_button_2_pressed() -> void:
	update_current_hp(current_hp - 1)


func _on_button_3_pressed() -> void:
	meat_qty += 1
	
func _on_gold_up() -> void:
	gold_qty += 1
	
func _on_meat_up() -> void:
	meat_qty += 1
	
func _on_wood_up() -> void:
	wood_qty += 1


func _on_placa_read_message(Value: String) -> void:
	set_message(Value)
