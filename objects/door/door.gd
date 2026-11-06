class_name Door
extends Area2D
## Sends the Devotee to the door sharing its link in another room.

## Room this door leads to.
@export_file("*.tscn") var target_room: String
## Shared by both ends of a connection.
@export var link: StringName

@onready var spawn: Marker2D = %Spawn


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Devotee:
		var main := Locator.ref(Locator.ID.Main) as Main
		main.go_to.call_deferred(target_room, link)
