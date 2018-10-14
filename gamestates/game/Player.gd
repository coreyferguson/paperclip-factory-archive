extends Node

signal add_building(building)
signal remove_building(building)
signal add_build_delivery(build_delivery)
signal remove_build_delivery(build_delivery)
signal add_bullet(bullet)
signal remove_bullet(bullet)

var buildings = {}
var build_deliveries = {}
var bullets = {}

func add_building(building):
	buildings[building] = true
	emit_signal('add_building', building)

func remove_building(building):
	buildings.erase(building)
	emit_signal('remove_building', building)
	building.queue_free()

func add_build_delivery(build_delivery):
	build_deliveries[build_delivery] = true
	emit_signal('add_build_delivery', build_delivery)

func remove_build_delivery(build_delivery):
	build_deliveries.erase(build_delivery)
	emit_signal('remove_build_delivery', build_delivery)
	build_delivery.queue_free()

func add_bullet(bullet):
	bullets[bullet] = true
	emit_signal('add_bullet', bullet)

func remove_bullet(bullet):
	bullets.erase(bullet)
	emit_signal('remove_bullet', bullet)
	bullet.queue_free()