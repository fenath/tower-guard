extends Area2D

signal gold_up #sinal da colisão do gold com player

#Verificação da colisão do gold com player
func _on_body_entered(body):
	hide()
	gold_up.emit()
	queue_free()
	
