extends StaticBody2D

var pickup_mode = false

var t = 0

func _process(delta):
	if pickup_mode:
		t += delta
		modulate.a = rad2deg(sin(t)) / 360.0
		if modulate.a < 0.0:
			modulate.a += 1.0
#		print(modulate.a)
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
