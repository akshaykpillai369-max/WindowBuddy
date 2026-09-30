extends Node2D

var speed = 100
var direction = 1
var screen_size = Vector2()
var window_size = Vector2(200, 200)

@onready var sprite = $AnimatedSprite2D

func _ready():
	screen_size = Vector2(DisplayServer.screen_get_size())

	# Start in the centre of the screen
	var center_pos = (screen_size - window_size) / 2
	DisplayServer.window_set_position(Vector2i(center_pos))

func _physics_process(delta):
	var win_pos = Vector2(DisplayServer.window_get_position())

	# Move left/right
	win_pos.x += direction * speed * delta

	# Keep the window inside the screen
	win_pos.x = clamp(win_pos.x, 0, screen_size.x - window_size.x)

	# Keep the pet at its current vertical position
	win_pos.y = clamp(win_pos.y, 0, screen_size.y - window_size.y)

	# Move the window
	DisplayServer.window_set_position(Vector2i(win_pos))

	# Turn around at the edges
	if win_pos.x <= 0:
		direction = 1
	elif win_pos.x >= screen_size.x - window_size.x:
		direction = -1

	# Play the correct animation
	if direction == 1:
		sprite.play("walk_right")
	else:
		sprite.play("walk_left")
