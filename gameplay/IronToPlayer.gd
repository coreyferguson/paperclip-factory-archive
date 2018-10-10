extends Area2D

signal player_overlap

export (int) var harvest_wait_time = 1

var player

func _ready():
	player = $'/root/Game/Player'
	$Timer.wait_time = harvest_wait_time / Globals.game_rate

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node == player:
				emit_signal('player_overlap')
