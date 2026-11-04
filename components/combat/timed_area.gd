class_name TimedArea
extends Area2D
## Area2D that can be switched on/off, either indefinitely or for a duration.
## After a timed switch it flips back to the opposite state.

signal activated
signal deactivated

@export var start_active := true

var active := false

var _timer := Timer.new()


func _ready() -> void:
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	add_child(_timer)
	_set_active(start_active)


## Turn on. duration <= 0 means indefinitely; otherwise turns off afterwards.
func activate(duration := 0.0) -> void:
	_set_active(true)
	_schedule(duration)


## Turn off. duration <= 0 means indefinitely; otherwise turns back on afterwards.
func deactivate(duration := 0.0) -> void:
	_set_active(false)
	_schedule(duration)


## Seconds left before the current timed state flips, or 0 if indefinite.
func time_left() -> float:
	return _timer.time_left


## Override to choose which Area2D flags get toggled.
func _apply_active(_value: bool) -> void:
	pass


func _schedule(duration: float) -> void:
	if duration > 0.0:
		_timer.start(duration)
	else:
		_timer.stop()


func _set_active(value: bool) -> void:
	var changed := value != active
	active = value
	_apply_active(value)
	if changed:
		(activated if value else deactivated).emit()


func _on_timer_timeout() -> void:
	_set_active(not active)
