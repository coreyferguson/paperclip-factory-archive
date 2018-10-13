extends Node

signal notify_encounter(seconds)

export (bool) var enabled = true
export (int) var firstWaveTriggerTime = 10
export (int) var waveTriggerIncrements = 90

var elapsedTime = 0
var waveTrigger = firstWaveTriggerTime

onready var game = $'/root/Game'

func _ready():
	waveTrigger = firstWaveTriggerTime

func _on_Timer_timeout():
	elapsedTime += 1
	if elapsedTime == waveTrigger-30:
		emit_signal('notify_encounter', 30)
	if elapsedTime == waveTrigger-10:
		emit_signal('notify_encounter', 10)
	if elapsedTime >= waveTrigger: 
		waveTrigger += waveTriggerIncrements
		if enabled: spawnWave()

func spawnWave():
	Distractions.current_wave += 1
	var spawn_location = random_spawn_location()
	if Distractions.waves.size() > Distractions.current_wave:
		var wave = Distractions.waves[Distractions.current_wave]
		if wave.has('upgrades'):
			for upgrade in wave.upgrades:
				Distractions.types[upgrade].level += 1
		for wave_distraction in wave.distractions:
			for i in range(wave_distraction.quantity):
				var distraction = Distractions.types[wave_distraction.type]
				var resource = distraction.resources[distraction.level]
				var instance = resource.instance()
				spawn_location += Vector2(rand_range(-100, 100), rand_range(-100, 100))
				instance.position = spawn_location
				game.add_child(instance)

func random_spawn_location():
	randomize()
	var randomSide = randi() % 4
	var world_width = Globals.world_size
	var world_width_half = world_width / 2
	var offset = 200
	var x
	var y
	# top
	if randomSide == 0:
		x = randi() % world_width - world_width_half
		y = -world_width_half + offset*-1
	# right
	elif randomSide == 1:
		x = world_width_half + offset
		y = randi() % world_width - world_width_half
	# bottom
	elif randomSide == 2:
		x = randi() % world_width - world_width_half
		y = world_width_half + offset
	# left
	elif randomSide == 3:
		x = -world_width_half + offset*-1
		y = randi() % world_width - world_width/2
	return Vector2(x, y)
