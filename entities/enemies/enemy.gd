class_name Enemy
extends CharacterBody2D

@export var speed: Stat
@export var wander_radius: Stat
@export var idle_min: Stat
@export var idle_max: Stat
@onready var machine: StateMachine = %StateMachine
@onready var sprite: Sprite = %Sprite
@onready var detector: DevoteeDetector = %DevoteeDetector
@onready var meter: Meter = %LifeMeter
@onready var hurtbox: Hurtbox = %Hurtbox

var _idle_wait: RandomRangeStat
var _knockback: KnockbackState


func _ready() -> void:
	meter.depleted.connect(_on_meter_depleted)

	hurtbox.hurt.connect(_on_hurt)

	var wander_raw := WanderState.new(self, speed, wander_radius, global_position)

	var idle_timed := TimedState.new(IdleState.new(self))
	_idle_wait = RandomRangeStat.new(idle_min, idle_max)
	idle_timed.entered.connect(_idle_wait.reroll)

	var idle := AnimatedState.new(idle_timed, sprite, &"idle")
	var wander := AnimatedState.new(wander_raw, sprite, &"walk")
	var chase := AnimatedState.new(ChaseState.new(self, speed, detector), sprite, &"walk")

	var idle_over := func() -> bool: return idle_timed.get_elapsed() >= _idle_wait.get_value()

	_knockback = KnockbackState.new(self)

	# Knockback first so it wins over every other transition while active.
	machine.add_transition(null, _knockback, [CondBool.new(_knockback.is_active)])
	machine.add_transition(_knockback, idle, [CondBool.new(_knockback.is_active, false)])
	machine.add_transition(
		null, chase, [CondBool.new(detector.is_detected), CondBool.new(_knockback.is_active, false)]
	)
	machine.add_transition(chase, idle, [CondBool.new(detector.is_detected, false)])
	machine.add_transition(wander, idle, [CondBool.new(wander_raw.is_arrived)])
	machine.add_transition(idle, wander, [CondBool.new(idle_over)])
	machine.start(idle)


func _on_meter_depleted() -> void:
	queue_free()


func _on_hurt(hitbox: Hitbox) -> void:
	_knockback.push(hitbox.get_knockback(global_position))
