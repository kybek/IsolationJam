extends Node2D

var INIT_LEN = 10

var player = null

var body = []

var aim: Vector2 = Vector2(1.0, 0.0)

func create_head() -> StaticBody2D:
	var t = preload("res://scenes/enemies/snakehead.tscn").instance()
	t.rotation = aim.angle()
	t.name = "head"
	return t

func create_body() -> StaticBody2D:
	var t = preload("res://scenes/enemies/snakebody.tscn").instance()
	return t

func transform_to_upgrade(b) -> void:
	b.modulate.b = 1.0
	b.pickup_mode = true
	b.get_node("collisionShape").disabled = true

func move(vec: Vector2, grow: bool) -> void:
	var headpos = $head.global_position
	var head = $head
#	print(headpos)
	aim = vec
	var new_head = create_head()
	if len(body) > 0:
		var t = create_body()
		remove_child($head)
		head.queue_free()
		body.push_front(t)
		add_child(t)
		t.global_position = headpos
		if not grow:
			remove_child(body[-1])
			body.pop_back()
	else:
		remove_child($head)
		head.queue_free()
		if grow:
			var t = create_body()
			body.push_back(t)
			add_child(t)
			t.global_position = headpos
	
#	print(headpos)
	
	add_child(new_head)
	new_head.global_position = headpos + Vector2(vec.x * 12.0, vec.y * 20.0)
	
	for i in range(len(body)):
		if body[i].global_position == new_head.global_position:
			var j = len(body) - 1
			while j >= i:
				transform_to_upgrade(body[j])
				body.pop_back()
				j -= 1
			break

func attack() -> void:
#	print(player.position, player.global_position, $head.global_position)
	var aim = player.position - $head.global_position
	if abs(aim.x) > abs(aim.y):
		aim.x /= 12.0
		if aim.x > 0.0:
			aim.x = floor(aim.x)
		else:
			aim.x = ceil(aim.x)
		aim.y = 0.0
	else:
		aim.x = 0.0
		aim.y /= 20.0
		if aim.y > 0.0:
			aim.y = floor(aim.y)
		else:
			aim.y = ceil(aim.y)
	
	if aim != Vector2(0.0, 0.0):
#		print(aim)
		move(aim.normalized(), INIT_LEN > 0)
		INIT_LEN = max(0, INIT_LEN - 1)
	else:
#		print(aim)
		player.hit("snake", 0.2)

func spawn_nets() -> void:
	if player != null:
		get_node("..").add_child(preload("res://scenes/net.tscn").instance())
		get_node("../../..").load_music(sounds.nets, "nets")

func _on_Timer_timeout():
	if player != null:
		attack()
