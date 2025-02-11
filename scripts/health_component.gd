class_name HealthComponent extends Node2D

@export var health_bar: HealthBar = null
@export var MAX_HEALTH: int = 10
var health: int

signal die

func _ready() -> void:
	health = MAX_HEALTH
	
	if health_bar:
		health_bar.init_health(MAX_HEALTH)

func damage(attack: Attack) -> void:
	if health <= 0:
		return
	health -= attack.damage
	if health <= 0:
		die.emit()
		health_bar = null
		
	if health_bar:
		health_bar.health -= attack.damage
