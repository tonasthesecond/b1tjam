class_name DevoteeData
extends Resource

@export var speed: Stat
@export var dash_duration: Stat
@export var dash_speed: Stat
@export var dash_cooldown: Stat
@export var pickup_range: Stat
@export var max_life: Stat

var life: Meter:
	get:
		if life == null:
			life = Meter.new(max_life)
		return life
