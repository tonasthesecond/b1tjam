class_name Devotee
extends CharacterBody2D

@export var data: DevoteeData
@onready var machine: StateMachine = %StateMachine
@onready var sprite: Sprite = %Sprite
@onready var item_holder: ItemHolder = %ItemHolder

var current_item: Item = null


func _enter_tree() -> void:
	# Register with the locator
	Locator.register(Locator.ID.Devotee, self)


func _ready() -> void:
	# Setup nodes
	item_holder.set_radius(data.pickup_range.get_value())
	var life_drain := Ticker.new(self, Stat.new(1.0))
	life_drain.ticked.connect(data.life.change.bind(-1.0))
	data.life.depleted.connect(_on_life_depleted)

	# Set up the state machine
	var speed := data.speed
	var dash_speed := data.dash_speed
	var dash_duration := data.dash_duration

	var dash_cooldown := Cooldown.new(self, data.dash_cooldown)
	var dash_raw := DashState.new(self, dash_speed, dash_duration, dash_cooldown)

	var idle := DirectionalAnimatedState.new(
		IdleState.new(self), sprite, Utils.input_vector, &"idle"
	)
	var walk := DirectionalAnimatedState.new(
		WalkState.new(self, speed), sprite, Utils.input_vector, &"walk"
	)
	var dash := DirectionalAnimatedState.new(dash_raw, sprite, Utils.input_vector, &"dash")

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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		if item_holder.is_holding():
			item_holder.drop(sprite.facing_vector())
		else:
			item_holder.try_pick_up()


func _on_life_depleted() -> void:
	pass
