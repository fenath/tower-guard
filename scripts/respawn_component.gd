class_name RespawnComponent extends Node2D

@export var respawn_time: float = 3.0
var parent_node: Node2D
@onready var timer: Timer = $Timer
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar

func reset_respawn_component() -> void:
	timer.wait_time = respawn_time
	texture_progress_bar.value = 0
	texture_progress_bar.max_value = respawn_time
	texture_progress_bar.visible = false


func _ready():
	reset_respawn_component()
	
	parent_node = get_parent()
	if !parent_node:
		push_error("RespawnComponent precisa ser filho de um Node2D!")
		return
	
	if parent_node.has_signal("died"):
		parent_node.connect("died", _on_parent_died)

func _process(delta: float) -> void:
	if !timer.is_stopped():
		texture_progress_bar.value += delta

func _on_parent_died():
	#parent_node.hide() 
	texture_progress_bar.visible = true
	timer.start()
	await timer.timeout
	timer.stop()
	respawn()

func respawn():
	if parent_node.has_method("reset"):
		parent_node.reset() 
	#parent_node.show()
	reset_respawn_component()
