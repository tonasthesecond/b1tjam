class_name Meter
extends Node
## A value between 0 and max_stat that starts full. Per-instance, so other nodes
## (Hurtbox, MeterBar) reference this node to read or drain it.

signal value_changed(new_current: float, new_max: float)
signal depleted

@export var max_stat: Stat

var current: float:
	get:
		# Lazy, so it reads max_stat correctly regardless of _ready order.
		if not _started:
			_started = true
			_current = max_stat.get_value()
		return _current

var _current := 0.0
var _started := false


func get_max() -> float:
	return max_stat.get_value()


func change(amount: float) -> void:
	var clamped := clampf(current + amount, 0.0, get_max())
	if is_equal_approx(clamped, current):
		return
	_current = clamped
	value_changed.emit(current, get_max())
	if current <= 0.0:
		depleted.emit()


func fill() -> void:
	change(get_max() - current)


func is_empty() -> bool:
	return current <= 0.0
