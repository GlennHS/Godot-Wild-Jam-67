extends CanvasLayer
class_name DialogueHandler

signal dialogue_ended
	
var current_dialogue: Array[DialogueItem] = [
	DialogueItem.new({
		"dialogue": "This is some dialogue.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	DialogueItem.new({
		"dialogue": "Here's more dialogue.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	DialogueItem.new({
		"dialogue": "And even more!",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	DialogueItem.new({
		"dialogue": "",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	DialogueItem.new({
		"dialogue": "Did you like that empty dialogue?",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	DialogueItem.new({
		"dialogue": "No? Well too bad.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	})
]
var position_in_dialogue = 0

func _ready():
	hide_dialogue()

func _input(event: InputEvent) -> void:
	if InputEventMouseButton and event.is_pressed():
		progress_dialogue()

func show_dialogue():
	get_tree().paused = true
	visible = true
	
func hide_dialogue():
	get_tree().paused = false
	visible = false
	
func progress_dialogue():
	position_in_dialogue += 1
	if position_in_dialogue < current_dialogue.size():
		update_dialogue_UI()
	else:
		hide_dialogue()
		emit_signal("dialogue_ended")
	
func set_dialogue_stream(new_dialogue_stream):
	current_dialogue = new_dialogue_stream
	position_in_dialogue = 0
	update_dialogue_UI()
	
func get_current_dialogue():
	return current_dialogue[position_in_dialogue]

func update_dialogue_UI():
	var d: DialogueItem = get_current_dialogue()
	
	$DialogueContainer/HBoxContainer/DialogueText.text = d.dialogue
	$DialogueContainer/HBoxContainer/VBoxContainer/SpeakerName.text = d.speaker_name
	$DialogueContainer/HBoxContainer/VBoxContainer/SpeakerImage.texture = load(d.speaker_image_path)
