extends StaticBody2D

export (int) var antiship_mine_capacity = 10
export (int) var antimissile_mine_capacity = 10
export (int) var mine_placement_min_distance = 100
export (int) var mine_placement_max_distance = 400

var antiship_mine_resource = load('res://gameplay/Mine.tscn')
var antimissile_mine_resource = load('res://gameplay/LowYieldMine.tscn')
var build_delivery_resource = load('res://gameplay/BuildDelivery.tscn')

onready var game = $'/root/Game'
onready var ship_detector = $ShipDetector
onready var missile_detector = $MissileDetector
onready var antiship_mine_current = antiship_mine_capacity
onready var antimissile_mine_current = antimissile_mine_capacity

enum State { BUILDING, ACTIVE }
onready var state = State.BUILDING
var build_time_required = 5
onready var build_time_current = 0
onready var build_progress = $BuildProgress
onready var build_timer = $BuildTimer

func _ready():
	buildings.add_building(self)

func _on_DetectorTimer_timeout():
	if state == State.ACTIVE:
		if antiship_mine_current > 0:
			var ships = ship_detector.get_overlapping_bodies()
			for ship in ships: deploy_antiship_mine(ship)
		if antimissile_mine_current > 0:
			var missiles = missile_detector.get_overlapping_bodies()
			for missile in missiles: deploy_antimissile_mine(missile)
		if antiship_mine_current == 0 and antimissile_mine_current == 0:
			buildings.remove_building(self)

func deploy_antiship_mine(ship):
	deploy_mine(antiship_mine_resource, ship)

func deploy_antimissile_mine(missile):
	deploy_mine(antimissile_mine_resource, missile)

func deploy_mine(mine_resource, target):
	if antimissile_mine_current == 0: return
	antiship_mine_current -= 1
	var distance = position.distance_to(target.position) - 200
#	if distance < mine_placement_max_distance: distance -= 200 # try to place in front of enemy
	distance = clamp(distance, mine_placement_min_distance, mine_placement_max_distance)
	var build_position = target.position - position
	build_position = build_position.normalized() * distance
	var build_delivery_instance = build_delivery_resource.instance()
	build_delivery_instance.position = position
	build_delivery_instance.build_resource = mine_resource
	build_delivery_instance.build_position = to_global(build_position)
	game.add_child(build_delivery_instance)

func _on_BuildTimer_timeout():
	if build_time_current < build_time_required:
		build_time_current += 1
		build_progress.set_current(build_time_current)
	if build_time_current == build_time_required:
		build_progress.visible = false
		state = State.ACTIVE
		build_timer.stop()

func kill():
	buildings.remove_building(self)
