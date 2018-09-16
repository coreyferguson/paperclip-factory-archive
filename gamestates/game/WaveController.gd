extends Node

export (bool) var enabled = true
export (int) var firstWaveTriggerTime = 10
export (int) var waveTriggerIncrements = 90

var elapsedTime = 0
var waveTrigger = firstWaveTriggerTime

func _ready():
	waveTrigger = firstWaveTriggerTime

func _on_Timer_timeout():
	elapsedTime += 1
	if elapsedTime >= waveTrigger: 
		waveTrigger += waveTriggerIncrements
		if enabled: spawnWave()

func spawnWave():
	var enemiesToSpawn = pow(2, (elapsedTime-firstWaveTriggerTime)/waveTriggerIncrements)
	enemiesToSpawn = clamp(enemiesToSpawn, 1, 500)
	var randomSide = randi() % 4
	var world_width = 10000
	var world_width_half = world_width / 2
	var offset = 200
	var x
	var y
	randomize()
	if randomSide == 0:
		x = randi() % world_width - world_width_half
		y = -world_width_half + offset*-1
	elif randomSide == 1:
		x = world_width_half + offset
		y = randi() % world_width - world_width_half
	elif randomSide == 2:
		x = randi() % world_width - world_width_half
		y = world_width_half + offset
	elif randomSide == 3:
		x = -world_width_half + offset*-1
		y = randi() % world_width - world_width/2
	var scoutResource = load('res://gameplay/Scout.tscn')
	for i in range(enemiesToSpawn):
		x += rand_range(-100, 100)
		y += rand_range(-100, 100)
		var pos = Vector2(x, y)
		var scout = scoutResource.instance()
		scout.position = pos
		$'/root/Game'.add_child(scout)

