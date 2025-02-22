extends Node2D

@onready var main_scene := preload("res://scenes/main.tscn").instantiate()
@onready var hud: Hud = main_scene.get_node('CanvasLayer/Hud') as Hud
@onready var placa: Sign = main_scene.get_node('Placa') as Sign

@onready var level_manager: LevelManager = LevelManager.new()

var gold_scn: PackedScene = preload('res://prefabs/gold.tscn')
var wood_scn: PackedScene = preload('res://prefabs/wood.tscn')
var meat_scn: PackedScene = preload('res://prefabs/meat.tscn')

const ENEMY := preload("res://prefabs/enemy.tscn")

func _on_enemey_killed() -> void:
	print('parabens, matou o inimigo')
	

func _on_finish_level() -> void:
	print('mudando de level')
	await get_tree().create_timer(1).timeout
	var next_level = level_manager.next_level()
	get_tree().call_deferred('change_scene_to_packed', next_level)


func add_enemy() -> void:
	var enemy = ENEMY.instantiate() as Enemy
	main_scene.add_child(enemy)
	enemy.global_position = Vector2(983, 656)
	enemy.target = main_scene.get_node('player/CharacterBody2D')
	enemy.health_component.die.connect(_on_enemey_killed)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(main_scene)
	
	add_enemy()
	
	var player: PlayerCharacter = main_scene.get_node('player/CharacterBody2D')
	hud.assign_inventory(player.inventory)
	hud.assign_player_health_component(player.health_component)
	player.health_component.die.connect(game_over)
	placa.finished.connect(_on_finish_level)
	
	level_manager.current_level = 0

func _on_collect() -> void:
	var new_item: Node2D = [gold_scn, meat_scn, wood_scn].pick_random().instantiate()
	var player: Node2D = main_scene.get_node('player')
	
	var angle = randf()
	var new_item_position: Vector2 = Vector2(150 * cos(angle), 150 * sin(angle))

	main_scene.get_node('resources').add_child(new_item)
	new_item.global_position = new_item_position + player.global_position
	
func game_over() -> void:
	var game_over_screen: GameOverScreen = main_scene.get_node('CanvasLayer2/GameOverScreen')
	if !game_over_screen:
		print("game over scene não encontrada")
		return
	game_over_screen.show_game_over()
