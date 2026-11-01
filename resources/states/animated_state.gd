class_name AnimatedState extends State

var _inner: State
var _sprite: AnimatedSprite2D
var _enter_animation: StringName
var _exit_animation: StringName

# Empty animation name = don't play anything on that edge.
func _init(inner: State = null, sprite: AnimatedSprite2D = null, enter_animation: StringName = &"", exit_animation: StringName = &"") -> void:
	_inner = inner
	_sprite = sprite
	_enter_animation = enter_animation
	_exit_animation = exit_animation

func enter() -> void:
	_inner.enter()
	if _enter_animation != &"":
		_sprite.play(_enter_animation)

func exit() -> void:
	_inner.exit()
	if _exit_animation != &"":
		_sprite.play(_exit_animation)

func update(delta: float) -> void:
	_inner.update(delta)
