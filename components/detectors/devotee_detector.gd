class_name DevoteeDetector
extends Area2D


func get_devotee() -> Devotee:
	for body in get_overlapping_bodies():
		if body is Devotee:
			return body
	return null


func sees() -> bool:
	return get_devotee() != null
