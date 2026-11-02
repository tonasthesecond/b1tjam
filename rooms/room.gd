class_name Room
extends Node


func _ready() -> void:
	Locator.register(Locator.ID.World, self)
