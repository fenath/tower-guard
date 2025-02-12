class_name TreeObject extends StaticBody2D


const MIN_DROP: int = 2
const MAX_DROP: int = 5

const WOOD = preload("res://prefabs/wood.tscn")

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var health_component: HealthComponent = $HealthComponent
@onready var hit_animation: AnimationPlayer = $HitAnimation

func damage(attack: Attack) -> void:
	if health_component.health <= 0:
		return
	sprite.play('hit')
	hit_animation.play('hit')	
	health_component.damage(attack)

func drop_items():
	var wood_qty = randi_range(MIN_DROP, MAX_DROP)
		
	for i in range(wood_qty):
		var new_wood = WOOD.instantiate()
		self.get_parent().add_child(new_wood)
		new_wood.global_position = self.global_position
		var angle = randf()
		var x = cos(angle)
		var y = sin(angle)
		new_wood.drop_to(50 * Vector2(x,y) + self.global_position)

		sprite.play('chopped')
	print('dropped %s items' % str(wood_qty))
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play('idle')
	sprite.animation_finished.connect(_sprite_finished)
	health_component.MAX_HEALTH = 3
	health_component.health = 3
	health_component.die.connect(drop_items)
	
func _sprite_finished() -> void:
	if sprite.animation == 'chopped':
		return
	sprite.play('idle')
