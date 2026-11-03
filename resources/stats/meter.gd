class_name Meter
extends Resource

signal value_changed(new_current: float, new_max: float)
signal depleted

var max_stat: Stat
var current: float


func _init(_max_stat: Stat) -> void:
	max_stat = _max_stat
	current = max_stat.get_value()


func change(amount: float) -> void:
	var proposed := current + amount
	var clamped := clampf(proposed, 0.0, max_stat.get_value())
	if is_equal_approx(clamped, current):
		return
	current = clamped
	value_changed.emit(current, max_stat.get_value())
	if current <= 0.0:
		depleted.emit()


func fill() -> void:
	change(max_stat.get_value() - current)
