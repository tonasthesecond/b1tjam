class_name CondCompare
extends Condition

enum Operator { EQUAL, NOT_EQUAL, LESS, LESS_EQUAL, GREATER, GREATER_EQUAL }

# Each side is either a plain value or a Callable that produces one.
var _left: Variant
var _operator: Operator
var _right: Variant


func _init(left: Variant = null, operator := Operator.EQUAL, right: Variant = null) -> void:
	_left = left
	_operator = operator
	_right = right


func is_met() -> bool:
	var left_value: Variant = _resolve(_left)
	var right_value: Variant = _resolve(_right)
	match _operator:
		Operator.EQUAL:
			return left_value == right_value
		Operator.NOT_EQUAL:
			return left_value != right_value
		Operator.LESS:
			return left_value < right_value
		Operator.LESS_EQUAL:
			return left_value <= right_value
		Operator.GREATER:
			return left_value > right_value
		Operator.GREATER_EQUAL:
			return left_value >= right_value
	return false


func _resolve(operand: Variant) -> Variant:
	if operand is Callable:
		return operand.call()
	return operand
