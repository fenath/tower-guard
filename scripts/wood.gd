class_name Wood extends Area2D

signal wood_up #sinal da colisão do wood com player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#Verificação da colisão do wood com player
func _on_body_entered(_body):
	hide()
	wood_up.emit()
	queue_free()

func spawn() -> void:
	sprite.play('spawn')
	await sprite.animation_finished
	sprite.play('idle')
