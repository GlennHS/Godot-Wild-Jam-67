extends Gun

func _init() -> void:
	spread = 60
	damage_multiplier = 1.25
	bullets_per_shot = 6
	shots_per_burst = 1
	gun_name = "Shotgun"
	gun_image_path = "res://sprites/ui_sprites/guns/shotgun.png"
	gun_display_name = "Lazov 12-Spread Shotgun"
	mag_size = 4
	bullets_in_mag = mag_size
