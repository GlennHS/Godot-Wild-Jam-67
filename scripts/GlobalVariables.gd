extends Node

var g_main_menu_seen = false

func _ready():
	if OS.is_debug_build():
		g_main_menu_seen = true
