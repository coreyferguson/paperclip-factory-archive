extends Node2D

onready var followers = $Followers
onready var bulldozer = $Bulldozer

func _ready():
	for follower in followers.get_children():
		follower.follow(bulldozer)

