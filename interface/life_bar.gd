class_name LifeBar
extends TextureProgressBar

@export var tracking: Health

@onready var label: Label = $Label


func _ready() -> void:
	if tracking == null:
		push_error("LifeBar: No Health assigned.")
		return
	tracking.changed.connect(_on_life_changed)
	if tracking.is_setup():
		_on_life_changed(tracking.current(), tracking.maximum())


func _on_life_changed(new_current: float, new_max: float) -> void:
	max_value = new_max
	value = new_current
	label.text = str(new_current) + " / " + str(new_max)
