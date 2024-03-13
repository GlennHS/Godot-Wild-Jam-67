extends Control

@onready var globals = get_node("/root/GlobalVariables")

func _ready():
	if(not globals.g_main_menu_seen):
		for i in 6:
			$Fader.color = Color(0,0,0,1 - i * 0.2)
			await get_tree().create_timer(0.5).timeout
	$Fader.queue_free()
	globals.g_main_menu_seen = true
		

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_derived/options.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_derived/credits.tscn")


func _on_quit_pressed():
	get_tree().quit()
