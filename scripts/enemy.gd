class_name Enemy extends CharacterBody2D

const SPEED = 180.0

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@export var target: Node2D = null
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func prepare_target() -> void:
	await get_tree().physics_frame
	if target:
		navigation_agent.target_position = target.global_position

func _ready() -> void:
	call_deferred('prepare_target')

func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return
		
	if target:
		navigation_agent.target_position = target.global_position
		
	var current_position = self.global_position
	var next_position = navigation_agent.get_next_path_position()
	self.velocity = (next_position - current_position).normalized() * SPEED
	# self.position += delta * self.velocity
	sprite.flip_h = (velocity.x < 0)
	if velocity.length() > 0:
		sprite.play('run')
	else: 
		sprite.play('idle')
	move_and_slide()
