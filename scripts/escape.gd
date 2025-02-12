class_name EscapeState extends State

var move_speed := 125.0
const escape_time := 3.0
# de quem estou fugindo
@export var from: Vector2 
@export var character: CharacterBody2D = null

signal escaped

var time_left: float

func Enter() -> void:
	time_left = escape_time
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	time_left -= _delta
	if time_left <= 0:
		escaped.emit()
	
func PhysicsUpdate(_delta: float) -> void:
	var player_node: Node2D = get_tree().get_first_node_in_group('player') as Node2D
	if player_node:
		from = player_node.global_position
	if (!character):
		return
	character.velocity = move_speed * from.direction_to(character.global_position).normalized()
