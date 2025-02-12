class_name HealthComponent extends Node2D

@export var MAX_HEALTH: int = 0
var health: int

signal die

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: Attack) -> void:
	if health <= 0:
		return
	health -= attack.damage
	if health <= 0:
		die.emit()
