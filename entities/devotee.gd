class_name Devotee
extends CharacterBody2D

@onready var machine: StateMachine = %StateMachine
@onready var sprite: Sprite = %Sprite

const N = Stats.Name

var current_item: Item = null


func _ready() -> void:
	var speed := Stats.stat(N.DEVOTEE_SPEED)
	var dash_speed := Stats.stat(N.DEVOTEE_DASH_SPEED)
	var dash_duration := Stats.stat(N.DEVOTEE_DASH_DURATION)

	var dash_cooldown := Cooldown.new(self, Stats.stat(N.DEVOTEE_DASH_COOLDOWN))
	var dash_raw := DashState.new(self, dash_speed, dash_duration, dash_cooldown)
	var idle := AnimatedState.new(IdleState.new(self), sprite, &"idle")
	var walk := AnimatedState.new(WalkState.new(self, speed), sprite, &"walk")
	var dash := AnimatedState.new(dash_raw, sprite, &"dash")

	var dash_pressed: Array[Condition] = [
		CondActionPressed.new(&"dash"), CondBool.new(dash_cooldown.is_ready)
	]
	machine.add_transition(idle, dash, dash_pressed)
	machine.add_transition(walk, dash, dash_pressed)
	machine.add_transition(dash, walk, [CondBool.new(dash_raw.is_done), CondMoveInput.new(true)])
	machine.add_transition(dash, idle, [CondBool.new(dash_raw.is_done)])
	machine.add_transition(idle, walk, [CondMoveInput.new(true)])
	machine.add_transition(walk, idle, [CondMoveInput.new(false)])
	machine.start(idle)
