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
