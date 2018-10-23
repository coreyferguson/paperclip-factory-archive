tool
extends KinematicBody2D

export (int) var capacity = 100
onready var quantity = 0
export (int) var speed = 100

enum State { LOAD, DELIVER, FADING }
onready var state = State.LOAD
export (int) var state_change_wait_time = 1
onready var state_change_timer = $StateChangeTimer

onready var sprite = $Sprite
onready var progress_bar = $ProgressBar
onready var harvest_timer = $HarvestTimer
export (int) var harvest_timer_wait_time = 1

export (int) var building_detection_radius = 900
onready var building_detector = $BuildingDetector
onready var building_detector_shape = $BuildingDetector/CollisionShape2D
var buildings
var target

export (int) var harvest_detection_radius = 150
onready var harvest_detector = $HarvestDetector
onready var harvest_detector_shape = $HarvestDetector/CollisionShape2D
onready var resources = []

var player
export (int) var player_detection_radius = 150
onready var player_detector = $PlayerDetector
onready var player_detector_shape = $PlayerDetector/CollisionShape2D

onready var tween = $Tween
onready var fade_timer = $FadeTimer
onready var before = Color(1, 1, 1, 1.0)
onready var after = Color(1, 1, 1, 0.0)

var Globals
var Inventory

func _ready():
	Globals = tool_safe_load('/root/Globals', 'res://gamestates/game/Globals.gd')
	Globals.connect('game_rate_change', self, '_on_Globals_game_rate_change')
	Inventory = tool_safe_load('/root/Inventory', 'res://gamestates/game/Inventory.gd')
	player = tool_safe_load('/root/Game/Player')
	initialize_progress_bar()
	initialize_detectors()
	reset_timers()
	if !Engine.editor_hint:
		harvest_timer.start()
		state_change_timer.start()

func _process(delta):
	if Engine.editor_hint: 
		initialize_progress_bar()
		initialize_detectors()

func _physics_process(delta):
	if state == State.LOAD and target and target.get_ref():
		var velocity = target.get_ref().global_position - global_position
		velocity = velocity.normalized() * delta * speed * Globals.game_rate
		if global_position.distance_to(target.get_ref().global_position) > velocity.length():
			sprite.rotation = velocity.angle()
			move_and_collide(velocity)
	elif state == State.DELIVER:
		var velocity = player.global_position - global_position
		velocity = velocity.normalized() * delta * speed * Globals.game_rate
		if global_position.distance_to(player.global_position) > velocity.length():
			sprite.rotation = velocity.angle()
			move_and_collide(velocity)

func _on_Globals_game_rate_change():
	reset_timers()

func initialize_buildings():
	buildings = []
	var bodies = building_detector.get_overlapping_bodies()
	for body in bodies:
		if body.has_method('can_harvest') and body.can_harvest():
			buildings.push_back(weakref(body))

func find_closest_harvestable_building():
	if !buildings: initialize_buildings()
	if buildings.size() == 0: return null
	var closest_building = null
	var closest_distance = null
	for i in range(buildings.size()):
		if !buildings[i].get_ref() or !buildings[i].get_ref().can_harvest():
			continue
		var distance = global_position.distance_to(buildings[i].get_ref().global_position)
		if closest_distance == null or distance < closest_distance:
			closest_building = buildings[i]
			closest_distance = distance
	return closest_building

func _on_StateChangeTimer_timeout():
	if state != State.LOAD: return
	target = find_closest_harvestable_building()
	if !target or quantity >= capacity:
		state = State.DELIVER
		target = null

func _on_HarvestTimer_timeout():
	if state == State.LOAD and quantity < capacity:
		var bodies = harvest_detector.get_overlapping_bodies()
		for body in bodies:
			if body.has_method('can_harvest') and body.has_method('harvest') and body.can_harvest():
				var harvested = body.harvest(capacity-quantity)
				quantity += harvested.quantity
				progress_bar.set_current(quantity)
				resources.push_back(harvested)
	elif state == State.DELIVER:
		var bodies = player_detector.get_overlapping_bodies()
		for body in bodies:
			if body == player:
				for resource in resources:
					Inventory.add(resource)
				fade_out()

func initialize_progress_bar():
	if progress_bar:
		progress_bar.capacity = capacity
		progress_bar.set_current(quantity)

func initialize_detectors():
	if building_detector_shape:
		building_detector_shape.shape.radius = building_detection_radius
	if harvest_detector_shape:
		harvest_detector_shape.shape.radius = harvest_detection_radius
	if player_detector_shape:
		player_detector_shape.shape.radius = player_detection_radius

func reset_timers():
	if state_change_timer:
		state_change_timer.wait_time = 1.0 * state_change_wait_time / Globals.game_rate
	if harvest_timer:
		harvest_timer.wait_time = 1.0 * harvest_timer_wait_time / Globals.game_rate

func tool_safe_load(node_path, resource_path=null):
	if has_node(node_path): return get_node(node_path)
	elif resource_path: return load(resource_path).new()
	else: return null

func fade_out():
	state = State.FADING
	tween.interpolate_property(self, 'modulate', before, after, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	fade_timer.start()

func _on_FadeTimer_timeout():
	queue_free()
