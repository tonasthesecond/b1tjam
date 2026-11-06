class_name Main
extends Node
## Keeps the Devotee, camera and HUD alive while swapping rooms under World.
## Visited rooms are cached detached, so they keep their state.

@export_file("*.tscn") var start_room: String
## Door to spawn at. Empty keeps the Devotee's position.
@export var start_link: StringName

var _rooms: Dictionary[String, Room] = {}
var _current: Room = null

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
	var next := _get_room(path)
	var held := devotee.item_holder.held
	if next != _current:
		# Enter the new room before leaving the old one, the Devotee and its item are carried over
		world.add_child(next)
		devotee.reparent(next.entities, false)
		if held:
			held.reparent(next.objects, false)
		if _current:
			world.remove_child(_current)
		_current = next
	if link:
		var door := next.find_door(link)
		if door:
			devotee.global_position = door.spawn.global_position
	if held:
		held.snap_to_holder()
	camera.snap()


func _get_room(path: String) -> Room:
	if not _rooms.has(path):
		_rooms[path] = load(path).instantiate()
	return _rooms[path]
