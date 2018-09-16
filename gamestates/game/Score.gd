extends Node

signal change

var paperclips = 0

func reset():
	paperclips = 0

func get_paperclips():
	return paperclips
	
func set_paperclips(value):
	paperclips = value
	emit_signal('change')
	
func increment(value):
	paperclips += value
	emit_signal('change')

func decrement(value):
	paperclips -= value
	emit_signal('change')
