extends KinematicBody2D

var player = null

const SPEED = 100.0

func _physics_process(delta):
	if player == null:
		return
	
	if $center.global_position != player.global_position:
		var vec = player.global_position - $center.global_position
		move_and_slide(vec * SPEED)
