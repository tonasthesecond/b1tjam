# class_name Stats
extends Node

# Stat names
enum Name {
	DEVOTEE_SPEED,
	DEVOTEE_DASH_DURATION,
	DEVOTEE_DASH_SPEED,
	DEVOTEE_DASH_COOLDOWN,
	DEVOTEE_PICKUP_RANGE,
	SHADOW_SPEED,
	ENEMY_SIGHT_RANGE,
	ENEMY_WANDER_RADIUS,
	ENEMY_IDLE_MIN,
	ENEMY_IDLE_MAX,
}

var stats: Dictionary[Name, Stat] = {
	Name.DEVOTEE_SPEED: Stat.new(200, 50),
	Name.DEVOTEE_DASH_DURATION: Stat.new(0.2, 0),
	Name.DEVOTEE_DASH_SPEED: Stat.new(600, 0),
	Name.DEVOTEE_DASH_COOLDOWN: Stat.new(0.3, 0),
	Name.DEVOTEE_PICKUP_RANGE: Stat.new(50, 0),
	Name.SHADOW_SPEED: Stat.new(80, 0),
	Name.ENEMY_SIGHT_RANGE: Stat.new(200, 0),
	Name.ENEMY_WANDER_RADIUS: Stat.new(120, 0),
	Name.ENEMY_IDLE_MIN: Stat.new(1.0, 0),
	Name.ENEMY_IDLE_MAX: Stat.new(3.0, 0),
}


func get_stat(stat_name: Name) -> Stat:
	if stats.has(stat_name):
		return stats[stat_name]
	else:
		push_error("Stat type %s not found." % str(stat_name))
		return null


func stat(stat_name: Name) -> Stat:
	return get_stat(stat_name)
