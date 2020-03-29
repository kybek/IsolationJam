extends Label

class_name Interactable

func _on_area_body_entered(body):
	if body.name == "player":
		body.picked_up(self)
