class_name StateMachine extends Node2D

# Referencia : https://gdscript.com/solutions/godot-state-machine/

@export var CharacterRef: Node2D = null

@export var initial_state: State

var current_state: State
var states: Dictionary = {}
var history = []

signal state_signal

func _ready() -> void:
	for child in self.get_children():
		if child is State:
			child.fsm = self
			states[child.name] = child
	
	if initial_state:
		current_state = initial_state
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
	remove_child(current_state)
	current_state = states[state_name]
	add_child(current_state)
	current_state.Enter()
