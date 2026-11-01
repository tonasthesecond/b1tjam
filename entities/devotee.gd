class_name Devotee
extends CharacterBody2D

@onready var machine: StateMachine = %StateMachine
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D


func _ready() -> void:
	var speed := Stats.get_stat(Stats.StatType.DEVOTEE_SPEED)
	var dash_speed := Stats.get_stat(Stats.StatType.DEVOTEE_DASH_SPEED)
	var dash_duration := Stats.get_stat(Stats.StatType.DEVOTEE_DASH_DURATION)

	var dash_cooldown := Cooldown.new(Stats.get_stat(Stats.StatType.DEVOTEE_DASH_COOLDOWN))
	add_child(dash_cooldown)  # has to be in the tree to tick

	var dash_raw := DashState.new(self, dash_speed, dash_duration, dash_cooldown)

	var idle := AnimatedState.new(IdleState.new(self), sprite, &"idle")
	var walk := AnimatedState.new(WalkState.new(self, speed), sprite, &"walk")
	var dash := AnimatedState.new(dash_raw, sprite, &"dash")

	var dash_pressed: Array[Condition] = [
		CondActionPressed.new(&"dash"), CondState.new(dash_cooldown.is_ready)
	]
	machine.add_transition(idle, dash, dash_pressed)
	machine.add_transition(walk, dash, dash_pressed)
	machine.add_transition(dash, walk, [CondState.new(dash_raw.is_done), CondMoveInput.new(true)])
	machine.add_transition(dash, idle, [CondState.new(dash_raw.is_done)])
	machine.add_transition(idle, walk, [CondMoveInput.new(true)])
	machine.add_transition(walk, idle, [CondMoveInput.new(false)])
	machine.start(idle)
