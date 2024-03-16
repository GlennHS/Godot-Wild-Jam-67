extends StaticBody2D
class_name Door

@export var key_needed: String = ""

func get_needed_key_name() -> String:
	return key_needed
	
func unlock_door() -> void:
	visible = false
	queue_free()
