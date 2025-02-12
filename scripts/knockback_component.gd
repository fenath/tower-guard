class_name KnockbackComponent extends Node2D

@export var hitbox: HitboxComponent
@export var body: CharacterBody2D

var _velocity: Vector2 = Vector2.ZERO
var _decay := 0.9

const MULT_FACTOR := 25.0

func _ready() -> void:
	if hitbox:
		hitbox.hit.connect(_on_hitbox_hit)

func _process(delta: float) -> void:
	if body:
		body.velocity += _velocity
		_velocity *= _decay

func _on_hitbox_hit(attack: Attack) -> void:
	if body:
		var direction = (body.global_position - attack.attack_position).normalized()
		_velocity = direction * attack.knockback_force * MULT_FACTOR
