extends KinematicBody2D

export (int) var speed = 500
export (float) var velocity
var target = null

onready var camera = $'/root/Game/Camera'

func _ready():
	velocity = velocity.normalized()
	Player.add_bullet(self)

func _physics_process(delta):
	var v
	if !target or !target.get_ref():
		v = velocity * speed * delta * Globals.game_rate
	else:
		v = target.get_ref().position - position
		v = v.normalized() * speed * delta
	var c = move_and_collide(v)
	if c and c.collider.has_method('kill'):
		c.collider.kill()
		Player.remove_bullet(self)
	if position.x < camera.limit_left or position.x > camera.limit_right or position.y < camera.limit_top or position.y > camera.limit_bottom: 
		Player.remove_bullet(self)

func _on_Detector_detection(node):
	target = weakref(node)

func kill():
	Player.remove_bullet(self)
