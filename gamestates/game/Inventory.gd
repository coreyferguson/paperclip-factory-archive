extends Node

signal change

var capacity = 3
var items = []
var NaturalResource

func _init():
	for i in range(capacity):
		items.push_back(null)

func _ready():
	if has_node('/root/NaturalResource'): NaturalResource = get_node('/root/NaturalResource')
	else: NaturalResource = load('res://gamestates/game/NaturalResource.gd').new()
	reset()

func add(item):
	for index in range(capacity):
		if items[index] != null and items[index].type == item.type:
			items[index].quantity += item.quantity
			emit_signal('change')
			return true
	for index in range(capacity):
		if items[index] == null:
			items[index] = item
			emit_signal('change')
			return true
	return false

func remove(type, quantity):
	for index in range(capacity):
		if items[index] != null and items[index].type == type:
			items[index].quantity -= quantity
			if items[index].quantity <= 0: items[index] = null
			emit_signal('change')
			return true
	return false

func has(type):
	for item in items:
		if item && item.type == type: return true
	return false

func get(type):
	for item in items:
		if item && item.type == type: return item
	return null

func reset():
	for i in range(capacity):
		items[i] = null
	items[0] = {
		'type': 'energy',
		'quantity': 30,
		'texture': NaturalResource.types['energy'].world_texture
	}
