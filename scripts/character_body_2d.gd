class_name PlayerCharacter extends CharacterBody2D

const SPEED = 300.0
signal attack
signal message(value: String)

@onready var magnet_action: MagnetAction = preload(
	"res://scenes/magnet_action.tscn"
	).instantiate() as MagnetAction
@export var friction: float = 0.28
@onready var animated_sprite: AnimatedSprite2D = $Sprite
@onready var attack_area: Area2D = $AttackArea
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hit_animation: AnimationPlayer = $Sprite/HitAnimation
@onready var eat_sound: AudioStreamPlayer = $eatSound
@onready var wrong_sound: AudioStreamPlayer = $wrongSound
@onready var pickup_sound: AudioStreamPlayer = $pickupSound


var inventory: Inventory = Inventory.new()
var hit_list: Array[HitboxComponent] = []

var _velocity = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var damage = 1

var last_x: float = 0.0

var is_attacking: bool = false
var is_dead : bool = false

func _on_attack() -> void:
	if is_attacking: 
		return
	is_attacking = true
	animated_sprite.play('attacking')
	await get_tree().create_timer(0.2).timeout
	attack_area.monitoring = true
	animated_sprite.animation_finished.connect(stop_attack)

func stop_attack() -> void:
	is_attacking = false
	attack_area.monitoring = false
	clear_hitbox_list()
	animated_sprite.animation_finished.disconnect(stop_attack)

func _ready() -> void:
	if magnet_action:
		self.add_child(magnet_action)
		magnet_action.position = Vector2.ZERO
		magnet_action.collect.connect(_on_collect)
		magnet_action.collect.connect(inventory.collect)
	
	hitbox_component.hit.connect(_on_hit_taken)
	health_component.die.connect(_on_die)
		
	attack.connect(_on_attack)

func _on_die() -> void:
	is_dead = true
	#queue_free()

func _on_hit_taken(atk: Attack) -> void:
	health_component.damage(atk)
	hit_animation.play('hit')

func _on_collect(_item: Node2D) -> void:
	pickup_sound.play()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("eat"):
		eat()

func eat() -> void:
	
	if inventory.meat_qty <= 0:
		wrong_sound.play()
		message.emit('Sem carne no inventário')
		return
		
	if health_component.health == health_component.MAX_HEALTH:
		wrong_sound.play()
		message.emit('Vida cheia')
		return
	
	inventory.meat_qty -= 1
	health_component.health += 1
	eat_sound.play()
	inventory.inventory_changed.emit()

func _physics_process(_delta: float) -> void:
	if is_dead:
		return
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

func add_hitbox(hb: HitboxComponent) -> void:
	hit_list.append(hb)
	
func clear_hitbox_list() -> void:
	hit_list.clear()
	
func has_hitten(hb: HitboxComponent) -> bool:
	return hit_list.has(hb)

func _on_attack_area_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		return
	if area is HitboxComponent:
		var hitbox = area as HitboxComponent
		if has_hitten(hitbox):
			return
		var atk = Attack.new()
		atk.knockback_force = 15.0
		atk.attack_position = self.global_position
		atk.damage = self.damage
		add_hitbox(hitbox)
		hitbox.damage(atk)
