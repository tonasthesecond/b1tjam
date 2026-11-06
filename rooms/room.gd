class_name Room
extends Node

@onready var entities: Node2D = %Entities
@onready var objects: Node2D = %Objects
@onready var doors: Node2D = %Doors


func _enter_tree() -> void:
	# Rooms are re-entered from the cache, so register on every entry
	Locator.register(Locator.ID.World, self)


func find_door(link: StringName) -> Door:
	for door: Door in doors.get_children():
		if door.link == link:
			return door
	push_error("Room %s: No door with link %s" % [name, link])
	return null
