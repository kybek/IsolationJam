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

signal e_used

func _input(event):
	if event is InputEventMouseMotion:
		return
	
	if not "intro" in completed:
		return
	elif not "sudo" in completed:
		return
	elif not "e_used" in completed:
		if event is InputEventKey and event.scancode == KEY_E:
			emit_signal("e_used")
	elif not "scanlines" in completed:
		if event is InputEventKey and event.scancode == KEY_E:
			emit_signal("e_used")
	else:
		return

var intro_dialogues = [
	[" ", 0.001, "adam@~/.local/share/Trash$", 0.001]
]

func intro():
	var dialogues = intro_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	$camera.current = false
	var world = preload("res://scenes/world.tscn").instance()
	world.name = "world"
	world.get_node("charWindow").filepath = "res://maps/prison.gd"
	add_child(world)
	
	world.get_node("player").position = Vector2(55.5, 10.0)
	var box = preload("res://scenes/entities/box.tscn").instance()
	box.global_position = world.get_node("player").global_position - Vector2(30.0, 50.0)
	box.player = world.get_node("player")
	world.add_child(box)
	
	var sudo = preload("res://scenes/entities/sudo.tscn").instance()
	sudo.rect_position = Vector2(800.0, 300.0)
	sudo.rect_size = Vector2(48.0, 20.0)
	world.add_child_below_node(world.get_node("charWindow"), sudo)
	
	completed.append("intro")
	
	yield(sudo, "interacted")

var sudo_dialogues = [
	[" sudo permit '@' keys.E", 0.001, "adam@~/.local/share/Trash$", 0.001]
]

func sudo_scene():
	yield(get_tree(), "idle_frame")
#	var world = get_node("world")
#	var box = world.get_node("box")
	get_node("world/box").player = null
	for i in range(0, 50):
		var p = Vector2(100 + randi() % 800, 100 + randi() % 400)
		get_node("world/player").position = p
#		box.global_position = world.get_node("player").global_position - Vector2(30.0, 50.0)
		yield(get_tree().create_timer(2.0 / (i + 1)), "timeout")
	get_node("world/player").position = get_node("world/charWindow").rect_position + get_node("world/charWindow").rect_size / 2 - Vector2(0.0, 50.0)
#	box.global_position = world.get_node("player").global_position - Vector2(30.0, 50.0)
	
	var dialogues = sudo_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	completed.append("sudo")

signal sudo

func sudo():
	emit_signal("sudo")

var scanlines_dialogues = []

func scanlines():
	yield(get_tree(), "idle_frame")
	
	var dialogues = scanlines_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	$world.add_child(preload("res://scenes/net.tscn").instance())
	
	yield(self, "e_used")
	yield(get_tree().create_timer(4.0), "timeout")
	
	completed.append("scanlines")

func spam():
	var world = get_node("world")
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.player = world.get_node("player")
	vector.global_position = world.get_node("charWindow").rect_global_position - Vector2(0.0, 310.0)
#	vector.position = Vector2(60.0, 60.0)
	world.add_child(vector)
	yield(get_tree().create_timer(1.15), "timeout")

func spam2():
	var world = get_node("world")
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.player = world.get_node("player")
	vector.global_position = world.get_node("charWindow").rect_global_position + Vector2(0.0, 310.0)
#	vector.position = Vector2(60.0, 60.0)
	world.add_child(vector)
	yield(get_tree().create_timer(1.15), "timeout")

var fruit = [
	Color(0.0, 1.0, 1.0, 1.0),
	"But the fruit of the Spirit is love, joy, peace, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"patience",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	", kindness, goodness, faithfulness, gentleness, self-control. Against such there is no law.",
	true,
	Color(1.0, 1.0, 1.0, 1.0),
	"\n\t\t\tGalatians 5:22-23",
	true
]

func patience():
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
	emit_signal("next_level")

func _ready():
	yield(intro(), "completed")
	yield(sudo_scene(), "completed")
	yield(patience(), "completed")
	get_node("world/player").permit("E")
	yield(self, "e_used")
	completed.append("e_used")
	yield(scanlines(), "completed")
	while(true):
		yield(spam(), "completed")
		yield(spam2(), "completed")
