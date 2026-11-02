class_name Detector
extends Area2D

@export var type: Script

@onready var collision_shape: CollisionShape2D = %CollisionShape2D


func get_detected() -> Node:
	for body in get_overlapping_bodies():
		if is_instance_of(body, type):
			return body
	return null


func is_detected() -> bool:
	return get_detected() != null


func set_radius(radius: float) -> void:
	var shape := collision_shape.shape
	if not shape is CircleShape2D:
		push_error("Collision shape is not a CircleShape2D.")
		return
	shape.radius = radius
