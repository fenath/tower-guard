class_name EnemyIdleState extends State
# referencia: https://www.youtube.com/watch?v=ow_Lum-Agbs

@export var character: CharacterBody2D
@export var move_speed: float = 50.0

var move_direction: Vector2
var wander_time: float

const wait_time: float = 0.5

func randomize_wander():
	if move_direction != Vector2.ZERO:
		move_direction = Vector2.ZERO
		wander_time = wait_time
		return
	move_direction = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)

func Enter() -> void:
	randomize_wander()
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()
	
func PhysicsUpdate(_delta: float) -> void:
	if character:
		character.velocity = move_direction * move_speed
