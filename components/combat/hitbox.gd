class_name Hitbox
extends TimedArea
## Deals hits to Hurtboxes it overlaps while active.
## Put it on an attack layer and mask the layer the target Hurtboxes are on.

signal hit(hurtbox: Hurtbox)

@export var damage: Stat
## Speed imparted to a knocked-back target (pixels/sec). Null or 0 = none.
@export var knockback_force: Stat
## Keep hitting Hurtboxes that stay overlapped (body damage). The Hurtbox's
## invincibility time sets the rate; without it this hits every physics frame.
@export var continuous := false
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


func _physics_process(_delta: float) -> void:
	if not continuous or not active:
		return
	for area in get_overlapping_areas():
		_try_hit(area)


func _on_area_entered(area: Area2D) -> void:
	_try_hit(area)


func _try_hit(area: Area2D) -> void:
	var hurtbox := area as Hurtbox
	if hurtbox == null or not active:
		return
	if ignore_same_owner and owner != null and hurtbox.owner == owner:
		return
	if hurtbox.receive(self):
		hit.emit(hurtbox)


func get_damage() -> float:
	return damage.get_value() if damage else 0.0


## Knockback velocity for a target at target_pos, pushed away from this hitbox.
func get_knockback(target_pos: Vector2) -> Vector2:
	return global_position.direction_to(target_pos) * _knockback_value()


func _knockback_value() -> float:
	return knockback_force.get_value() if knockback_force else 0.0
