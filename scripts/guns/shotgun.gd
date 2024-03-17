extends Gun

func _init() -> void:
	spread = 60
	damage_multiplier = 1.5
	bullets_per_shot = 12
	shots_per_burst = 1
	gun_name = "Shotgun"
	gun_image_path = "res://sprites/guns/gun.png"
	gun_display_name = "Lazov 12-Spread Shotgun"
	mag_size = 4
	bullets_in_mag = mag_size
