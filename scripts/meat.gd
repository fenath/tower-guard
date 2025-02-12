class_name Meat extends Area2D

signal meat_up #sinal da colisão do meat com player

#Verificação da colisão do meat com player
func _on_body_entered(body):
	hide()
	meat_up.emit()
	queue_free()
	
