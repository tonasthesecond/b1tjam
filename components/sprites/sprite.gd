class_name Sprite
extends AnimatedSprite2D

var _reported_missing: Dictionary[StringName, bool] = {}


## Plays [param anim] if it exists. A missing animation is reported once per name, not on every call.
func play_animation(anim: StringName) -> void:
	if sprite_frames == null or not sprite_frames.has_animation(anim):
		if not _reported_missing.has(anim):
			_reported_missing[anim] = true
			push_warning("Sprite: missing animation '%s' on %s." % [anim, get_path()])
		return
	play(anim)


## Direction suffix of the current "<name>_<direction>" animation; defaults to down.
func facing_name() -> StringName:
	var suffix := String(animation).get_slice("_", String(animation).get_slice_count("_") - 1)
	match suffix:
		"up", "left", "right":
			return StringName(suffix)
		_:
			return &"down"


func facing_vector() -> Vector2:
	match facing_name():
		&"up":
			return Vector2.UP
		&"left":
			return Vector2.LEFT
		&"right":
			return Vector2.RIGHT
		_:
			return Vector2.DOWN
