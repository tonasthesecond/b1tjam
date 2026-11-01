class_name IdleState extends State

var _body: CharacterBody2D

func _init(body: CharacterBody2D = null) -> void:
	_body = body

func enter() -> void:
	_body.velocity = Vector2.ZERO
