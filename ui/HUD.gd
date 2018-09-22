extends CanvasLayer

signal build

func select(nodes):
#	$Selected.visible = true
	pass

func deselect():
#	$Selected.visible = false
	pass

func collect(item):
	$Inventory.collect(item)

func _on_WaveController_score_change(score):
	$HUDScore.set_score(score)

func _on_WaveController_score_trigger_change(scoreTrigger):
	pass
