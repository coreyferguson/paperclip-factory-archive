extends Node

signal notify_encounter(seconds)

export (bool) var enabled = true

onready var game = $'/root/Game'
onready var player = $'/root/Game/Player'
onready var timer = $Timer

func _ready():
	reset_timer_wait_time()
	timer.start()
	Globals.connect('game_rate_change', self, 'reset_timer_wait_time')

func _on_Timer_timeout():
	Globals.increment_elapsed_time()
	if Globals.elapsed_time == Distractions.wave_trigger-30:
		emit_signal('notify_encounter', 30)
	if Globals.elapsed_time == Distractions.wave_trigger-10:
		emit_signal('notify_encounter', 10)
	if Globals.elapsed_time >= Distractions.wave_trigger: 
		Distractions.increment_wave_trigger()
		if enabled: spawnWave()

func spawnWave():
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
				instance.global_position = spawn_location
				game.add_child(instance)
	else:
		Globals.game_over('Humans have gone extinct. You continue producing paperclips for eternity.')

func random_spawn_location():
	randomize()
	var position = Vector2(randf()*2-1, randf()*2-1)
	position = position.normalized() * Globals.radar_radius
	return player.global_position + position

func reset_timer_wait_time():
	timer.wait_time = 1.0 / Globals.game_rate