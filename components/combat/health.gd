class_name Health
extends Node
## Owns a life Meter. Call setup() with the max-life Stat once data is ready.
## Optionally takes damage automatically from a Hurtbox.

signal changed(current: float, maximum: float)
signal damaged(amount: float)
signal healed(amount: float)
signal depleted

## If set, hits on this Hurtbox deal their damage here.
@export var hurtbox: Hurtbox

var meter: Meter


func _ready() -> void:
	if hurtbox:
		hurtbox.hurt.connect(_on_hurt)


func setup(max_stat: Stat) -> void:
	meter = Meter.new(max_stat)
	meter.value_changed.connect(changed.emit)
	meter.depleted.connect(depleted.emit)
	changed.emit(current(), maximum())


func is_setup() -> bool:
	return meter != null


func damage(amount: float) -> void:
	if not meter or amount <= 0.0 or is_dead():
		return
	meter.change(-amount)
	damaged.emit(amount)


func heal(amount: float) -> void:
	if not meter or amount <= 0.0 or is_dead():
		return
	meter.change(amount)
	healed.emit(amount)


func fill() -> void:
	if meter:
		meter.fill()


func current() -> float:
	return meter.current if meter else 0.0


func maximum() -> float:
	return meter.max_stat.get_value() if meter else 0.0


func is_dead() -> bool:
	return meter != null and meter.current <= 0.0


func _on_hurt(hitbox: Hitbox) -> void:
	damage(hitbox.damage)
