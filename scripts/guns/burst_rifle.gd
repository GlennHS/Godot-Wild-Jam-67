extends Gun

func _ready():
	spread = 60
	damage_multiplier = 1
	bullets_per_shot = 12
	shots_per_burst = 1
	gun_name = "Burst Rifle"
	
func get_gun_stats():
	print("Retrieved gun stats")
	return {
		"spread" = 60,
		"damage_multiplier" = 1,
		"bullets_per_shot" = 12,
		"shots_per_burst" = 1,
		"gun_name" = "Burst Rifle",
	}
