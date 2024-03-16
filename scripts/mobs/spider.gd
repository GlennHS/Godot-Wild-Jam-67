extends Mob

func execute_turn():
	super.execute_turn()
	if (OS.is_debug_build() and not get_node("/root/GlobalVariables").g_force_prod):
		identify_self()

func identify_self() -> void:
	if name == "Spider1":
		var sb = StyleBoxFlat.new()
		sb.bg_color = (Color(255,0,0))
		$Healthbar.add_theme_stylebox_override("fill", sb)
	elif name == "Spider2":
		var sb = StyleBoxFlat.new()
		sb.bg_color = (Color(0,255,0))
		$Healthbar.add_theme_stylebox_override("fill", sb)
	elif name == "Spider3":
		var sb = StyleBoxFlat.new()
		sb.bg_color = (Color(0,0,255))
		$Healthbar.add_theme_stylebox_override("fill", sb)
	elif name == "Spider4":
		var sb = StyleBoxFlat.new()
		sb.bg_color = (Color(255,255,0))
		$Healthbar.add_theme_stylebox_override("fill", sb)
	pass
