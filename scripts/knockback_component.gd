class_name KnockbackComponent extends Node2D

# Componente responsável para jogar o personágem para tras
# quando ele é atingido
# se o personagem usa máquina de estados, este componente
# PRECISA estar abaixo da máquina de estados, pois vai anular
# as velocidades anteriores

@export var hitbox: HitboxComponent
@export var body: CharacterBody2D
@export_range (0,2) var intensity: float = 1.0
@export var sleep_time: float = 0.2
@export var sprite: AnimatedSprite2D

var _velocity: Vector2 = Vector2.ZERO
var _decay := 0.9
var _is_attacked := false

var _direction_looking: Vector2

const MULT_FACTOR := 25.0

var wait_time: float = 0.0

func reset_wait_time() -> void:
	wait_time = sleep_time

func _ready() -> void:
	if hitbox:
		hitbox.hit.connect(_on_hitbox_hit)
		
func _process(delta: float) -> void:
	if wait_time > 0:
		wait_time -= delta
	elif _is_attacked:
		_is_attacked = false

func _physics_process(_delta: float) -> void:
	if body:
		if _is_attacked:
			body.velocity = _velocity
			_velocity *= _decay
			if sprite:
				sprite.flip_h = _direction_looking.x < 0

func _on_hitbox_hit(attack: Attack) -> void:
	if body:
		var direction = (body.global_position - attack.attack_position).normalized()
		_velocity = direction * attack.knockback_force * MULT_FACTOR * intensity
		_is_attacked = true
		_direction_looking = body.velocity.normalized()
		reset_wait_time()
