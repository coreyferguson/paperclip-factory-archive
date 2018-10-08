extends KinematicBody2D

export (int) var speed = 500
export (float) var velocity
var target = null

onready var camera = $'/root/Game/Camera'

func _ready():
	velocity = velocity.normalized()

func _physics_process(delta):
	var v
	if !target or !target.get_ref():
		v = velocity * speed * delta
	else:
		v = target.get_ref().position - position
		v = v.normalized() * speed * delta
	var c = move_and_collide(v)
	if c and c.collider.has_method('kill'):
		c.collider.kill()
		queue_free()
	if position.x < camera.limit_left or position.x > camera.limit_right or position.y < camera.limit_top or position.y > camera.limit_bottom: 
		queue_free()

func _on_Detector_detection(node):
	target = weakref(node)
