extends Node

var g_main_menu_seen = false
var g_force_prod = false

func _ready():
	if (OS.is_debug_build() and not g_force_prod):
		g_main_menu_seen = true
