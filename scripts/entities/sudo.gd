extends Interactable

func _ready():
	get_node("Area2D").connect("body_entered", self, "_on_area_body_entered")
