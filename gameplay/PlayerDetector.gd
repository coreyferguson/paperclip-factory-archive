extends Area2D

signal player_overlap

export (int) var detection_wait_time = 1

onready var player = $'/root/Game/Player'
onready var timer = $Timer

func _ready():
	reset_timer_wait_time()
	timer.start()
	Globals.connect('game_rate_change', self, 'reset_timer_wait_time')

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node == player:
				emit_signal('player_overlap')

func reset_timer_wait_time():
	timer.wait_time = 1.0 * detection_wait_time / Globals.game_rate
