class_name WalkState extends State

var _body: CharacterBody2D
var _speed: Stat

func _init(body: CharacterBody2D = null, speed: Stat = null) -> void:
	_body = body
	_speed = speed

func update(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	_body.velocity = direction * _speed.get_value()
	_body.move_and_slide()
