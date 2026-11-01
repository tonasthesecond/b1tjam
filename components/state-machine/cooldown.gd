class_name Cooldown
extends Timer

var _duration: Stat


func _init(duration: Stat = null) -> void:
	_duration = duration
	one_shot = true


# Reads the stat fresh each time, so buffs apply to the next cooldown.
func trigger() -> void:
	start(_duration.get_value())


func is_ready() -> bool:
	return is_stopped()
