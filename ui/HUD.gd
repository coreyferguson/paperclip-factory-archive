extends CanvasLayer

onready var notification = $Notification

func _on_WaveController_notify_encounter(seconds):
	notification.notify_encounter(seconds)
