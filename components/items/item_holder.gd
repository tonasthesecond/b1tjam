class_name ItemHolder
extends Node2D

signal picked_up(item: Item)
signal dropped(item: Item)

## How far in front of the holder's owner items land when dropped.
@export var drop_distance: float = 24.0

@onready var detector: ItemDetector = %ItemDetector

var held: Item


func try_pick_up() -> bool:
	var item := detector.get_detected()
	return item != null and _hold(item)


func _hold(item: Item) -> bool:
	if held != null:
		return false
	held = item
	item.hold(self)
	picked_up.emit(item)
	return true


func drop(facing: Vector2 = Vector2.DOWN) -> void:
	if held == null:
		return
	held.drop(get_parent().global_position + facing * drop_distance)
	dropped.emit(held)
	held = null


func is_holding() -> bool:
	return held != null


func set_radius(radius: float) -> void:
	detector.set_radius(radius)
