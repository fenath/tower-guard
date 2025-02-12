class_name Meat extends Area2D

signal meat_up #sinal da colisão do meat com player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


#Verificação da colisão do meat com player
func _on_body_entered(_body):
	hide()
	meat_up.emit()
	queue_free()
	
func spawn() -> void:
	animated_sprite_2d.play('spawn')
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play('idle')
