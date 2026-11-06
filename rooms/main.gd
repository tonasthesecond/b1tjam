class_name Main
extends Node
## Keeps the Devotee, camera and HUD alive while swapping rooms under World.
## Visited rooms are cached detached, so they keep their state.

@export_file("*.tscn") var start_room: String
## Door to spawn at. Empty keeps the Devotee's position.
@export var start_link: StringName

var _rooms: Dictionary[String, Room] = {}
var _current: Room = null
var _moved_frame := -1

@onready var world: Node = %World
@onready var devotee: Devotee = %Devotee
@onready var camera: FollowCamera = %FollowCamera


func _enter_tree() -> void:
	Locator.register(Locator.ID.Main, self)


func _ready() -> void:
	go_to.call_deferred(start_room, start_link)


func _notification(what: int) -> void:
	# Detached rooms are orphans, so they must be freed by hand
	if what == NOTIFICATION_PREDELETE:
		for room: Room in _rooms.values():
			if not room.is_inside_tree():
				room.free()


func go_to(path: String, link: StringName) -> void:
	_moved_frame = Engine.get_physics_frames()
	var next := _get_room(path)
	if next != _current:
		_carry_over(next)
	if link:
		var door := next.find_door(link)
		if door:
			devotee.global_position = door.spawn.global_position
	var held := devotee.item_holder.held
	if held:
		held.snap_to_holder()
	camera.snap()


## Kinematic bodies teleport a physics step late, so right after a transition
## the new room's doors can still see the Devotee at its old position.
func is_settling() -> bool:
	return Engine.get_physics_frames() - _moved_frame < 2


## Enters the next room before leaving the old one, carrying over the Devotee and its held item.
func _carry_over(next: Room) -> void:
	world.add_child(next)
	devotee.reparent(next.entities, false)
	var held := devotee.item_holder.held
	if held:
		held.reparent(next.objects, false)
	if _current:
		world.remove_child(_current)
	_current = next


func _get_room(path: String) -> Room:
	if not _rooms.has(path):
		_rooms[path] = load(path).instantiate()
	return _rooms[path]
