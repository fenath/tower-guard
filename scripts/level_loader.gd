class_name LevelLoader extends Node

@export var hud: Hud
@export var main_scene: Node2D
@export var player_node: Node2D
@export var game_over_screen: GameOverScreen
@export var world_tiles: WorldTiles

func get_resources_node() -> Node2D:
	if not main_scene.has_node('resources'):
		var result : Node2D = Node2D.new()
		result.name = 'resources'
		main_scene.add_child(result)
		return result
	return main_scene.get_node('resources')
	
func set_camera() -> void:
	if !world_tiles:
		return
	if ! player_node:
		return
	
	var camera: FollowCamera = get_player_node().get_node('followCamera')
	camera.tilemap = world_tiles.limit_tiles
	
	
func get_player_node() -> PlayerCharacter:
	if !player_node:
		return null
	if player_node.has_node('CharacterBody2D'):
		return player_node.get_node('CharacterBody2D') as PlayerCharacter
	return null

func load_scene() -> void:
	#add_child(main_scene)
	var player = get_player_node()
	hud.assign_inventory(player.inventory)
	hud.assign_player_health_component(player.health_component)
	player.message.connect(hud._on_message)
	player.health_component.die.connect(game_over)
	set_camera()
	
func _ready() -> void:
	call_deferred('load_scene')
	
func game_over() -> void:
	#var game_over_screen: GameOverScreen = main_scene.get_node('CanvasLayer2/GameOverScreen')
	if !game_over_screen:
		print("game over scene não encontrada")
		return
	game_over_screen.show_game_over()
