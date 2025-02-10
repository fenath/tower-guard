extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var _velocity = Vector2.ZERO
var _sprites = {Vector2.RIGHT: 1, Vector2.LEFT: 2, Vector2.UP: 3, Vector2.DOWN: 4}

@onready var magnet_action: MagnetAction = preload(
	"res://scenes/magnet_action.tscn"
	).instantiate() as MagnetAction

@export var friction: float = 0.28

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if magnet_action:
		self.add_child(magnet_action)
		magnet_action.position = Vector2.ZERO

func _physics_process(delta: float) -> void:
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
	
	var direction := Vector2(x, y)
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if direction.length() == 0:
		animated_sprite.play('idle')
	else:
		animated_sprite.play('walking')
		animated_sprite.flip_h = direction.x < 0
	
	var target_velocity = direction * SPEED
	_velocity += (target_velocity - _velocity) * friction
	velocity = _velocity
	move_and_slide()
	
