extends Node
class_name GunStats

var bullets_per_shot: int = 1
var shots_per_burst: int = 1
var spread: float = 15.0
var damage_multiplier: float = 1.0
var gun_name: String = "Gun"
var gun_image_path: String = "res://sprites/ui_sprites/guns/pistol.png"
var mag_size: int = 8

func _init(
	_bullets_per_shot,
	_shots_per_burst,
	_spread,
	_damage_multiplier,
	_gun_name,
	_mag_size,
) -> void:
	bullets_per_shot = _bullets_per_shot
	shots_per_burst = _shots_per_burst
	spread = _spread
	damage_multiplier = _damage_multiplier
	gun_name = _gun_name
	mag_size = _mag_size

static func fromObj(obj) -> void:
	return GunStats.new(
		obj.bullets_per_shot,
		obj.shots_per_burst,
		obj.spread,
		obj.damage_multiplier,
		obj.gun_name,
		obj.mag_size,
	)
