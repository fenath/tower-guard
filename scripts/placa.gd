class_name Sign extends Sprite2D

signal read_message(Value: String)
signal finished

@onready var area: Area2D = $Area2D

@export_multiline var text: String
@export var meat_cost: int = 0
@export var gold_cost: int = 5
@export var wood_cost: int = 5

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		read_message.emit(text)
		
func _input(event: InputEvent) -> void:
	var bodies = area.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group('player'):
			if event.is_action_pressed('interact'):
				var player = body as PlayerCharacter
				if can_upgrade_tower(player):
					read_message.emit('Parabens, ganhou!')
					finished.emit()


func can_upgrade_tower(player: PlayerCharacter) -> bool:
	if player.inventory.gold_qty < self.gold_cost:
		read_message.emit('Quantidade de ouro insuficiente (%d/%d)' % [
			player.inventory.gold_qty, self.gold_cost
		])
		return false
	if player.inventory.wood_qty < self.wood_cost:
		read_message.emit('Quantidade de madeira insuficiente (%d/%d)' % [
			player.inventory.wood_qty, self.wood_cost
		])
		return false
	if player.inventory.meat_qty < self.meat_cost:
		read_message.emit('Quantidade de carne insuficiente (%d/%d)' % [
			player.inventory.meat_qty, self.meat_cost
		])
		return false
	
	return true
	
