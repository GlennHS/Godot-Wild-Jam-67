extends Node2D
class_name AudioManagerClass

@onready var mp := $MusicPlayer

func _ready():
	var master_bus_index = AudioServer.get_bus_index("Master")
	var music_bus_index = AudioServer.get_bus_index("Music")
	
	if (OS.is_debug_build() and not get_node("/root/GlobalVariables").g_force_prod):
		AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(0)) # I got sick of hearing the music lol
		return
	for i in 11:
		AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(i * 0.1))
		await get_tree().create_timer(0.1).timeout
		
func change_music(music: AudioStream):
	var current_vol = db_to_linear(mp.volume_db)
	for i in 11:
		mp.volume_db = linear_to_db(current_vol - i * 0.1)
		await get_tree().create_timer(0.15).timeout
	mp.stream = music
	mp.play()
	for i in 11:
		mp.volume_db = linear_to_db(current_vol - ((10 - i) * 0.1))
		await get_tree().create_timer(0.15).timeout
