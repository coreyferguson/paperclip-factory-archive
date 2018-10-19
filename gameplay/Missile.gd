extends KinematicBody2D

export (int) var speed = 250

var explosion_resource = load('res://gameplay/Explosion.tscn')
var explosion_texture = load('res://assets/distractions/missile_explosion.png')

var target

onready var game = $'/root/Game'

func _ready():
	retarget()
	Enemies.add_missile(self)

func _physics_process(delta):
	if target and target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.has_method('kill'):
			collision.collider.kill()
			explode()

func get_closest_player_node():
	var playerNodes = get_tree().get_nodes_in_group('player')
	var closestNode
	var leastDistance
	for node in playerNodes:
		if !node.is_queued_for_deletion():
			if leastDistance == null:
				closestNode = node
				leastDistance = node.position.distance_to(position)
			else:
				var distance = node.position.distance_to(position)
				if distance < leastDistance:
					closestNode = node
					leastDistance = distance
	if !closestNode: return null
	else: return weakref(closestNode)

func kill():
	explode()

func retarget():
	target = get_closest_player_node()

func _on_Timer_timeout():
	retarget()

func explode():
	var explosion = explosion_resource.instance()
	explosion.texture = explosion_texture
	explosion.hframes = 3
	explosion.global_position = global_position
	game.add_child(explosion)
	Enemies.remove_enemy(self)
