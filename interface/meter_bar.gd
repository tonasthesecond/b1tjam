class_name MeterBar
extends TextureProgressBar
## Generic bar that displays a Meter.

@export var tracking: Meter

@onready var label: Label = $Label


func _ready() -> void:
	if tracking == null:
		push_error("MeterBar: No Meter assigned.")
		return
	tracking.value_changed.connect(_on_changed)
	_on_changed(tracking.current, tracking.get_max())


func _on_changed(new_current: float, new_max: float) -> void:
	max_value = new_max
	value = new_current
	label.text = str(new_current) + " / " + str(new_max)
