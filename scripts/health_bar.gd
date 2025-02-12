class_name HealthBar extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar: ProgressBar = $DamageBar

var health = 0 : set = _set_health

@export var health_component: HealthComponent

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
	elif damage_bar != null:
		damage_bar.value = new_health


func _on_timer_timeout() -> void:
	damage_bar.value = health
	
func _ready() -> void:
	if health_component:
		init_health(health_component.MAX_HEALTH)

func _process(_delta: float) -> void:
	if health_component:
		if self.health != health_component.health:
			self.health = health_component.health
