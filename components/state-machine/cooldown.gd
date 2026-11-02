class_name Cooldown
extends Timer

var _duration: Stat


func _init(parent: Node, duration := Stat.new(1.0)) -> void:
	_duration = duration
	one_shot = true
	parent.add_child(self)


func trigger() -> void:
	start(_duration.get_value())


func is_ready() -> bool:
	return is_stopped()
