class_name Hurtbox
extends TimedArea
## Receives hits from Hitboxes. Optionally goes invincible after each hit.
## Put it on the owner's layer so enemy Hitboxes can mask it.

signal hurt(hitbox: Hitbox)

## Seconds of invincibility after a hit. 0 = none.
@export var invincibility_time := 0.0


func _ready() -> void:
	monitoring = false
	super()
	if collision_layer == 0:
		push_error("Hurtbox: Collision layer is not set.")


func _apply_active(value: bool) -> void:
	set_deferred(&"monitorable", value)


## Returns true if the hit landed.
func receive(hitbox: Hitbox) -> bool:
	if not active:
		return false
	hurt.emit(hitbox)
	if invincibility_time > 0.0:
		deactivate(invincibility_time)
	return true
