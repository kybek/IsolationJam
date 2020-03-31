extends Node2D

var SPEED = 400

var L
var R
var U
var D

func _physics_process(delta):
	if L:
		$L.move_and_slide(Vector2(1.0, 0.0) * SPEED)
	if R:
		$R.move_and_slide(Vector2(-1.0, 0.0) * SPEED)
	if U:
		$U.move_and_slide(Vector2(0.0, 1.0) * SPEED)
	if D:
		$D.move_and_slide(Vector2(0.0, -1.0) * SPEED)
	
	if L and $L.position.x > 1100:
		L = false
		$L.queue_free()
		remove_child($L)
	
	if R and $R.position.x < -100:
		R = false
		$R.queue_free()
		remove_child($R)
	
	if U and $U.position.y > 700:
		U = false
		$U.queue_free()
		remove_child($U)
	
	if D and $D.position.y < -100:
		D = false
		$D.queue_free()
		remove_child($D)

func _ready():
	L = true
	R = true
	D = true
	U = true
	$R.position = Vector2(1024.0, 0.0)
	$D.position = Vector2(0.0, 600.0)
