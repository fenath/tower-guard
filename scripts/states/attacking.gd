class_name AttackingState extends State

@export var character: CharacterBody2D
@export var MOVE_SPEED: float = 180.0
@export var INTEREST_RANGE: float = 200.0
var target: Node2D

var wait_time: float = 0.0
var is_attacking: bool = false
var hit_list: Array[HitboxComponent] = []

@onready var animated_sprite: AnimatedSprite2D = $"../../Sprite"
@onready var attack_area: Area2D = $"../../AttackArea"

signal lost_range

func reset_wait_time() -> void:
	wait_time = 0.5

func Enter() -> void:
	if not attack_area.area_entered.is_connected(_on_attack_area_area_entered):
		attack_area.area_entered.connect(_on_attack_area_area_entered)
	attack_area.monitoring = false
	if !target:
		target = get_tree().get_first_node_in_group("player")
	
func Exit() -> void:
	attack_area.area_entered.disconnect(_on_attack_area_area_entered)
	attack_area.monitoring = false
	
func Update(_delta: float) -> void:
	if wait_time > 0:
		wait_time -= _delta
	
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
	attack_area.monitoring = true
	
	await animated_sprite.animation_finished
	is_attacking = false
	attack_area.monitoring = false
	clear_hitbox_list()
	reset_wait_time()

func _on_attack_area_area_entered(area: Area2D) -> void:
	
	if !area.get_parent().is_in_group("player"):
		return
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		if has_hitten(hitbox):
			return
		var atk = Attack.new()
		atk.knockback_force = 10.0
		atk.attack_position = character.global_position
		atk.damage = character.DAMAGE
		hitbox.damage(atk)
		add_hitbox(hitbox)

func add_hitbox(hb: HitboxComponent) -> void:
	hit_list.append(hb)
	
func clear_hitbox_list() -> void:
	hit_list.clear()
	
func has_hitten(hb: HitboxComponent) -> bool:
	return hit_list.has(hb)
