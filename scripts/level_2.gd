extends Node2D

@onready var hud: Hud = $CanvasLayer/Hud
@onready var world: WorldTiles = $World


func _on_placa_finished() -> void:
	hud.set_message('Parabens, você ganhou a demo, para conseguir o final\n'+
	' verdadeiro, deposite 10,00 no pix...')
	world.show_castle()
	await get_tree().create_timer(2).timeout
	hud.set_message('Parabens, você ganhou a demo, para conseguir o final\n'+
	' verdadeiro, deposite 10,00 no pix...')


func _on_placa_read_message(Value: String) -> void:
	hud.set_message(Value)
