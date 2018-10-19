extends Node

onready var game = $'/root/Game'

func _unhandled_input(event):
	handleKeyEvents(event)

func handleKeyEvents(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_F11:
			OS.window_fullscreen = !OS.window_fullscreen
		if event.scancode == KEY_PAUSE:
			get_tree().paused = !get_tree().paused
