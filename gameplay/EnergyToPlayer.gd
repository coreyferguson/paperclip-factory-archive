extends Area2D

signal player_overlap

var player

func _ready():
	player = $'/root/Game/Player'

func _on_Timer_timeout():
	var overlapping = get_overlapping_bodies()
	if overlapping.size() > 0:
		for node in overlapping:
			if node == player:
				emit_signal('player_overlap')
