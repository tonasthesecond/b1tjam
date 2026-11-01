class_name DashState
extends State

var _body: CharacterBody2D
var _speed: Stat
var _duration: Stat
var _cooldown: Cooldown
var _dash_direction := Vector2.RIGHT
var _elapsed := 0.0


func _init(
	body: CharacterBody2D = null,
	speed: Stat = null,
	duration: Stat = null,
	cooldown: Cooldown = null
) -> void:
	_body = body
	_speed = speed
	_duration = duration
	_cooldown = cooldown


func is_done() -> bool:
	return _elapsed >= _duration.get_value()


func enter() -> void:
	_elapsed = 0.0
	var input_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_direction != Vector2.ZERO:
		_dash_direction = input_direction.normalized()


func exit() -> void:
	_cooldown.trigger()


func update(delta: float) -> void:
	_elapsed += delta
	_body.velocity = _dash_direction * _speed.get_value()
	_body.move_and_slide()
