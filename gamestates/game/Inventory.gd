extends Node

var capacity = 8
var items = []

func _init():
	for i in range(capacity):
		items.push_back(null)

func add(item):
	for index in range(capacity):
		if items[index] != null and items[index].type == item.type:
			items[index].quantity += item.quantity
			return true
	for index in range(capacity):
		if items[index] == null:
			items[index] = item
			return true
	return false

func remove(type, quantity):
	for index in range(capacity):
		if items[index] != null and items[index].type == type:
			items[index].quantity -= quantity
			if items[index].quantity == 0: items[index] = null
			return true
	return false

func get(type):
	for item in items:
		if item && item.type == type: return item
	return null

func reset():
	for i in range(capacity):
		items[i] = null