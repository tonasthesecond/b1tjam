class_name Ticker
extends Timer
## Emits `ticked` every `interval` seconds while running.
## The interval is a Stat, so it can be modified at runtime.

signal ticked

var _interval: Stat


func _init(parent: Node, interval := Stat.new(1.0), autostart := true) -> void:
	_interval = interval
	one_shot = true  # restarted manually so interval changes apply on the next tick
	parent.add_child(self)
	timeout.connect(_on_timeout)
	if autostart:
		begin()


func begin() -> void:
	start(_interval.get_value())


func halt() -> void:
	stop()


func _on_timeout() -> void:
	ticked.emit()
	start(_interval.get_value())
