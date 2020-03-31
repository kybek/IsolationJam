extends GridContainer

class_name CharWindow

export var COLS: int = 5
export var ROWS: int = 5
export var filepath: String = ""

signal reseted

func clear() -> void:
	for l in get_children():
		l.queue_free()
		remove_child(l)
	self.rect_size = Vector2(0.0, 0.0)
	emit_signal("reseted")

func reset() -> void:
	clear()
	self.columns = COLS
	
	var cnt = 0
	
	for i in range(0, ROWS):
		for j in range(0, COLS):
			var cell = create_new('.')
			cell.name = String(cnt)
			add_child(cell)
			cnt += 1

func create_new(c: String):
	if c == '.' or c == 'g':
		return preload("res://scenes/entities/grass.tscn").instance()
	if c == '#' or c == 'w':
		return preload("res://scenes/entities/wall.tscn").instance()
	if c == 't':
		return preload("res://scenes/entities/tentacle.tscn").instance()

func load_map(path: String) -> void:
	clear()
	var map = load(path).new()
	
	if map.reversed == false:
		COLS = map.COLS
		ROWS = map.ROWS
		
		self.columns = COLS
		var dynamic_font = DynamicFont.new()
		dynamic_font.font_data = preload("res://Modeseven-L3n5.ttf")
		
		var cnt = 0
		
		for i in range(0, ROWS):
			for j in range(0, COLS):
				var cell = create_new(map.ascii[i][j])
				cell.name = String(cnt)
				add_child(cell)
				cnt += 1
	else:
		COLS = map.ROWS
		ROWS = map.COLS
		
		self.columns = 2 * COLS
		var dynamic_font = DynamicFont.new()
		dynamic_font.font_data = preload("res://Modeseven-L3n5.ttf")
		
		var cnt = 0
		
		for i in range(0, ROWS):
			for j in range(0, COLS):
				var cell = create_new(map.ascii[j][i])
				cell.name = String(cnt)
				add_child(cell)
				cnt += 1
				cell = create_new(map.ascii[j][i])
				cell.name = String(cnt)
				add_child(cell)
				cnt += 1
			for j in range(0, COLS):
				var cell = create_new(map.ascii[j][i])
				cell.name = String(cnt)
				add_child(cell)
				cnt += 1
				cell = create_new(map.ascii[j][i])
				cell.name = String(cnt)
				add_child(cell)
				cnt += 1
		
		COLS *= 2
		ROWS *= 2
func _ready():
	if filepath == "":
		reset()
	else:
		load_map(filepath)
