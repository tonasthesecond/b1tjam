class_name CondBool
extends Condition

var _question: Callable
var _want: bool


func _init(question: Callable = Callable(), want := true) -> void:
	_question = question
	_want = want


func is_met() -> bool:
	return _question.call() == _want
