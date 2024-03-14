extends CanvasLayer

class DialogueItem:
	var dialogue: String = ""
	var speaker_name: String = ""
	var speaker_image_path: String = ""
	
func new_dialogue_item(obj) -> DialogueItem:
	var r = DialogueItem.new()
	r.dialogue = obj.dialogue
	r.speaker_name = obj.speaker_name
	r.speaker_image_path = obj.speaker_image_path
	return r

var current_dialogue: Array[DialogueItem] = [
	new_dialogue_item({
		"dialogue": "This is some dialogue.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	new_dialogue_item({
		"dialogue": "Here's more dialogue.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	new_dialogue_item({
		"dialogue": "And even more!",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	new_dialogue_item({
		"dialogue": "",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	new_dialogue_item({
		"dialogue": "Did you like that empty dialogue?",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	}),
	new_dialogue_item({
		"dialogue": "No? Well too bad.",
		"speaker_name": "CHARLES",
		"speaker_image_path": "res://sprites/ui_sprites/player_faces/headshot.png"
	})
]
var position_in_dialogue = 0

func _ready():
	show_dialogue()

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
	
func set_dialogue_stream(new_dialogue_stream):
	pass
	
func get_current_dialogue():
	return current_dialogue[position_in_dialogue]

func update_dialogue_UI():
	var d: DialogueItem = get_current_dialogue()
	var image = Image.load_from_file(d.speaker_image_path)
	var speaker_texture = ImageTexture.create_from_image(image)
	
	$DialogueContainer/HBoxContainer/DialogueText.text = d.dialogue
	$DialogueContainer/HBoxContainer/VBoxContainer/SpeakerName.text = d.speaker_name
	$DialogueContainer/HBoxContainer/VBoxContainer/SpeakerImage.texture = speaker_texture
