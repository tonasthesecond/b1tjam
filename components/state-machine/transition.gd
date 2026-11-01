class_name Transition extends Resource

var from: State  # null = any state
var to: State
var conditions: Array[Condition]


func _init(from_state: State = null, to_state: State = null, conds: Array[Condition] = []) -> void:
	from = from_state
	to = to_state
	conditions = conds


func is_met() -> bool:
	for condition in conditions:
		if not condition.is_met():
			return false
	return true
