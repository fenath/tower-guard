class_name MineObject extends StaticBody2D


const MIN_DROP: int = 2
const MAX_DROP: int = 5

const GOLD = preload("res://prefabs/gold.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit_animation: AnimationPlayer = $HitAnimation
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var drop_items: DropItems = $DropItems
@onready var respawn_component: RespawnComponent = $RespawnComponent


func damage(_attack: Attack) -> void:
	if health_component.health <= 0:
		sprite.play('destroyed')
		return
	sprite.play('active')
	hit_animation.play('hit')	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play('inactive')
	sprite.animation_finished.connect(_sprite_finished)
	health_component.MAX_HEALTH = 3
	health_component.health = 3
	health_component.die.connect(drop_items.drop_items)
	health_component.die.connect(respawn_component._on_parent_died)
	hitbox_component.hit.connect(damage)
	
	
func reset() -> void:
	sprite.play('inactive')	
	health_component.health = health_component.MAX_HEALTH
	
func _sprite_finished() -> void:
	if sprite.animation == 'destroyed':
		return
	sprite.play('inactive')

func _on_die():
	drop_items.drop_items()
	queue_free()
	#get_tree().create_timer().timeout.connect(spaw)
