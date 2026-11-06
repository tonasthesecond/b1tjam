# class_name Locator
extends Node

enum ID { Main, World, Devotee, Camera }

var _register: Dictionary[ID, Node] = {}


func register(id: ID, node: Node) -> void:
	_register[id] = node


func ref(id: ID) -> Node:
	if not _register.has(id):
		push_error("Locator: No node registered for name %s" % id)
		return null
	return _register[id]
