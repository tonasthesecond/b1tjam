class_name CondActionPressed extends Condition

var _action: StringName


func _init(action: StringName = &"") -> void:
	_action = action


func is_met() -> bool:
	return Input.is_action_just_pressed(_action)
