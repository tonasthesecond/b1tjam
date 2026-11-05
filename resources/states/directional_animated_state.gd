class_name DirectionalAnimatedState
extends AnimatedState

var _get_direction: Callable
var _facing: StringName = &"down"
var _previous_direction: Vector2 = Vector2.ZERO
var _vertical_is_newest: bool = true
var _grace_left: float = 0.0

## When one of two held directions is released, hold the current facing for this long
## (seconds) so letting go of both keys slightly apart doesn't flip the facing.
var release_grace: float = 0.08


func _init(
	inner: State = null,
	sprite: Sprite = null,
	direction_source: Callable = Callable(),
	enter_animation: StringName = &"",
	exit_animation: StringName = &""
) -> void:
	super(inner, sprite, enter_animation, exit_animation)
	_get_direction = direction_source


func enter() -> void:
	_inner.enter()
	_previous_direction = Vector2.ZERO
	_grace_left = 0.0
	_facing = _sprite.facing_name()
	_refresh_facing(0.0)
	_play(_enter_animation)


func exit() -> void:
	_inner.exit()
	_refresh_facing(0.0)
	_play(_exit_animation)


func update(delta: float) -> void:
	_inner.update(delta)
	var old_facing := _facing
	_refresh_facing(delta)
	if _facing != old_facing:
		_play(_enter_animation)


func _play(base_name: StringName) -> void:
	if base_name == &"":
		return
	_sprite.play_animation(StringName("%s_%s" % [base_name, _facing]))


func _refresh_facing(delta: float) -> void:
	var direction: Vector2 = _get_direction.call()
	var x_held := not is_zero_approx(direction.x)
	var y_held := not is_zero_approx(direction.y)
	var x_pressed := x_held and signf(direction.x) != signf(_previous_direction.x)
	var y_pressed := y_held and signf(direction.y) != signf(_previous_direction.y)
	var held_count := int(x_held) + int(y_held)
	var previous_held_count := (
		int(not is_zero_approx(_previous_direction.x))
		+ int(not is_zero_approx(_previous_direction.y))
	)
	_previous_direction = direction

	if held_count == 0:
		# Everything released: keep facing as is.
		_grace_left = 0.0
		return
	if x_pressed or y_pressed:
		_grace_left = 0.0
	elif held_count < previous_held_count:
		_grace_left = release_grace
	if _grace_left > 0.0:
		_grace_left -= delta
		if _grace_left > 0.0:
			return

	if x_pressed and not y_pressed:
		_vertical_is_newest = false
	elif y_pressed and not x_pressed:
		_vertical_is_newest = true

	if x_held and (not y_held or not _vertical_is_newest):
		_facing = &"right" if direction.x > 0.0 else &"left"
	elif y_held:
		_facing = &"down" if direction.y > 0.0 else &"up"
