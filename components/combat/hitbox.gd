class_name Hitbox
extends TimedArea
## Deals hits to Hurtboxes it overlaps while active.
## Put it on an attack layer and mask the layer the target Hurtboxes are on.

signal hit(hurtbox: Hurtbox)

@export var damage := 1.0
## Skip Hurtboxes that belong to the same scene owner (e.g. your own body).
@export var ignore_same_owner := true


func _ready() -> void:
	monitorable = false
	area_entered.connect(_on_area_entered)
	super()
	if collision_mask == 0:
		push_error("Hitbox: Collision mask is not set.")


func _apply_active(value: bool) -> void:
	set_deferred(&"monitoring", value)


func _on_area_entered(area: Area2D) -> void:
	var hurtbox := area as Hurtbox
	if hurtbox == null or not active:
		return
	if ignore_same_owner and owner != null and hurtbox.owner == owner:
		return
	if hurtbox.receive(self):
		hit.emit(hurtbox)


func set_damage(value: float) -> void:
	damage = value
