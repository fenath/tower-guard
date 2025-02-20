class_name HitboxComponentMine extends Area2D

@export var health_component: HealthComponent

signal hit(attack: Attack)

func damage(attack: Attack) -> void:
	print("HitboxComponent")
	if health_component:
		health_component.damage(attack)
	hit.emit(attack)
