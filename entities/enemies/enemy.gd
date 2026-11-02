class_name Enemy
extends CharacterBody2D

@onready var machine: StateMachine = %StateMachine
@onready var sprite: Sprite = %Sprite
@onready var detector: DevoteeDetector = %DevoteeDetector

var _idle_wait: RandomRangeStat


func _ready() -> void:
	var speed := Stats.get_stat(Stats.Name.SHADOW_SPEED)
	var wander_radius := Stats.get_stat(Stats.Name.ENEMY_WANDER_RADIUS)
	var idle_min := Stats.get_stat(Stats.Name.ENEMY_IDLE_MIN)
	var idle_max := Stats.get_stat(Stats.Name.ENEMY_IDLE_MAX)

	var wander_raw := WanderState.new(self, speed, wander_radius, global_position)

	var idle_timed := TimedState.new(IdleState.new(self))
	_idle_wait = RandomRangeStat.new(idle_min, idle_max)
	idle_timed.entered.connect(_idle_wait.reroll)

	var idle := AnimatedState.new(idle_timed, sprite, &"idle")
	var wander := AnimatedState.new(wander_raw, sprite, &"walk")
	var chase := AnimatedState.new(ChaseState.new(self, speed, detector), sprite, &"walk")

	var idle_over := func() -> bool: return idle_timed.get_elapsed() >= _idle_wait.get_value()

	machine.add_transition(null, chase, [CondBool.new(detector.is_detected)])
	machine.add_transition(chase, idle, [CondBool.new(detector.is_detected, false)])
	machine.add_transition(wander, idle, [CondBool.new(wander_raw.is_arrived)])
	machine.add_transition(idle, wander, [CondBool.new(idle_over)])
	machine.start(idle)
