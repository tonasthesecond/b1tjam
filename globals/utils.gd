extends Node

func sum_array(arr: Array[float]) -> float:
	return arr.reduce(func(acc, b): return acc + b, 0.0)
