extends PathFollow2D


@export var SPEED: float = 100.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress += delta * SPEED
