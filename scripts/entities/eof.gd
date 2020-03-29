extends Interactable

func _ready():
	get_node("area").connect("body_entered", self, "_on_area_body_entered")
