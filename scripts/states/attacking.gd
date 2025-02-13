class_name AttackingState extends State

@export var character: CharacterBody2D
@export var MOVE_SPEED: float = 180.0
@export var INTEREST_RANGE: float = 200.0
var target: Node2D

var wait_time: float = 0.0
var is_attacking: bool = false

@onready var animated_sprite: AnimatedSprite2D = $"../../Sprite"
@onready var attack_area: Area2D = $"../../AttackArea"

signal lost_range

func reset_wait_time() -> void:
	wait_time = 0.5

func Enter() -> void:
	if !target:
		target = get_tree().get_first_node_in_group("player")
	
func Exit() -> void:
	pass
	
func Update(_delta: float) -> void:
	if wait_time > 0:
		wait_time -= _delta
	attack_area.position = abs(attack_area.position)
	if animated_sprite.flip_h:
		attack_area.position *= -1
	
func PhysicsUpdate(_delta: float) -> void:
	# espera o cooldown
	if wait_time > 0:
		return
	attack()
	
	if target:
		var distance = character.global_position.distance_to(target.global_position) 
		if distance > INTEREST_RANGE:
			lost_range.emit()
		character.velocity = MOVE_SPEED * character.global_position.direction_to(target.global_position)
		if distance < 80.0:
			character.velocity *= 0.5
		if distance < 50:
			character.velocity *= 0.0
	
func attack() -> void:
	if is_attacking: 
		return
	is_attacking = true
	# esta linha está tanto aqui quanto no enemy.gd, ainda não sei onde deixá-la
	animated_sprite.play("attack") 
	await get_tree().create_timer(0.1 * 3).timeout
	deal_damage()
	await animated_sprite.animation_finished
	is_attacking = false
	reset_wait_time()

func deal_damage() -> void:
	var colliders = attack_area.get_overlapping_areas()
	
	for area in colliders:
		if !area.get_parent().is_in_group("player"):
			continue
		if area is HitboxComponent:
			var hitbox = area as HitboxComponent
			var atk = Attack.new()
			atk.knockback_force = 10.0
			atk.attack_position = character.global_position
			atk.damage = character.DAMAGE
			hitbox.damage(atk)
