class_name TreeObject extends StaticBody2D


const MIN_DROP: int = 2
const MAX_DROP: int = 5

const WOOD = preload("res://prefabs/wood.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit_animation: AnimationPlayer = $HitAnimation
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var drop_items: DropItems = $DropItems

func damage(_attack: Attack) -> void:
	if health_component.health <= 0:
		return
	sprite.play('hit')
	hit_animation.play('hit')	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play('idle')
	sprite.animation_finished.connect(_sprite_finished)
	health_component.MAX_HEALTH = 3
	health_component.health = 3
	health_component.die.connect(_on_die)
	hitbox_component.hit.connect(damage)
	
func _on_die() -> void: 
	drop_items.drop_items()
	hitbox_component.hit.disconnect(damage)
	sprite.play('chopped')
	
	
func _sprite_finished() -> void:
	if sprite.animation == 'chopped':
		return
	sprite.play('idle')
