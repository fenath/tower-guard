extends Node2D


@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.global_position = Vector2(700, 545)
	animation.play("spawn")

func _on_animated_sprite_2d_animation_finished() -> void:
	animation.play("idle")
