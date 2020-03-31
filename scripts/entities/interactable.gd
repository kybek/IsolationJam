extends Label

class_name Interactable

signal interacted

func _on_area_body_entered(body):
	if body.name == "player":
		var temp = Node.new()
		temp.name = name
		emit_signal("interacted")
#		body.picked_up(temp)
