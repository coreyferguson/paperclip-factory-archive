tool
extends Node2D

export (float) var wait_time = 0.075
export (int) var vframes = 1
export (int) var hframes = 1
export (Texture) var texture

var total_frames
var modulate_off = Color(1, 1, 1, 0.0)
var modulate_on = Color(1, 1, 1, 1.0)

onready var sprite = $Sprite
onready var timer = $Timer
onready var tween = $Tween

func _ready():
	reset_sprite()
	reset_timer()
	tween.interpolate_property(sprite, 'modulate', modulate_off, modulate_on, wait_time*total_frames, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _process(delta):
	if Engine.editor_hint: 
		reset_sprite()
		reset_timer()

func reset_sprite():
	sprite.vframes = vframes
	sprite.hframes = hframes
	total_frames = vframes * hframes
	if texture: sprite.texture = texture

func reset_timer():
	timer.wait_time = wait_time
	timer.start()

func _on_Timer_timeout():
	if sprite.frame == total_frames-1: queue_free()
	else: sprite.frame += 1
