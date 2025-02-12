class_name Sheep extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hit_animation: AnimationPlayer = $HitAnimation
@onready var drop_items: DropItems = $DropItems
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var idle: IdleState = $StateMachine/Idle
@onready var escape: EscapeState = $StateMachine/Escape
@onready var state_machine: StateMachine = $StateMachine

var last_x: float = 0.0

const SPEED = 150.0

func damage(attack: Attack) -> void:
	hit_animation.play('hit')
	state_machine.change_to(escape.name)
	
func die() -> void:
	drop_items.drop_items()
	queue_free()
	hitbox_component.hit.disconnect(damage)

func _ready() -> void:
	hitbox_component.hit.connect(damage)
	health_component.die.connect(die)
	escape.escaped.connect(_on_escaped)

	
func _on_escaped() -> void:
	state_machine.change_to(idle.name)
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		sprite.play('walk')
	elif velocity.length() == 0:
		sprite.play('idle')
	
	# Verifica se houve mudança de direção no eixo X
	if velocity.x != 0 and sign(velocity.x) != sign(last_x):
		sprite.flip_h = (velocity.x < 0)  # True se estiver indo para a esquerda

	# Atualiza o último valor de direção no eixo X
	if velocity.x != 0:
		last_x = velocity.x
