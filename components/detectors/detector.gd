class_name Detector
extends Area2D

@export var type: Script
## How far the detector reaches. Drives the radius of its circle shape.
@export var detection_range: Stat

@onready var collision_shape: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	if collision_mask == 0:
		push_error("Detector: Collision mask is not set.")
	if detection_range == null:
		return
	# The shape is shared by every instance of the scene, so give this one its own copy.
	collision_shape.shape = collision_shape.shape.duplicate()
	_apply_range(detection_range.get_value())
	detection_range.value_changed.connect(_apply_range)


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


func _apply_range(radius: float) -> void:
	var shape := collision_shape.shape
	if not shape is CircleShape2D:
		push_error("Collision shape is not a CircleShape2D.")
		return
	shape.radius = radius
