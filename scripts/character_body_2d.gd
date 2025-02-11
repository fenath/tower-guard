class_name PlayerCharacter extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

signal attack

@onready var magnet_action: MagnetAction = preload(
	"res://scenes/magnet_action.tscn"
	).instantiate() as MagnetAction
@export var friction: float = 0.28
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea

var inventory: Inventory = Inventory.new()

var _velocity = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var damage = 1

var last_x: float = 0.0

var is_attacking: bool = false

func _on_attack() -> void:
	if is_attacking: 
		return
	is_attacking = true
	animated_sprite.play('attacking')
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.2
	add_child(timer)
	timer.timeout.connect(deal_damage)
	timer.start()
	animated_sprite.animation_finished.connect(stop_attack)

func stop_attack() -> void:
	is_attacking = false
	animated_sprite.animation_finished.disconnect(stop_attack)

func deal_damage() -> void:
	await get_tree().create_timer(0.2).timeout
	
	var colliders = attack_area.get_overlapping_areas()
	
	for i in colliders:
		if i is HitboxComponent:
			var hitbox = i as HitboxComponent
			var atk = Attack.new()
			atk.knockback_force = 10.0
			atk.attack_position = self.global_position
			atk.damage = self.damage
			hitbox.damage(atk)
		#if i.has_method('damage'):
			#var attack = Attack.new()
			#attack.damage = damage
			#i.damage(attack)

func _ready() -> void:
	if magnet_action:
		self.add_child(magnet_action)
		magnet_action.position = Vector2.ZERO
		magnet_action.collect.connect(inventory.collect)
		
	attack.connect(_on_attack)

func _physics_process(_delta: float) -> void:
	var x : int = 0
	var y : int = 0
	
	if Input.is_action_pressed('ui_left'):
		x -= 1
	if Input.is_action_pressed('ui_right'):
		x += 1
	if Input.is_action_pressed('ui_up'):
		y -= 1
	if Input.is_action_pressed('ui_down'):
		y += 1
		
	direction = Vector2(x, y)
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if Input.is_action_pressed('attack'):
		attack.emit()
		
	if ! is_attacking:
		if direction.length() == 0:
			animated_sprite.play('idle')
		else:
			animated_sprite.play('walking')


	# Verifica se houve mudança de direção no eixo X
	if velocity.x != 0 and sign(velocity.x) != sign(last_x):
		animated_sprite.flip_h = (velocity.x < 0)  # True se estiver indo para a esquerda

	# Atualiza o último valor de direção no eixo X
	if velocity.x != 0:
		last_x = velocity.x
		
	attack_area.get_node('Shape').position.x = -abs(attack_area.get_node('Shape').position.x)  if (animated_sprite.flip_h) else abs(attack_area.get_node('Shape').position.x)
	
	var target_velocity = direction * SPEED
	_velocity += (target_velocity - _velocity) * friction
	velocity = _velocity
	move_and_slide()
	
