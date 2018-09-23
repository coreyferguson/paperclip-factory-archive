extends Node2D

export (PackedScene) var build_resource
export (Vector2) var build_position
export (float) var build_rotation
export (int) var speed = 10

func _physics_process(delta):
	if position.distance_to(build_position) > speed:
		var velocity = build_position - position
		velocity = velocity.normalized() * speed
		position += velocity
	else:
		position = build_position
		build()

func build():
	queue_free()
	var build_instance = build_resource.instance()
	build_instance.position = position
	build_instance.rotation = build_rotation
	$'/root/Game'.add_child(build_instance)
