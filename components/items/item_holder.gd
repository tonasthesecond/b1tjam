class_name ItemHolder
extends Node2D

signal picked_up(item: Item)
signal dropped(item: Item)

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


func drop() -> void:
	if held == null:
		return
	held.drop(get_parent().global_position)
	dropped.emit(held)
	held = null


func is_holding() -> bool:
	return held != null
