extends State

@export var character: CharacterBody2D
@export var target: Node2D = null
@export var SPEED: float = 180.0
@export var CLOSE_DISTANCE: float = 100.0
@export var FAR_DISTANCE: float = 300.0
@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent"

signal close_to_target
signal lost_chasing_range

func prepare_target() -> void:
	await get_tree().physics_frame
	
	if target:
		navigation_agent.target_position = target.global_position


func Enter() -> void:
	call_deferred('prepare_target')
	
func PhysicsUpdate(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
		
	if !target:
		return
		
	navigation_agent.target_position = target.global_position
		
	var current_position = character.global_position
	if current_position.distance_to(target.global_position) <= CLOSE_DISTANCE:
		close_to_target.emit()
		
	if current_position.distance_to(target.global_position) > FAR_DISTANCE:
		lost_chasing_range.emit()
	
	var next_position = navigation_agent.get_next_path_position()
	character.velocity = (next_position - current_position).normalized() * SPEED
