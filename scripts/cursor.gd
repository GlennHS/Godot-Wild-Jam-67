extends Node

@onready var cursor = load("res://cursors/cursor.png")

@onready var wait_cursor: AnimatedSprite2D
@onready var SFL: SpriteFrames

func _ready():
	wait_cursor = get_node("/root/Game/WaitCursorSprite")
	SFL = wait_cursor.sprite_frames
	

var current_cursor = "base"

func _physics_process(_delta):
	if current_cursor == "wait":
		Input.set_custom_mouse_cursor(SFL.get_frame_texture("default", wait_cursor.frame), Input.CURSOR_ARROW, Vector2(16, 16) / 2)
	else:
		Input.set_custom_mouse_cursor(cursor)

func set_cursor(cursor_name):
	current_cursor = cursor_name
