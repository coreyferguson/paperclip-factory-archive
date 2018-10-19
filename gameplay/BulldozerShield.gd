extends KinematicBody2D

export (int) var capacity = 50

onready var current = capacity
onready var tween = $Tween
onready var timer = $WaitTimer
onready var collision_shape = $CollisionShape2D

var color_before = Color(1, 1, 1, 1.0)
var color_after = Color(1, 1, 1, 0.0)
var wait_time = 0.25

func _ready():
	modulate = Color(1, 1, 1, 0.0)

func kill():
	current -= 1
	tween.interpolate_property(self, 'modulate', color_before, color_after, wait_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	if current <= 0: 
		timer.wait_time = wait_time
		timer.start()
		collision_shape.queue_free()
	tween.start()

func _on_WaitTimer_timeout():
	queue_free()
