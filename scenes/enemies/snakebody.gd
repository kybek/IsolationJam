extends StaticBody2D

var pickup_mode = false

func _process(delta):
	if pickup_mode:
		for body in bodies:
			if body.name == "player":
				var dummy = Node.new()
				dummy.name = "snakebody"
				body.picked_up(dummy)

var bodies = []

func _on_area_body_entered(body):
	bodies.append(body)

func _on_area_body_exited(body):
	assert(body in bodies)
	bodies.erase(body)
