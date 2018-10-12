extends Node

signal notify_encounter(seconds)

export (bool) var enabled = true
export (int) var firstWaveTriggerTime = 10
export (int) var waveTriggerIncrements = 90

var elapsedTime = 0
var waveTrigger = firstWaveTriggerTime

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
	randomize()
	var wave = (elapsedTime-firstWaveTriggerTime)/waveTriggerIncrements
	var enemiesToSpawn = 2 * wave
	enemiesToSpawn = clamp(enemiesToSpawn, 1, 500)
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
	var scoutResource = load('res://gameplay/Scout.tscn')
	var flyResource = load('res://gameplay/Fly.tscn')
	var boomerangResource = load('res://gameplay/Boomerang.tscn')
	for i in range(enemiesToSpawn):
		var enemyResource
		var rand = randi() % 3
		if rand == 0: enemyResource = scoutResource
		elif rand == 1: enemyResource = flyResource
		elif rand == 2: enemyResource = boomerangResource
		x += rand_range(-100, 100)
		y += rand_range(-100, 100)
		var pos = Vector2(x, y)
		var enemy = enemyResource.instance()
		enemy.position = pos
		$'/root/Game'.add_child(enemy)
