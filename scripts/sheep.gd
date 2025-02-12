class_name Sheep extends CharacterBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hit_animation: AnimationPlayer = $HitAnimation
@onready var drop_items: DropItems = $DropItems

const SPEED = 150.0

func damage() -> void:
	hit_animation.play('hit')
	
func die() -> void:
	drop_items.drop_items()
	queue_free()
	hitbox_component.hit.disconnect(damage)

func _ready() -> void:
	hitbox_component.hit.connect(damage)
	health_component.die.connect(die)
