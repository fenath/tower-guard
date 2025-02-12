class_name HitboxComponent extends Area2D

@export var health_component: HealthComponent

signal hit(attack: Attack)

func damage(attack: Attack) -> void:
	if health_component:
		health_component.damage(attack)
	hit.emit(attack)
