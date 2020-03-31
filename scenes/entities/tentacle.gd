extends Label

var player = null

func _process(delta):
	if player != null:
		player.hit("tentacle", delta)

func _on_area_body_entered(body):
	if body.name == "player":
		player = body

func _on_area_body_exited(body):
	if body.name == "player":
		player = null
