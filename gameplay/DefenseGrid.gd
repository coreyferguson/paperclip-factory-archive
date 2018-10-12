extends StaticBody2D

var NaturalResourceStack = load('res://gamestates/game/NaturalResourceStack.gd')

export (int) var antimissile_mine_capacity = 10
export (int) var mine_placement_min_distance = 100
export (int) var mine_placement_max_distance = 400
export (int) var build_timer_wait_time = 1

var antiship_mine_resource = load('res://gameplay/Mine.tscn')
var antimissile_mine_resource = load('res://gameplay/LowYieldMine.tscn')
var build_delivery_resource = load('res://gameplay/BuildDelivery.tscn')

onready var game = $'/root/Game'
onready var ship_detector = $ShipDetector
onready var missile_detector = $MissileDetector
onready var antimissile_mine_current = antimissile_mine_capacity

enum State { BUILDING, ACTIVE }
onready var state = State.BUILDING
var build_time_required = 5
onready var build_time_current = 0
onready var build_progress = $BuildProgress
onready var build_timer = $BuildTimer

func _ready():
	Player.add_building(self)
	build_timer.wait_time = build_timer_wait_time / Globals.game_rate

func _on_DetectorTimer_timeout():
	if state == State.ACTIVE and antimissile_mine_current > 0:
		var missiles = missile_detector.get_overlapping_bodies()
		for missile in missiles: deploy_antimissile_mine(missile)

func deploy_antimissile_mine(missile):
	if antimissile_mine_current == 0: return
	antimissile_mine_current -= 1
	var distance = position.distance_to(missile.position) - 200
	distance = clamp(distance, mine_placement_min_distance, mine_placement_max_distance)
	var build_position = missile.position - position
	build_position = build_position.normalized() * distance
	var build_delivery_instance = build_delivery_resource.instance()
	build_delivery_instance.position = position
	build_delivery_instance.build_resource = antimissile_mine_resource
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
	Player.remove_building(self)

func recycle():
	var antimissile_requirements = Build.Items['AntiMissileMine'].required_resources
	if typeof(antimissile_requirements) == TYPE_OBJECT: 
		antimissile_requirements = antimissile_requirements.call_func(Science)
	var recycled_materials = []
	for i in range(antimissile_mine_current):
		for resource in antimissile_requirements:
			var copy = NaturalResourceStack.new().copy_from(resource)
			copy.quantity = ceil(copy.quantity * 0.8)
			recycled_materials.push_back(resource)
	kill()
	return recycled_materials