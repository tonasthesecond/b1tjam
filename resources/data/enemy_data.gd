class_name EnemyData
extends Resource

@export var speed: Stat
@export var wander_radius: Stat
@export var idle_min: Stat
@export var idle_max: Stat
@export var sight_range: Stat
@export var max_life: Stat

var life: Meter:
	get:
		if life == null:
			life = Meter.new(max_life)
		return life
