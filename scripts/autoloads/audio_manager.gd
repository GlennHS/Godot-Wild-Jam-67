extends Node2D

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
	$MusicPlayer.stream = music
