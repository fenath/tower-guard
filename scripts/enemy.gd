class_name Enemy extends CharacterBody2D

const SPEED = 180.0
const DAMAGE = 1
var direction: Vector2 = Vector2.ZERO
var last_x: float = 0.0

@export var target: Node2D = null
@export var healthbar_visible: bool = true

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var chasing: Node2D = $StateMachine/Chasing
@onready var idle: EnemyIdleState = $StateMachine/Idle
@onready var attacking: AttackingState = $StateMachine/Attacking
@onready var hit_animation: AnimationPlayer = $HitAnimation
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var attack_area: Area2D = $AttackArea
@onready var health_bar: HealthBar = $HealthBar


func _ready() -> void:
	chasing.target = get_tree().get_first_node_in_group('player')
	hitbox_component.hit.connect(_on_hit)
	health_component.die.connect(_on_die)
	chasing.close_to_target.connect(_on_close_to_player)
	chasing.lost_chasing_range.connect(_on_lost_chasing_range)
	attacking.lost_range.connect(_on_lost_range)
	idle.next_to_player.connect(_on_got_next_to_player)
	health_bar.visible = self.healthbar_visible

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func _process(_delta: float) -> void:
	if attacking.is_attacking:
		sprite.play('attack')
	elif velocity.length() > 0:
		sprite.play('run')
	else: 
		sprite.play('idle')
		
	# Verifica se houve mudança de direção no eixo X
	if velocity.x != 0 and sign(velocity.x) != sign(last_x):
		sprite.flip_h = (velocity.x < 0)  # True se estiver indo para a esquerda

	attack_area.get_node('Shape').position.x = abs(attack_area.get_node('Shape').position.x)
	if sprite.flip_h:
		var x : float = attack_area.get_node('Shape').position.x
		attack_area.get_node('Shape').position.x *= -1
		
	# Atualiza o último valor de direção no eixo X
	if velocity.x != 0:
		last_x = velocity.x
	


func _on_hit(_atk: Attack) -> void:
	hit_animation.play('hit')
	
func _on_die() -> void:
	queue_free()
	
func _on_close_to_player() -> void:
	state_machine.change_to(attacking.name)

func _on_lost_range() -> void:
	state_machine.change_to(chasing.name)
	
func _on_lost_chasing_range() -> void:
	state_machine.change_to(idle.name)
	
func _on_got_next_to_player() -> void:
	state_machine.change_to(chasing.name)
