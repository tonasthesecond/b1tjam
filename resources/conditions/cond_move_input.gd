class_name CondMoveInput extends Condition

var _want_moving: bool


func _init(want_moving := true) -> void:
	_want_moving = want_moving


func is_met() -> bool:
	var is_moving := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO
	return is_moving == _want_moving
