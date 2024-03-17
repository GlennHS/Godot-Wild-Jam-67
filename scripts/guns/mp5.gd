extends Gun

func _init() -> void:
	spread = 20
	damage_multiplier = 1.5
	bullets_per_shot = 1
	shots_per_burst = 4
	gun_name = "MP5"
	gun_image_path = "res://sprites/ui_sprites/guns/mp5.png"
	gun_display_name = "Spray-EZ MP5"
	mag_size = 8
	bullets_in_mag = mag_size
