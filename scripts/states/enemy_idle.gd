class_name EnemyIdleState extends State
# referencia: https://www.youtube.com/watch?v=ow_Lum-Agbs

@export var character: CharacterBody2D
@export var move_speed: float = 50.0
@export var chasing_range: float = 300.0

var move_direction: Vector2
var wander_time: float

const wait_time: float = 0.5

signal next_to_player

func randomize_wander():
	if move_direction != Vector2.ZERO:
		move_direction = Vector2.ZERO
		wander_time = wait_time
		return
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)
	
	
func get_player_node() -> PlayerCharacter:
	return get_tree().get_first_node_in_group('player')
	
func check_range() -> void:
	var player = get_player_node()
	if character.global_position.distance_to(player.global_position) < chasing_range:
		next_to_player.emit()

func Enter() -> void:
	randomize_wander()
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()
	
	check_range()


func PhysicsUpdate(_delta: float) -> void:
	if character:
		character.velocity = move_direction * move_speed
