extends RichTextLabel

var last_text: String = ""

var printing := false

func printf(text: String, keystroke = 0.001, prefix = "adam@192.168.1.1:~$ ") -> void:
	assert(not printing)
	printing = true
	self.visible_characters = len(prefix)
	self.text = prefix + text
	last_text = prefix + text
	
	for ch in text:
		yield(get_tree().create_timer(keystroke), "timeout")
		self.visible_characters = self.visible_characters + 1
	
	self.visible_characters = -1
	
	printing = false

var is_cursor_visible = false

func _on_Timer_timeout():
	is_cursor_visible = !is_cursor_visible

signal next_level

func _process(delta):
	if is_cursor_visible and not printing:
		self.text = last_text + "_"
	elif not is_cursor_visible and not printing:
		self.text = last_text
	
	if not "intro" in completed:
		return
	else:
		return

var completed = []

func _input(event):
	if event is InputEventMouseMotion:
		return
	
	if not "intro" in completed:
		return
	else:
		return

var intro_dialogues = [
	[" ", 0.001, "adam@~/.local/share/Trash$ cat image0.png", 0.001]
]

func mutate(chr: String) -> String:
	var r = randf() * 11.0
	
	if r < 10.0:
		return str(floor(r))
	
	return ' '

func intro():
	var dialogues = intro_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	$camera.current = false
	var world = preload("res://scenes/world.tscn").instance()
	world.name = "world"
	world.get_node("charWindow").filepath = "res://maps/episode5.gd"
	
	add_child(world)
	
	for i in range(0, world.get_node("charWindow").ROWS):
		for j in range(0, world.get_node("charWindow").COLS):
			if world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text == ".":
				world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text = mutate(world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text)
	
	world.get_node("player").position = Vector2(512.0, 300.0)
	
	get_node("world/player").permit("E")
	get_node("world/player").permit("Q")
	
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.player = world.get_node("player")
	vector.global_position = world.get_node("charWindow").rect_global_position + Vector2(224.0, 0.0) - Vector2(37 * 12.0, 0.0)
	world.add_child(vector)
	
	var gvector = preload("res://scenes/enemies/glitchedVector.tscn").instance()
	gvector.player = world.get_node("player")
	gvector.global_position = world.get_node("charWindow").rect_global_position + Vector2(224.0, 0.0)
	world.add_child(gvector)
	
	var eof = preload("res://scenes/entities/eof.tscn").instance()
	eof.name = "eof"
#	32, 12
	eof.rect_global_position = Vector2(512.0 + 23 * 12.0, 580.0)
	world.add_child(eof)
	
	completed.append("intro")
	
	yield(gvector, "interacted")
	remove_child(world)
	yield(kindness(), "completed")
#	$world.remove_child(gvector)
#	$world.call_deferred("remove_child", gvector)

var fruit = [
	Color(0.0, 1.0, 1.0, 1.0),
	"But the fruit of the Spirit is love, joy, peace, patience, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"kindness",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	", goodness, faithfulness, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"gentleness",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	", self-control. Against such there is no law.",
	true,
	Color(1.0, 1.0, 1.0, 1.0),
	"\n\t\t\tGalatians 5:22-23",
	true
]

func kindness():
	hide()
	get_node("..").load_music(preload("res://sounds/fruit_of_the_spirit.ogg"))
	get_node("../../CanvasLayer2/dialogue").detect_position = false
	get_node("../../CanvasLayer2/dialogue").text = ""
	for i in range(len(fruit)):
		if fruit[i] is Color:
			get_node("../../CanvasLayer2/dialogue").push_color(fruit[i])
		elif fruit[i] is String:
			for j in range(len(fruit[i])):
				get_node("../../CanvasLayer2/dialogue").add_text(fruit[i][j])
				yield(get_tree().create_timer(0.1), "timeout")
	
	yield(get_tree().create_timer(4.0), "timeout")
	
	for j in range(10):
		get_node("../../CanvasLayer2/dialogue").text = ""
		for i in range(len(fruit)):
			if fruit[i] is Color:
				if fruit[i + 2] == true:
					fruit[i].a -= 0.1
				get_node("../../CanvasLayer2/dialogue").push_color(fruit[i])
			elif fruit[i] is String:
				get_node("../../CanvasLayer2/dialogue").add_text(fruit[i])
		yield(get_tree().create_timer(0.25), "timeout")
	
	for j in range(10):
		get_node("../../CanvasLayer2/dialogue").text = ""
		for i in range(len(fruit)):
			if fruit[i] is Color:
				if fruit[i + 2] == false:
					fruit[i].a -= 0.1
				get_node("../../CanvasLayer2/dialogue").push_color(fruit[i])
			elif fruit[i] is String:
				get_node("../../CanvasLayer2/dialogue").add_text(fruit[i])
		yield(get_tree().create_timer(0.25), "timeout")
	
#	yield(get_tree().create_timer(10.0), "timeout")
	get_node("../../CanvasLayer2/dialogue").text = ""
	get_node("../../CanvasLayer2/dialogue").detect_position = true
	get_node("..").stop_music()
	show()

func player_died():
	get_node("..").restart_scene()

func _ready():
	yield(intro(), "completed")
	emit_signal("next_level")
