class_name DroppingState extends Node2D

signal dropped
const SPEED := 200
var origin: Vector2 = Vector2.ZERO
var target: Vector2 = Vector2.ZERO
var node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if node:
		node.global_position = origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if node == null:
		return
	node.global_position += node.global_position.direction_to(target).normalized() * delta * SPEED
	if (node.global_position.distance_to(target)) < 5:
		dropped.emit()
		node = null
	
