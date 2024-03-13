extends Node2D

func _ready():
	var master_bus_index = AudioServer.get_bus_index("Master")
	for i in 11:
		AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(i * 0.1))
		await get_tree().create_timer(0.1).timeout
