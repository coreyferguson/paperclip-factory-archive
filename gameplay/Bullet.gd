extends KinematicBody2D

export (int) var speed = 500
export (float) var velocity
var target = null

onready var camera = $'/root/Game/Camera'
onready var spawn_global_position = global_position

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
	var distance_from_spawn = spawn_global_position.distance_to(global_position)
	if distance_from_spawn > Globals.radar_radius:
		Player.remove_bullet(self)

func _on_Detector_detection(node):
	target = weakref(node)

func kill():
	Player.remove_bullet(self)
