class_name VisionMask
extends ColorRect
## Covers everything outside a circle around the screen centre with the dark colour.

## Visible radius, in world pixels.
@export var radius: Stat
@export var dark_color := Color("010203")


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	(material as ShaderMaterial).set_shader_parameter(&"dark_color", dark_color)


func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	var zoom := camera.zoom.x if camera else 1.0
	var mat := material as ShaderMaterial
	mat.set_shader_parameter(&"rect_size", size)
	mat.set_shader_parameter(&"radius", radius.get_value() * zoom)
	mat.set_shader_parameter(&"pixel_size", zoom)
