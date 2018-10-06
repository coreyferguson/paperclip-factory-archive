extends KinematicBody2D

var recycle_quantity_rate = 10

onready var progress_bar = $ProgressBar
onready var progress_bar_timer = $ProgressBarTimer
onready var recycle_timer = $RecycleTimer
onready var recycle_area = $RecycleArea

func _ready():
	buildings.add_building(self)

func _on_ProgressBarTimer_timeout():
	progress_bar.set_current(progress_bar.current + 1)

func _on_RecycleTimer_timeout():
	progress_bar.set_current(0)
	var target
	for node in recycle_area.get_overlapping_bodies():
		if node.is_in_group('player') and node.has_method('recycle'):
			target = node
			break
#
	if target:
		var recycled_resources = target.recycle()
		for resource in recycled_resources:
			Inventory.add({
				'type': resource.type,
				'quantity': resource.quantity,
				'texture': NaturalResource.types[resource.type].world_texture
			})
	else:
		buildings.remove_building(self)

func kill():
	buildings.remove_building(self)
