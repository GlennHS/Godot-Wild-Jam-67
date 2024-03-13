extends Control

var master_bus_index: int
var music_bus_index: int
var sfx_bus_index: int

@onready var master_bus_slider: HSlider = $GridContainer/MasterSlider
@onready var music_bus_slider: HSlider = $GridContainer/MusicSlider
@onready var sfx_bus_slider: HSlider = $GridContainer/SFXSlider

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")

	master_bus_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))
	music_bus_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))
	sfx_bus_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))

func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
