# shadow.gd, full file
class_name Shadow
extends CharacterBody2D

@onready var machine: StateMachine = %StateMachine
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var detector: DevoteeDetector = %DevoteeDetector

var _idle_wait: RandomRangeStat  # member, so the Callables below don't dangle


func _ready() -> void:
	var speed := Stats.get_stat(Stats.StatType.SHADOW_SPEED)
	var wander_radius := Stats.get_stat(Stats.StatType.SHADOW_WANDER_RADIUS)
	var idle_min := Stats.get_stat(Stats.StatType.SHADOW_IDLE_MIN)
	var idle_max := Stats.get_stat(Stats.StatType.SHADOW_IDLE_MAX)

	var wander_raw := WanderState.new(self, speed, wander_radius, global_position)

	var idle_timed := TimedState.new(IdleState.new(self))
	_idle_wait = RandomRangeStat.new(idle_min, idle_max)
	idle_timed.entered.connect(_idle_wait.reroll)

	var idle := AnimatedState.new(idle_timed, sprite, &"idle")
	var wander := AnimatedState.new(wander_raw, sprite, &"walk")
	var chase := AnimatedState.new(ChaseState.new(self, speed, detector), sprite, &"walk")

	var idle_over: Array[Condition] = [
		CondCompare.new(
			idle_timed.get_elapsed, CondCompare.Operator.GREATER_EQUAL, _idle_wait.get_value
		)
	]

	machine.add_transition(null, chase, [CondState.new(detector.sees)])
	machine.add_transition(chase, idle, [CondState.new(detector.sees, false)])
	machine.add_transition(wander, idle, [CondState.new(wander_raw.is_arrived)])
	machine.add_transition(idle, wander, idle_over)
	machine.start(idle)
