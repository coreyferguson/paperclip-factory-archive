extends KinematicBody2D

var recycle_quantity_rate = 10

onready var progress_bar = $ProgressBar
onready var progress_bar_timer = $ProgressBarTimer
onready var recycle_timer = $RecycleTimer
onready var recycle_area = $RecycleArea
onready var player = $'/root/Game/Player'

func _ready():
	buildings.add_building(self)

func _on_ProgressBarTimer_timeout():
	progress_bar.set_current(progress_bar.current + 1)

func _on_RecycleTimer_timeout():
	progress_bar.set_current(0)
	var target
	for node in recycle_area.get_overlapping_bodies():
		if node != player and node.is_in_group('player'):
			target = node
			break
#
#	var target = get_closest_player_node()
	if target:
		Inventory.add({
			'type': 'iron',
			'quantity': recycle_quantity_rate,
			'texture': NaturalResource.types['iron'].world_texture
		})
		target.kill()
	else:
		buildings.remove_building(self)

func kill():
	buildings.remove_building(self)

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

