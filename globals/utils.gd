extends Node


func sum(arr: Array[float]) -> float:
	return arr.reduce(func(acc, b): return acc + b, 0.0)


func closest(arr: Array[Node2D], point: Vector2) -> Node2D:
	return arr.reduce(
		func(a, b):
			return (
				a
				if (
					point.distance_squared_to(a.global_position)
					< point.distance_squared_to(b.global_position)
				)
				else b
			)
	)


func input_vector() -> Vector2:
	return Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")


## Natural framerate independent lerp function.
## - smoothing: higher = fast/snappy, lower = slow/smooth
func standard_lerp(a: Variant, b: Variant, smoothing: float) -> Variant:
	return lerp(a, b, 1 - exp(-smoothing * get_process_delta_time()))
