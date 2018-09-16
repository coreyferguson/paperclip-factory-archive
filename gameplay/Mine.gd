extends StaticBody2D

signal kill

func kill():
	queue_free()
	emit_signal('kill')
