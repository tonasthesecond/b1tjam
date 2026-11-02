class_name Detector
extends Area2D

@export var type: Script

@onready var collision_shape: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	if collision_mask == 0:
		push_error("Detector: Collision mask is not set.")


func get_detected() -> Node2D:
	var valid: Array[Node2D] = []
	for body in get_overlapping_bodies():
		if is_instance_of(body, type):
			valid.append(body)
	for area in get_overlapping_areas():
		if is_instance_of(area, type):
			valid.append(area)
	return Utils.closest(valid, global_position)


func is_detected() -> bool:
	return get_detected() != null


func set_radius(radius: float) -> void:
	var shape := collision_shape.shape
	if not shape is CircleShape2D:
		push_error("Collision shape is not a CircleShape2D.")
		return
	shape.radius = radius
