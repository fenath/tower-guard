extends Area2D


const MIN_DROP: int = 1
const MAX_DROP: int = 3

var hp: int = 3

const WOOD = preload("res://prefabs/wood.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite

func take_damage(damage: int) -> void:
	if hp <= 0:
		return
	sprite.play('hit')
	hp -= damage
	if hp <= 0:
		drop_items()

func drop_items():
	var wood_qty = randi_range(MIN_DROP, MAX_DROP)
		
	for i in range(wood_qty):
		var new_wood = WOOD.instantiate()
		self.get_parent().add_child(new_wood)
		new_wood.global_position = self.global_position
		var angle = randf()
		var x = cos(angle)
		var y = sin(angle)
		new_wood.global_position += 10 * Vector2(x,y)
		sprite.play('chopped')
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play('idle')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
