extends Node2D

func _process(delta):
	if $player:
		$player.position.x = clamp($player.position.x, 0.0, 1024.0)
		$player.position.y = clamp($player.position.y, 0.0, 600.0)

func sudo():
	get_node("..").sudo()

func _ready():
	var player = preload("res://scenes/player.tscn").instance()
	add_child(player)
