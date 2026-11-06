class_name Item
extends Area2D

## Higher = snappier follow, lower = floatier.
@export var follow_smoothing: float = 5.0
## Offset from the holder's global position that the item trails towards.
@export var follow_offset: Vector2 = Vector2.ZERO
## Smoothing used when easing to the drop position.
@export var drop_smoothing: float = 12.0
## Stop easing and snap once closer than this (pixels).
@export var follow_snap_distance: float = 0.5

@onready var sprite: Sprite = %Sprite

var holder: ItemHolder
var _drop_target: Vector2
var _dropping := false


func _process(_delta: float) -> void:
	if holder != null:
		_ease_to(holder.global_position + follow_offset, follow_smoothing)
	elif _dropping:
		if _ease_to(_drop_target, drop_smoothing):
			_dropping = false
			monitorable = true


## Eases towards target; returns true once arrived.
func _ease_to(target: Vector2, smoothing: float) -> bool:
	global_position = Utils.standard_lerp(global_position, target, smoothing)
	if global_position.distance_to(target) < follow_snap_distance:
		global_position = target
		return true
	return false


func hold(_holder: ItemHolder) -> void:
	holder = _holder
	_dropping = false
	monitorable = false


## Jump straight to the holder instead of trailing in.
func snap_to_holder() -> void:
	if holder != null:
		global_position = holder.global_position + follow_offset


func drop(new_pos: Vector2) -> void:
	holder = null
	_drop_target = new_pos
	_dropping = true
