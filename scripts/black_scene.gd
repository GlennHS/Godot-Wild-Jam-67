extends Node2D

@onready var dialogue_handler: DialogueHandler = get_node("/root/DialogueUI")

var dialogue: Array[DialogueItem] = [
	DialogueItem.new({
		"dialogue": "...",
		"speaker_name": "???",
		"speaker_image_path": "res://sprites/portraits/black-square.png"
	}),
	DialogueItem.new({
		"dialogue": "What... where am I?",
		"speaker_name": "???",
		"speaker_image_path": "res://sprites/portraits/black-square.png"
	}),
	DialogueItem.new({
		"dialogue": "This... isn't my bed.",
		"speaker_name": "???",
		"speaker_image_path": "res://sprites/portraits/black-square.png"
	}),
	DialogueItem.new({
		"dialogue": "And why do I hear scurrying?",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	DialogueItem.new({
		"dialogue": "Time I found out what the hell's going on here.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
]

func _ready() -> void:
	if(not OS.is_debug_build()):
		dialogue_handler.set_dialogue_stream(dialogue)
		dialogue_handler.show_dialogue()
		await dialogue_handler.dialogue_ended
	else:
		await get_tree().create_timer(0.1).timeout # Godot throws a hissy if you immediately jump scene
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	pass
