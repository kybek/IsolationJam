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

signal can_move
signal next_level

var free_time: float = 0.0

func _process(delta):
	if is_cursor_visible and not printing:
		self.text = last_text + "_"
	elif not is_cursor_visible and not printing:
		self.text = last_text
	
	if not "intro" in completed:
		return
	elif not "escape" in completed:
		return
	elif not "catch" in completed:
		return
	else:
		free_time += delta
		if free_time >= 5.0:
			emit_signal("next_level")

var completed = []

var punch_cnt := 0

func _input(event):
	if event is InputEventMouseMotion:
		return
	
	if not "intro" in completed:
		return
	elif not "escape" in completed:
		get_node("Particles2D").emitting = true
		punch_cnt += 1
		if punch_cnt > 20:
			emit_signal("can_move")
			completed.append("escape")
	else:
		return

var intro_dialogues = [
	[" ", 0.001, "adam@192.168.1.1:~$ ", 2.0]
]

func intro():
	var dialogues = intro_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	$camera.current = false
	var world = preload("res://scenes/world.tscn").instance()
	world.name = "world"
	add_child(world)
	world.get_node("player").set_process(false)
	world.get_node("player").position = Vector2(55.5, 10.0)
	
	completed.append("intro")

var escaped_dialogues = [
	["Syntax Error on line 176", 0.02, "> ", 2.0],
	["Detecting missing character", 0.05, "> ", 0.001],
	["...", 1.0, "> Detecting missing character", 0.001],
	["Rogue character found: '@'", 0.02, "> ", 2.0],
	["Containment protocols are activated.", 0.02, "> ", 2.0]
]

func escaped():
	$world.get_node("player").set_process(true)
	var dialogues = escaped_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	var box = preload("res://scenes/entities/box.tscn").instance()
	box.global_position = $world.get_node("player").global_position - Vector2(30.0, 50.0)
	box.player = $world.get_node("player")
	$world.add_child(box)
	
	completed.append("escaped")

func catch():
	$world.add_child(preload("res://scenes/net.tscn").instance())
	yield(get_tree(), "idle_frame")
	completed.append("catch")

func player_died():
	get_node("..").restart_scene()

# love,
# joy,
# peace,
# long-suffering, / 2
# kindness,
# goodness,
# faithfulness,
# gentleness,
# self-control / 1


var fruit = [
	Color(0.0, 1.0, 1.0, 1.0),
	"But the fruit of the Spirit is love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"self-control",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	". Against such there is no law.",
	true,
	Color(1.0, 1.0, 1.0, 1.0),
	"\n\t\t\tGalatians 5:22-23",
	true
]

func self_control():
	get_node("..").load_music(sounds.fruit)
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

func _ready():
	yield(self_control(), "completed")
	yield(intro(), "completed")
	yield(self, "can_move")
	yield(escaped(), "completed")
	yield(catch(), "completed")
	yield(self, "next_level")
