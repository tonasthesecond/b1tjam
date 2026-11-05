class_name Meter
extends Resource
## A value between 0 and max_stat that starts full.
## Make it local-to-scene when each instance of a scene needs its own value.

signal value_changed(new_current: float, new_max: float)
signal depleted

@export var max_stat: Stat

var current: float:
	get:
		if not _started:
			_started = true
			_current = max_stat.get_value()
		return _current

var _current := 0.0
var _started := false


func change(amount: float) -> void:
	var proposed := current + amount
	var clamped := clampf(proposed, 0.0, max_stat.get_value())
	if is_equal_approx(clamped, current):
		return
	_current = clamped
	value_changed.emit(current, max_stat.get_value())
	if current <= 0.0:
		depleted.emit()


func fill() -> void:
	change(max_stat.get_value() - current)


func is_empty() -> bool:
	return current <= 0.0
