extends Area2D

signal wood_up #sinal da colisão do wood com player

#Verificação da colisão do wood com player
func _on_body_entered(body):
	hide()
	wood_up.emit()
	queue_free()
	
