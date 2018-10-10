extends Node2D

export (PackedScene) var build_resource
export (Vector2) var build_position
export (float) var build_rotation
export (int) var speed = 500

func _physics_process(delta):
	if position.distance_to(build_position) > speed * delta * Globals.game_rate:
		var velocity = build_position - position
		velocity = velocity.normalized() * speed * delta * Globals.game_rate
		position += velocity
	else:
		position = build_position
		build()

func build():
	queue_free()
	var build_instance = build_resource.instance()
	build_instance.position = position
	if build_rotation: build_instance.set_sprite_rotation(build_rotation)
	$'/root/Game'.add_child(build_instance)
