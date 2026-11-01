class_name StateMachine
extends Node

signal state_changed(old_state: State, new_state: State)

var current: State
var _transitions: Array[Transition] = []


func add_transition(from: State, to: State, conditions: Array[Condition]) -> void:
	_transitions.append(Transition.new(from, to, conditions))


func start(initial: State) -> void:
	current = initial
	current.enter()


func _physics_process(delta: float) -> void:
	if current == null:
		return
	for transition in _transitions:
		var from_matches: bool = transition.from == null or transition.from == current
		if from_matches and transition.to != current and transition.is_met():
			change_state(transition.to)
			break
	current.update(delta)


func change_state(new_state: State) -> void:
	var old_state := current
	current.exit()
	current = new_state
	current.enter()
	state_changed.emit(old_state, new_state)
