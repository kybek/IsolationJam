extends RichTextLabel

var detect_position = false
var enemy = null

func _process(delta):
	if detect_position == false:
		return
	
	var t = get_node("../../sceneManager")
	if t.get_node("episode") == null:
		return
	t = t.get_node("episode")
	if t.get_node("world") == null:
		return
	t = t.get_node("world")
	if t.get_node("player") == null:
		return
	t = t.get_node("player")
	text = String(round(t.position.x)) + ":" + String(round(t.position.y)) + " / " + String(t.modulate.a * 255 - 155.0)
	if enemy == null:
		return

func _on_sceneManager_title_changed(title: String):
	text = title
	pass
