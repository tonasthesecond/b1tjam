class_name Stat
extends Resource

@export var base: float = 0.0:
	set(new_value):
		base = clampf(new_value, min_value, max_value)
@export var min_value: float = -INF
@export var max_value: float = INF

var bonus: Array[float] = []
var mult: Array[float] = []


func _init(_base: float = 0.0, _min_value: float = -INF, _max_value: float = INF) -> void:
	min_value = _min_value
	max_value = _max_value
	base = _base


func get_value() -> float:
	var total_bonus = Utils.sum(bonus)
	var total_mult = 1.0 + Utils.sum(mult)
	var value = (base + total_bonus) * total_mult
	return clampf(value, min_value, max_value)


func add_bonus(b: float) -> void:
	bonus.append(b)


func add_mult(m: float) -> void:
	mult.append(m)


func clear_bonuses() -> void:
	bonus.clear()


func clear_mults() -> void:
	mult.clear()


func clear_all() -> void:
	clear_bonuses()
	clear_mults()


func set_base(new_base: float) -> void:
	base = clampf(new_base, min_value, max_value)
