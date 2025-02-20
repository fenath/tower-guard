class_name HealthComponentMine extends Node2D

@export var MAX_HEALTH: int = 0
var health: int

signal die

func _ready() -> void:
	health = MAX_HEALTH

func damage(attack: Attack) -> void:
	print("heal_component")
	if health <= 0:
		return
	health -= attack.damage
	if health <= 0:
		die.emit()
