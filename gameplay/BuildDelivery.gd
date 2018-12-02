extends Node2D

export (Dictionary) var build_item
export (PackedScene) var build_resource
export (Vector2) var build_position
export (float) var build_rotation
export (int) var speed = 500

var ghost

onready var game = $'/root/Game'

func _ready():
	Player.add_build_delivery(self)
	if build_item.has('placement_resource_ghost'):
		ghost = build_item.placement_resource_ghost.instance()
		ghost.global_position = build_position
		if build_rotation: ghost.rotation = build_rotation
		game.add_child(ghost)
		

func _physics_process(delta):
	if position.distance_to(build_position) > 1.0 * speed * delta * Globals.game_rate:
		var velocity = build_position - position
		velocity = velocity.normalized() * 1.0 * speed * delta * Globals.game_rate
		position += velocity
	else:
		position = build_position
		build()

func build():
	Player.remove_build_delivery(self)
	var build_instance = build_resource.instance()
	build_instance.position = position
	if build_rotation: build_instance.set_sprite_rotation(build_rotation)
	game.add_child(build_instance)
	if ghost: game.remove_child(ghost)
