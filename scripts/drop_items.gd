class_name DropItems extends Node2D

@export var MIN_DROP: int
@export var MAX_DROP: int
@export var item: PackedScene

func drop_items():
	var qty = randi_range(MIN_DROP, MAX_DROP)
		
	for i in range(qty):
		var new_item = item.instantiate()
		var scene = get_tree().root.find_child('resources')
		
		if !scene:
			scene = get_tree().root
		scene.call_deferred('add_child', new_item)
		#scene.add_child(new_item)
		
		new_item.global_position = self.global_position
		var angle = randf()
		var x = cos(angle)
		var y = sin(angle)
		call_deferred('drop_to', new_item, 50 * Vector2(x,y) + self.global_position)

func drop_to(instance, target: Vector2) -> void:
	instance.remove_from_group('resources')
	if instance.has_method('spawn'):
		instance.spawn()
		instance.global_position = target
	instance.add_to_group('resources')
