extends KinematicBody2D

export (int) var shield_capacity = 50
export (int) var speed = 75
export (int) var fly_capacity = 60
export (int) var launch_distance = 5000

var carrier_texture = load('res://assets/distractions/carrier.png')
var shield_texture = load('res://assets/distractions/carrier_shield.png')
var fly = load('res://gameplay/Fly.tscn')
var explosion_resource = load('res://gameplay/Explosion.tscn')
var explosion_texture = load('res://assets/distractions/carrier_explosion.png')

var target

onready var shield_current = shield_capacity
onready var fly_current = fly_capacity
onready var tween = $Tween
onready var shield = $Shield
onready var retarget_timer = $RetargetTimer
onready var launch_bays = $LaunchBays
onready var game = $'/root/Game'

func _ready():
	Enemies.add_enemy(self)
	shield.modulate = Color(1, 1, 1, 0)
	retarget_timer.start()

func _on_Area2D_body_entered(body):
	if shield_current > 0:
		shield_current -= 1
		var before = Color(1, 1, 1, 1.0)
		var after = Color(1, 1, 1, 0.0)
		tween.interpolate_property(shield, 'modulate', before, after, 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		body.kill()

func kill():
	if shield_current <= 0: explode()

func _physics_process(delta):
	if target and target.get_ref():
		var velocity = target.get_ref().position - position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
		rotation = velocity.angle()
		var collision = move_and_collide(velocity)
		if collision and collision.collider.is_in_group('player'):
			collision.collider.kill()

func _on_RetargetTimer_timeout():
	retarget()

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

func retarget():
	target = get_closest_player_node()

func _on_LaunchBayTimer_timeout():
	if target and target.get_ref():
		if target.get_ref().position.distance_to(position) <= launch_distance:
			shield_current = 0
			for bay in launch_bays.get_children():
				if fly_current > 0:
					fly_current -= 1
					var instance = fly.instance()
					instance.position = position + bay.position.rotated(position.angle())
					game.add_child(instance)

func explode():
	var explosion = explosion_resource.instance()
	explosion.texture = explosion_texture
	explosion.hframes = 6
	explosion.global_position = global_position
	game.add_child(explosion)
	Enemies.remove_enemy(self)
