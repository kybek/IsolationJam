extends Node2D

var episodes = [
#	preload("res://scenes/episodes/episode0.tscn"),
#	preload("res://scenes/episodes/intro.tscn"),
#	preload("res://scenes/episodes/episode0.tscn"),
#	preload("res://scenes/episodes/episode1.tscn"),
	preload("res://scenes/episodes/episode2.tscn"),
	preload("res://scenes/episodes/episode3.tscn"),
	preload("res://scenes/episodes/episode4.tscn"),
	preload("res://scenes/episodes/episode5.tscn")
]

var titles = [
#	"TEST",
#	"INTRO",
#	"EPISODE0",
#	"EPISODE1",
	"EPISODE2",
	"EPISODE3",
	"EPISODE4",
	"EPISODE5"
]

var current_episode = 0

signal title_changed

func episode_finished():
	var t = $episode
#	t.get_node("camera").current = false
	t.call_deferred("free")
#	call_deferred("remove_child", t)
	remove_child(t)
	current_episode += 1
	if current_episode < len(episodes):
		t = episodes[current_episode].instance()
	#	t.hide()
		t.name = "episode"
		t.connect("next_level", self, "episode_finished")
		t.rect_size = Vector2(1024.0, 600.0)
		t.set("custom_fonts/normal_font", preload("res://modified_font.tres"))
		t.get_node("camera").current = false
		add_child(t)
#		emit_signal("title_changed", titles[current_episode])
	else:
		get_node("../CanvasLayer2/dialogue").modulate.r = 0.0
		get_node("../CanvasLayer2/dialogue").text = "Thanks for playing!"

func restart_scene():
	stop_music()
	var t = $episode
#	t.get_node("camera").current = false
	t.call_deferred("free")
#	call_deferred("remove_child", t)
	remove_child(t)
	
	t = episodes[current_episode].instance()
	t.name = "episode"
	t.connect("next_level", self, "episode_finished")
	add_child(t)
	t.rect_size = Vector2(1024.0, 600.0)
	t.set("custom_fonts/normal_font", preload("res://modified_font.tres"))
#	t.get_node("camera").current = true
#	emit_signal("title_changed", titles[current_episode])

func load_music(m, channel = "ambient"):
	print(channel)
	get_node(channel).stream = m
	get_node(channel).play()

func stop_music(channel = "ambient"):
	get_node(channel).stop()

func _ready():
	get_node("../CanvasLayer2/dialogue").modulate.r = 0.0
	yield(get_tree().create_timer(4.0), "timeout")
	get_node("../CanvasLayer2/dialogue").detect_position = true
	var t = episodes[current_episode].instance()
#	t.hide()
	t.name = "episode"
	t.connect("next_level", self, "episode_finished")
	t.rect_size = Vector2(1024.0, 600.0)
	t.set("custom_fonts/normal_font", preload("res://modified_font.tres"))
#	t.get_node("camera").current = false
	add_child(t)
#	t.show()
#	emit_signal("title_changed", titles[current_episode])
