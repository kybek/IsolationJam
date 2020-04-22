extends RichTextLabel

var fruit = [
	Color(0.0, 1.0, 1.0, 1.0),
	"But the fruit of the Spirit is ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"love, joy",
	false,
	Color(0.0, 1.0, 1.0, 1.0),
	", peace, patience, kindness, ",
	true,
	Color(1.0, 1.0, 0.0, 1.0),
	"goodness",
	false,
	Color(1.0, 1.0, 1.0, 1.0),
	", faithfulness, gentleness, self-control. Against such there is no law.\n\t\t\tGalatians 5:22-23",
	true
]

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

func love():
#	hide()
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
#	get_node("../../CanvasLayer2/dialogue").detect_position = true
#	get_node("..").stop_music()
#	show()

func intro():
	yield(get_tree(), "idle_frame")
	var world = preload("res://scenes/world.tscn").instance()
	world.name = "world"
	world.get_node("charWindow").filepath = "res://maps/test_map.gd"
	add_child(world)
	var c: Camera2D = world.get_node("player/Camera2D")
	$Tween.interpolate_property(c, "zoom", Vector2(1.0, 1.0), Vector2(0.10, 0.10), 20.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	world.get_node("player").position = Vector2(512.0, 300.0)

func _ready():
	get_node("../../ending").play()
	yield(intro(), "completed")
	yield(love(), "completed")
	get_node("../../CanvasLayer2/screenDirt").hide()
	yield(get_tree().create_timer(1.0), "timeout")
#	get_node("../../background").hide()
	yield(get_tree().create_timer(2.0), "timeout")
	get_node("../../CanvasLayer2/filter").hide()
	get_node("..").stop_music()
	get_node("../../computerfan").stream_paused = true
	yield(get_tree().create_timer(3.0), "timeout")
	hide()
	get_node("../../CanvasLayer2/dialogue").text = "Thanks for playing!"
	yield(get_tree().create_timer(3.0), "timeout")
	get_node("../../CanvasLayer2/dialogue").hide()
