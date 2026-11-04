class_name Enemy
extends CharacterBody2D

@export var data_template: EnemyData
@onready var machine: StateMachine = %StateMachine
@onready var sprite: Sprite = %Sprite
@onready var detector: DevoteeDetector = %DevoteeDetector
@onready var health: Health = %Health

var _idle_wait: RandomRangeStat


func _ready() -> void:
	var data: EnemyData = data_template.duplicate(true)

	health.setup(data.max_life)
	health.depleted.connect(_on_life_depleted)

	var speed := data.speed
	var wander_radius := data.wander_radius
	var idle_min := data.idle_min
	var idle_max := data.idle_max

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


func _on_life_depleted() -> void:
	queue_free()
