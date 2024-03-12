extends Control

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed():
	pass # Replace with function body.


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_derived/credits.tscn")


func _on_quit_pressed():
	get_tree().quit()
