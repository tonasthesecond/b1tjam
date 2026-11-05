class_name KnockbackState
extends State
## Shoved by a hit. Push it a velocity; it decays to zero, then is_active() goes false.

var _body: CharacterBody2D
var _decay: float
var _velocity := Vector2.ZERO


func _init(body: CharacterBody2D = null, decay := 800.0) -> void:
	_body = body
	_decay = decay


func push(velocity: Vector2) -> void:
	_velocity = velocity


func is_active() -> bool:
	return not _velocity.is_zero_approx()


func exit() -> void:
	_velocity = Vector2.ZERO


func update(delta: float) -> void:
	_velocity = _velocity.move_toward(Vector2.ZERO, _decay * delta)
	_body.velocity = _velocity
	_body.move_and_slide()
