class_name CondState
extends Condition

# Anything that answers a yes/no question: a state's is_done(), a cooldown's is_ready(), etc.
var _question: Callable
var _want: bool


func _init(question: Callable = Callable(), want := true) -> void:
	_question = question
	_want = want


func is_met() -> bool:
	return _question.call() == _want
