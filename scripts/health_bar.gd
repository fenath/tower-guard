class_name HealthBar extends ProgressBar

@onready var damage_bar = $damage_bar
@onready var timer = $Timer

var health = 0 : set = _set_health

func init_health(_health: int) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _set_health(new_health) -> void:
	var prev = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
	
	if prev > value:
		timer.start()
	else:
		damage_bar.value = new_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	damage_bar.value = health
