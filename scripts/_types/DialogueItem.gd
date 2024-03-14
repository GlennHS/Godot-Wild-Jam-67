extends Node
class_name DialogueItem

var dialogue: String = ""
var speaker_name: String = ""
var speaker_image_path: String = ""

func _init(obj) -> void:
	dialogue = obj.dialogue
	speaker_name = obj.speaker_name
	speaker_image_path = obj.speaker_image_path
