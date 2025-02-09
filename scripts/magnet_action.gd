class_name MagnetAction extends Area2D


@onready var shape := $Shape
@onready var collection_area: Area2D = $collect
@export var radius: int = 55
@export var collect_radius: int = 50
const STRENGTH: int = 100
const MAX_SPEED = 300
var resources: Array[Node2D] = []
var speeds: Array[Vector2] = []

func set_radius(new_radius: int)-> void:
	radius = new_radius
	shape.shape.radius = radius

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shape.shape.radius = radius
	if collection_area:
		collection_area.body_entered.connect(_on_collection_area_entered)
		collection_area.area_entered.connect(_on_collection_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(resources.size()):
		var resource = resources[i]
		
		var direction: Vector2 = (self.global_position - resource.global_position)
		if direction == Vector2.ZERO:
			continue
					
		var accel = STRENGTH / direction.length_squared() * 100000
		direction = direction.normalized()
		speeds[i] += direction * accel * delta
		
		if speeds[i].length() > MAX_SPEED:
			speeds[i] = MAX_SPEED * speeds[i].normalized()
		
		resource.global_position += (speeds[i] * delta)
			

func _on_body_entered(body: Node2D) -> void:
	print('body entered %s' % body.name)
	if body.is_in_group('resources'):
		resources.append(body)
		speeds.append(Vector2.ZERO)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('resources'):
		if resources.has(body):
			var i = resources.find(body)
			speeds.remove_at(i)
			resources.erase(body)
			
func _on_collection_area_entered(body: Node2D) -> void:
	if body.is_in_group('resources'):
		var i = resources.find(body)
		speeds.remove_at(i)
		resources.erase(body)
		body.queue_free()
		# TODO: if body.has_method('collect'):
		#			body.collect()


func _on_area_entered(area: Area2D) -> void:
	print('area entered %s' % area.name)
	for g in area.get_groups():
		print(str(g))
	if area.is_in_group('resources'):
		resources.append(area)
		speeds.append(Vector2.ZERO)
