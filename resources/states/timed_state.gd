class_name TimedState
extends State

signal entered

var _inner: State
var _elapsed := 0.0


func _init(inner: State = null) -> void:
	_inner = inner


func get_elapsed() -> float:
	return _elapsed


func enter() -> void:
	_elapsed = 0.0
	_inner.enter()
	entered.emit()


func exit() -> void:
	_inner.exit()


func update(delta: float) -> void:
	_elapsed += delta
	_inner.update(delta)
