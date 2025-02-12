class_name StateMachine extends Node2D

# Referencia : https://gdscript.com/solutions/godot-state-machine/

@export var CharacterRef: Node2D = null

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var history = []

# signal state_signal

func _ready() -> void:
	
	if initial_state:
		current_state = initial_state
		
	for child in self.get_children():
		if !(child is State):
			continue
		child.fsm = self
		states[child.name] = child
		current_state.Enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.PhysicsUpdate(delta)

func change_to(state_name):
	history.append(current_state.name)
	set_state(state_name)
	
func back():
	if history.size() > 0:
		set_state(history.pop_back())

func set_state(state_name):
	if current_state:
		current_state.Exit()
		current_state.set_process(false)
		current_state.set_physics_process(false)
		current_state.hide()

	current_state = states[state_name]
	current_state.Enter()
	current_state.set_process(true)
	current_state.set_physics_process(true)
	current_state.show()
