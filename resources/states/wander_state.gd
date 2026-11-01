class_name WanderState
extends State

const ARRIVE_DISTANCE := 6.0

var _body: CharacterBody2D
var _speed: Stat
var _radius: Stat
var _origin: Vector2
var _destination: Vector2


func _init(
	body: CharacterBody2D = null,
	speed: Stat = null,
	radius: Stat = null,
	origin := Vector2.ZERO
) -> void:
	_body = body
	_speed = speed
	_radius = radius
	_origin = origin


func is_arrived() -> bool:
	return _body.global_position.distance_to(_destination) <= ARRIVE_DISTANCE


func enter() -> void:
	# sqrt(randf()) keeps points evenly spread over the disk instead of bunched at the center.
	var offset := Vector2.from_angle(randf_range(0.0, TAU)) * _radius.get_value() * sqrt(randf())
	_destination = _origin + offset


func update(_delta: float) -> void:
	var direction := _body.global_position.direction_to(_destination)
	_body.velocity = direction * _speed.get_value()
	_body.move_and_slide()
