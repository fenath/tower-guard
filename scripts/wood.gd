class_name Wood extends Area2D

signal wood_up #sinal da colisão do wood com player

var state: Node2D = null

@onready var dropping_state = $Dropping
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#Verificação da colisão do wood com player
func _on_body_entered(_body):
	hide()
	wood_up.emit()
	queue_free()
	
func drop_to(target: Vector2) -> void:
	self.remove_from_group('resources')
	state = dropping_state
	dropping_state.node = self
	dropping_state.origin = self.global_position
	dropping_state.target = target
	dropping_state.dropped.connect(_on_dropped)
	sprite.play('spawn')
	await sprite.animation_finished
	sprite.play('idle')
	self.add_to_group('resources')
	
	
func _on_dropped() -> void:
	state.queue_free()
	state = null
