class_name ChaseState
extends State

var _body: CharacterBody2D
var _speed: Stat
var _detector: DevoteeDetector


func _init(
	body: CharacterBody2D = null, speed: Stat = null, detector: DevoteeDetector = null
) -> void:
	_body = body
	_speed = speed
	_detector = detector


func update(_delta: float) -> void:
	var devotee := _detector.get_detected()
	if devotee == null:
		return
	var direction := _body.global_position.direction_to(devotee.global_position)
	_body.velocity = direction * _speed.get_value()
	_body.move_and_slide()
