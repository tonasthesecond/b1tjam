# class_name Stats
extends Node

enum StatType {
	DEVOTEE_SPEED,
	DEVOTEE_DASH_DURATION,
	DEVOTEE_DASH_SPEED,
	DEVOTEE_DASH_COOLDOWN,
	SHADOW_SPEED,
	SHADOW_SIGHT_RANGE,
	SHADOW_WANDER_RADIUS,
	SHADOW_IDLE_MIN,
	SHADOW_IDLE_MAX,
}

var stats: Dictionary[StatType, Stat] = {
	StatType.DEVOTEE_SPEED: Stat.new(200, 50),
	StatType.DEVOTEE_DASH_DURATION: Stat.new(0.2, 0),
	StatType.DEVOTEE_DASH_SPEED: Stat.new(600, 0),
	StatType.DEVOTEE_DASH_COOLDOWN: Stat.new(0.3, 0),
	StatType.SHADOW_SPEED: Stat.new(80, 0),
	StatType.SHADOW_SIGHT_RANGE: Stat.new(200, 0),
	StatType.SHADOW_WANDER_RADIUS: Stat.new(120, 0),
	StatType.SHADOW_IDLE_MIN: Stat.new(1.0, 0),
	StatType.SHADOW_IDLE_MAX: Stat.new(3.0, 0),
}


func get_stat(stat_type: StatType) -> Stat:
	if stats.has(stat_type):
		return stats[stat_type]
	else:
		push_error("Stat type %s not found." % str(stat_type))
		return null
