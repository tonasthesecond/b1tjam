class_name RandomRangeStat
extends Stat

var _min_stat: Stat
var _max_stat: Stat


func _init(min_stat: Stat = null, max_stat: Stat = null) -> void:
	_min_stat = min_stat
	_max_stat = max_stat
	reroll()


func reroll() -> void:
	base = randf_range(_min_stat.get_value(), _max_stat.get_value())
