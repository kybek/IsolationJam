extends RichTextLabel

var last_text: String = ""

var printing := false

func printf(text: String, keystroke = 0.001, prefix = "adam@192.168.1.1:~$ ") -> void:
	assert(not printing)
	printing = true
	self.visible_characters = len(prefix)
	self.text = prefix + '\n' + text
	last_text = prefix + '\n' + text
	
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
	world.get_node("charWindow").filepath = "res://maps/snakearena.gd"
	add_child(world)
	
	world.get_node("player").global_position = Vector2(55.5, 10.0)

	get_node("world/player").permit("E")
	
	var trojanexe = preload("res://scenes/entities/trojanexe.tscn").instance()
	trojanexe.rect_global_position = Vector2($world/player.global_position.x, 300.0)
	world.add_child_below_node(world.get_node("charWindow"), trojanexe)
	
	var eof = preload("res://scenes/entities/eof.tscn").instance()
	eof.name = "eof"
#	32, 12
	eof.rect_global_position = world.get_node("charWindow").rect_global_position + Vector2(450, 0.0)
	world.add_child(eof)
	
	completed.append("intro")

var init_fight_dialogues = [
	[" ./trojan.exe", 0.001, "adam@~/.local/share/Trash$", 0.001]
]

signal trojanexe

var snakebody_dialogues = [
	[" sudo permit '@' keys.Q", 0.001, "adam@~/.local/share/Trash$", 0.001]
]

func init_fight():
	yield(self, "trojanexe")
	
	var dialogues = init_fight_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	$world/player.global_position = Vector2(512.0, 300.0)
	
	yield(get_tree().create_timer(2.0), "timeout")
	
	var snake = preload("res://scenes/enemies/snake.tscn").instance()
	$world.add_child(snake)
	snake.global_position = $world/charWindow.rect_global_position - Vector2(6.0, 10.0) + Vector2(100.0, 40.0)
	snake.player = $world/player
	yield(self, "snakebody")
	snake.player = null
	
	yield(peace(), "completed")
	
	get_node("world/player").permit("Q")
	
	dialogues = snakebody_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
	completed.append("snakebody")

signal snakebody

var fruit = [
	Color(0.0, 1.0, 1.0, 1.0),
	"But the fruit of the Spirit is love, joy, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"peace",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	", patience, kindness, goodness, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"faithfulness",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	", gentleness, self-control. Against such there is no law.",
	true,
	Color(1.0, 1.0, 1.0, 1.0),
	"\n\t\t\tGalatians 5:22-23",
	true
]

func peace():
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
	yield(init_fight(), "completed")
	
