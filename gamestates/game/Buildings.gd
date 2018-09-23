extends Node

signal add_building(building)
signal remove_building(building)

var buildings = {}

func add_building(building):
	buildings[building] = true
	emit_signal('add_building', building)

func remove_building(building):
	buildings.erase(building)
	emit_signal('remove_building', building)
	building.queue_free()
