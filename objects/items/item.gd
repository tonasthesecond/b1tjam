class_name Item
extends Area2D

@onready var sprite: Sprite = %Sprite

var holder: ItemHolder


func hold(_holder: ItemHolder) -> void:
	holder = _holder
	reparent(holder)
	position = Vector2.ZERO
	monitorable = false


func drop(new_pos: Vector2) -> void:
	holder = null
	reparent(Locator.ref(Locator.ID.World))
	position = new_pos
	monitorable = true
