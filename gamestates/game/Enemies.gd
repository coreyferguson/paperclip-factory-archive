extends Node

signal add_enemy(enemy)
signal remove_enemy(enemy)
signal add_missile(missile)
signal remove_missile(missile)

var enemies = []
var missiles = []

func add_enemy(enemy):
	enemies.push_back(enemy)
	emit_signal('add_enemy', enemy)

func remove_enemy(enemy):
	enemies.remove(enemies.find(enemy))
	emit_signal('remove_enemy', enemy)
	enemy.queue_free()

func add_missile(missile):
	missiles.push_back(missile)
	emit_signal('add_missile', missile)

func remove_missile(missile):
	missiles.remove(missiles.find(missile))
	emit_signal('remove_missile', missile)
	missile.queue_free()