class_name FollowCamera
extends Camera2D
## Smoothly follows a target. Defaults to the Devotee via Locator.

## Node to follow. If unset, uses the Devotee from Locator.
@export var target: Node2D
## Higher = snappier, lower = floatier.
@export var smoothing := 8.0
## Jump straight to the target on ready instead of easing in.
@export var snap_on_ready := true


func _enter_tree() -> void:
	Locator.register(Locator.ID.Camera, self)


func _ready() -> void:
	if target == null:
		target = Locator.ref(Locator.ID.Devotee) as Node2D
	if snap_on_ready:
		snap()


## Jump straight to the target.
func snap() -> void:
	if is_instance_valid(target):
		global_position = target.global_position


func _process(_delta: float) -> void:
	if not is_instance_valid(target):
		return
	global_position = Utils.standard_lerp(global_position, target.global_position, smoothing)
