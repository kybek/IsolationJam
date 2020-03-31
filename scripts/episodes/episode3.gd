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
	[" ", 0.001, "adam@~/.local/share/Trash$ ", 0.001]
]

func mutate(chr: String) -> String:
	var r = randf() * 11.0
	
	if r < 10.0:
		return str(floor(r))
	
	return ' '

#signal exit

var prev := Vector2(0.0, 0.0)

func intro():
	var dialogues = intro_dialogues
	for i in range(len(dialogues)):
		yield(printf(dialogues[i][0], dialogues[i][1], dialogues[i][2]), "completed")
		yield(get_tree().create_timer(dialogues[i][3]), "timeout")
	
#	$camera.current = true
	var world = preload("res://scenes/world.tscn").instance()
	world.name = "world"
	world.get_node("charWindow").filepath = "res://maps/tentacles.gd"
	
	add_child(world)
	
	for i in range(0, world.get_node("charWindow").ROWS):
		for j in range(0, world.get_node("charWindow").COLS):
			if world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text == ".":
				world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text = mutate(world.get_node("charWindow").get_node(str(i * world.get_node("charWindow").COLS + j)).text)
	
	world.get_node("player").position = Vector2(55.5, 10.0) + Vector2(25 * 12.0, 3 * 20.0)
	
	get_node("world/player").permit("E")
	get_node("world/player").permit("Q")
	
	var exit = preload("res://scenes/entities/exit.tscn").instance()
	exit.name = "exit"
#	32, 12
	exit.rect_global_position = world.get_node("charWindow").rect_global_position + Vector2(40 / 2 * 12, 20 / 2 * 20) + Vector2(-10 * 12.0, 1 * 20.0)
	prev = exit.rect_global_position
	world.add_child(exit)
	
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.name = "vector"
	vector.global_position = world.get_node("charWindow").rect_global_position + Vector2(40 / 2 * 12, 20 / 2 * 20) + Vector2(-10 * 12.0, 1 * 20.0)
	vector.player = $world/player
	world.add_child(vector)
	
	yield(exit, "interacted")
	
#	exit.get_node("area/collisionShape").set_deferred("disabled", true)
#	exit.get_node("area").set_deferred("monitoring", false)
#	exit.call_deferred("free")
	
	world.call_deferred("remove_child", exit)
	
	completed.append("intro")

func player_died():
	get_node("..").restart_scene()

func phase2():
	var exit = preload("res://scenes/entities/exit.tscn").instance()
	exit.name = "exit"
#	32, 12
	exit.rect_global_position = Vector2(prev.x, 10.0 + 3 * 20.0)
	$world.add_child(exit)
#	$world.get_node("charWindow").hide()
	
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.name = "vector"
	vector.global_position = Vector2(prev.x, 10.0 + 3 * 20.0)
	vector.player = $world/player
	$world.add_child(vector)
	
	yield(exit, "interacted")
	
#	exit.get_node("area/collisionShape").set_deferred("disabled", true)
#	exit.get_node("area").set_deferred("monitoring", false)
#	exit.call_deferred("free")
	
	$world.call_deferred("remove_child", exit)

func phase3():
	var exit = preload("res://scenes/entities/exit.tscn").instance()
	exit.name = "exit"
#	32, 12
	exit.rect_global_position = Vector2(55.5 + 25 * 12.0, prev.y)
	$world.add_child(exit)
#	$world.get_node("charWindow").hide()
	
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.name = "vector"
	vector.global_position = Vector2(55.5 + 25 * 12.0, prev.y)
	vector.player = $world/player
	$world.add_child(vector)
	
	yield(exit, "interacted")
	
#	exit.get_node("area/collisionShape").set_deferred("disabled", true)
#	exit.get_node("area").set_deferred("monitoring", false)
#	exit.call_deferred("free")
	
	$world.call_deferred("remove_child", exit)

func phase4():
	var exit = preload("res://scenes/entities/exit.tscn").instance()
	exit.name = "exit"
#	32, 12
	exit.rect_global_position = Vector2(55.5, 10.0) + Vector2(25 * 12.0, 3 * 20.0)
	$world.add_child(exit)
#	$world.get_node("charWindow").hide()
	
	var vector = preload("res://scenes/enemies/vector.tscn").instance()
	vector.name = "vector"
	vector.global_position = Vector2(55.5, 10.0) + Vector2(25 * 12.0, 3 * 20.0)
	vector.player = $world/player
	$world.add_child(vector)
	
	yield(exit, "interacted")
	
#	exit.get_node("area/collisionShape").set_deferred("disabled", true)
#	exit.get_node("area").set_deferred("monitoring", false)
#	exit.call_deferred("free")
	
	$world.call_deferred("remove_child", exit)

func _ready():
	yield(intro(), "completed")
	yield(phase2(), "completed")
	yield(phase3(), "completed")
	yield(phase4(), "completed")
	emit_signal("next_level")
