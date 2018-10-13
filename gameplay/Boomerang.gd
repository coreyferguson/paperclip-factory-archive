extends KinematicBody2D

export (int) var speed = 250
export (float) var angle_of_approach = 45
export (int) var rotation_speed = 10

var target = null
var distance_to_start_dodge_mode = 2000

onready var radians_of_approach = deg2rad(angle_of_approach)
onready var sprite = $Sprite

func _ready():
	Enemies.add_enemy(self)

func _physics_process(delta):
	if target and target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
		if position.distance_to(target.get_ref().position) <= distance_to_start_dodge_mode:
			velocity = velocity.rotated(radians_of_approach)
		var collision = move_and_collide(velocity)
		if collision and collision.collider.is_in_group('player'):
			collision.collider.kill()
			Enemies.remove_enemy(self)
	rotation -= rotation_speed * delta

func _on_RetargetTimer_timeout():
	target = get_closest_player_node()

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
	Enemies.remove_enemy(self)