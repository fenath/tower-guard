extends Node2D

@onready var main_scene := preload("res://scenes/main.tscn").instantiate()
@onready var hud: Hud = main_scene.get_node('CanvasLayer/Hud') as Hud

var gold_scn: PackedScene = preload('res://prefabs/gold.tscn')
var wood_scn: PackedScene = preload('res://prefabs/wood.tscn')
var meat_scn: PackedScene = preload('res://prefabs/meat.tscn')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(main_scene)
	var res = main_scene.get_node('resources')
	
	for child in res.get_children():
		if child.has_signal('meat_up'):
			child.meat_up.connect(hud._on_meat_up)
		if child.has_signal('gold_up'):
			child.gold_up.connect(hud._on_gold_up)
		if child.has_signal('wood_up'):
			child.wood_up.connect(hud._on_wood_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_collect() -> void:
	var new_item: Node2D = [gold_scn, meat_scn, wood_scn].pick_random().instantiate()
	var player: Node2D = main_scene.get_node('player')
	
	var angle = randf()
	var new_item_position: Vector2 = Vector2(150 * cos(angle), 150 * sin(angle))

	main_scene.get_node('resources').add_child(new_item)
	new_item.global_position = new_item_position + player.global_position
	
