extends Control

onready var tween = $Tween
onready var timer = $Timer

func notify_encounter(seconds):
	$Label.text = 'Distraction from Paperclip construction in ' + str(seconds) + ' seconds'
	notify_timer_fade_in()

func notify_timer_fade_in():
	var on = Color(1.0, 1.0, 1.0, 1.0)
	var off = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", off, on, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	timer.start()

func notify_timer_fade_out():
	var on = Color(1.0, 1.0, 1.0, 1.0)
	var off = Color(1.0, 1.0, 1.0, 0.0)
	tween.interpolate_property(self, "modulate", on, off, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()