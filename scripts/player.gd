extends KinematicBody2D

var SPEED = 200.0

func get_move_vec() -> Vector2:
	var move_vec = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1.0
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1.0
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1.0
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1.0
	
	move_vec = move_vec.normalized()
	return move_vec

func sudo():
	get_node("..").sudo()


func picked_up(object) -> void:
	if object.name == "sudo":
		sudo()
	elif object.name == "eof":
		get_node("../..").emit_signal("next_level")
	elif object.name == "trojanexe":
		get_node("../..").emit_signal("trojanexe")
	elif object.name == "snakebody":
		snakebody()
	elif object.name == "exit":
		get_node("../..").emit_signal("exit")

func snakebody():
	get_node("../..").emit_signal("snakebody")

var can_move: bool = true

func _process(delta):
	if can_move:
		move_and_slide(get_move_vec() * SPEED)

var permissions = []

func permit(permission: String) -> void:
	permissions.append(permission)

var current_power: String = ""

func start_e_power() -> void:
	current_power = "E"
	set_collision_layer_bit(0, true)
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(3, false)
	can_move = false

func stop_e_power() -> void:
	current_power = ""
	set_collision_layer_bit(0, false)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(3, true)
	can_move = true

func e_power() -> void:
	if $animationPlayer.current_animation != "e_power" or $animationPlayer.is_playing() == false:
		$animationPlayer.stop()
		$frame0.hide()
		$animationPlayer.play("e_power")
		start_e_power()
	else:
		$animationPlayer.stop()
		$frame0.hide()
		stop_e_power()

func start_q_power() -> void:
	current_power = "Q"
	$light.show()
	$canvasModulate.show()
	SPEED = 100.0
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(3, false)
	get_node("../../..").load_music(preload("res://sounds/peace.ogg"))

func stop_q_power() -> void:
	current_power = ""
	$light.hide()
	$canvasModulate.hide()
	SPEED = 200.0
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(3, true)
	get_node("../../..").stop_music()

func q_power() -> void:
	if current_power == "":
		start_q_power()
	else:
		stop_q_power()

func hit(by: String, delta: float):
	delta *= 100.0 / 1.0
	if by == "vector":
		self.modulate.a -= delta / 255.0
		if self.modulate.a * 255 <= 155.0:
			get_node("../..").player_died()
	if by == "snake":
		self.modulate.a -= delta / 255.0
		if self.modulate.a * 255 <= 155.0:
			get_node("../..").player_died()
	if by == "tentacle":
		self.modulate.a -= delta / 255.0
		if self.modulate.a * 255 <= 155.0:
			get_node("../..").player_died()

func _input(event):
	if not event is InputEventKey:
		return
	
	if not event.pressed:
		return
	
	if event.scancode == KEY_E:
		if "E" in permissions:
			if current_power == "" or current_power == "E":
				e_power()
	
	if event.scancode == KEY_Q:
		if "Q" in permissions:
			if current_power == "" or current_power == "Q":
				q_power()

func _ready():
	$frame0.hide()
	$Camera2D.current = true
