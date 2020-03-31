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
	
#	if event is InputEventKey and event.scancode == KEY_SPACE:
#		print(get_node("world/player").global_position)
	
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
	world.get_node("charWindow").filepath = "res://maps/walls.gd"
	
	add_child(world)
	
	for i in range(0, world.get_node("charWindow").ROWS):
		for j in range(0, world.get_node("charWindow").COLS):
			if world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text == ".":
				world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text = mutate(world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text)
	
	world.get_node("player").position = world.get_node("charWindow").rect_global_position
	
	get_node("world/player").permit("E")
	get_node("world/player").permit("Q")
	
	var snake0 = preload("res://scenes/enemies/snake.tscn").instance()
	snake0.name = "snake"
	snake0.INIT_LEN = 20
	snake0.global_position = Vector2(512.0, 0.0)
	snake0.player = $world/player
	
	world.add_child(snake0)
	
	var vector0 = preload("res://scenes/enemies/vector.tscn").instance()
	vector0.name = "vector"
	vector0.global_position = Vector2(510.0, 0.0)
	vector0.player = $world/player
	world.add_child(vector0)
	
	var vector1 = preload("res://scenes/enemies/vector.tscn").instance()
	vector1.name = "vector"
	vector1.global_position = Vector2(514.0, 0.0)
	vector1.player = $world/player
	world.add_child(vector1)
	
	var vector2 = preload("res://scenes/enemies/vector.tscn").instance()
	vector2.name = "vector"
	vector2.global_position = Vector2(512.0, 150.0)
	vector2.player = $world/player
	world.add_child(vector2)
	
	var exit = preload("res://scenes/entities/exit.tscn").instance()
	exit.name = "exit"
#	32, 12
	exit.rect_global_position = Vector2(524.0, 20.0)
	world.add_child(exit)
	
	completed.append("intro")
	
	yield(exit, "interacted")
	
	exit.rect_global_position = Vector2(524.0, 580.0)
	
	yield(exit, "interacted")
	
	emit_signal("next_level")

func player_died():
	get_node("..").restart_scene()

func _ready():
	yield(intro(), "completed")
