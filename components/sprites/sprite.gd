class_name Sprite
extends AnimatedSprite2D


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
