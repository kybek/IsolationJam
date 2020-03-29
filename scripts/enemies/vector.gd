extends KinematicBody2D

const SPEED = 300

var player = null

var aim: bool = false

func start_aiming():
	aim = true

func stop_aiming():
	aim = false

var attacking: bool = false

func start_attacking():
	attacking = true

func stop_attacking():
	attacking = false

func f(angle: float) -> float:
	var a0 = rotation_degrees
	if a0 < 0.0:
		a0 = 360.0 + rotation_degrees
	
	var a1 = rad2deg(angle)
	if a1 < 0.0:
		a1 = 360.0 + rad2deg(angle)
	
	if abs(a0 - a1) <= 180.0:
		rotation_degrees = a0
		return a1
	elif a0 < a1:
		rotation_degrees = 360.0 + a0
		return a1
	else:
		rotation_degrees = a0 - 360.0
		return a1

func _physics_process(delta):
	if player != null and $AnimationPlayer.is_playing() == false and global_position.distance_to(player.global_position) <= 500.0:
		$AnimationPlayer.play("attack")
	
	if player == null:
		return
	
	
	if aim:
		var vec: Vector2 = player.global_position - global_position
		var t = player
		player = null
		var dest = f(vec.angle())
		
		$Tween.interpolate_property(self, "rotation_degrees", rotation_degrees, dest, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		yield($Tween, "tween_completed")
#		rotation = vec.angle()
		player = t
	
	if attacking:
		var collision = move_and_collide(Vector2(1.0, 0.0).rotated(rotation) * SPEED * delta)
		if collision == null:
			return
		if collision.collider.name == "player":
			collision.collider.hit("vector")
