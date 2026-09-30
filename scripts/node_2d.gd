extends Node2D
var speed = 100
var direction = 0
var screen_size = Vector2()
var window_size = Vector2(200, 200)
var is_dragging = false
var drag_offset = Vector2()
var click_count = 0
var click_timer = 0.0
var click_window = 0.5
var reaction_timer = 0.0
@onready var sprite = $AnimatedSprite2D
@onready var area = $Area2D
func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())
	var center_pos = (screen_size - window_size) / 2
	DisplayServer.window_set_position(Vector2i(center_pos))
	area.input_event.connect(_on_area_input)
func _physics_process(delta):
	if click_timer > 0:
		click_timer -= delta
		if click_timer <= 0:
			click_count = 0
	if reaction_timer > 0:
		reaction_timer -= delta
	if is_dragging:
		var mouse_pos = Vector2(DisplayServer.mouse_get_position())
		var new_win_pos = mouse_pos - drag_offset
		DisplayServer.window_set_position(Vector2i(new_win_pos))
		sprite.play("drag")
		return
	if Input.is_key_pressed(KEY_RIGHT):
		direction = 1
	elif Input.is_key_pressed(KEY_LEFT):
		direction = -1
	else:
		direction = 0
	var win_pos = Vector2(DisplayServer.window_get_position())
	win_pos.x += direction * speed * delta
	win_pos.x = clamp(win_pos.x, 0, screen_size.x - window_size.x)
	win_pos.y = clamp(win_pos.y, 0, screen_size.y - window_size.y)
	DisplayServer.window_set_position(Vector2i(win_pos))
	if reaction_timer <= 0:
		if direction == 1:
			sprite.play("walk_right")
		elif direction == -1:
			sprite.play("walk_left")
		else:
			sprite.play("idle")
func _on_area_input(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			var mouse_pos = Vector2(DisplayServer.mouse_get_position())
			var win_pos = Vector2(DisplayServer.window_get_position())
			drag_offset = mouse_pos - win_pos
		else:
			if is_dragging:
				is_dragging = false
				click_count += 1
				click_timer = click_window
				if click_count == 1:
					sprite.play("click")
					reaction_timer = 0.6
				elif click_count == 2:
					sprite.play("happy")
					reaction_timer = 1.0
				else:
					sprite.play("angry")
					reaction_timer = 1.0
