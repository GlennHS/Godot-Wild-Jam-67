extends PanelContainer
class_name weapon_ui

var gun_stats: GunStats

func _ready() -> void:
	$GunTexture.texture = load(gun_stats.gun_image_path)
	$ItemsContainer/Weapon/VBoxContainer/GunName.text = gun_stats.gun_name
	$ItemsContainer/Weapon/VBoxContainer/GunDamage.text = str("Damage Multiplier: ", gun_stats.damage_multiplier)
	$ItemsContainer/Weapon/VBoxContainer/GunFireRate.text = str("Shots per burst: ", gun_stats.bullets_per_shot)
	$ItemsContainer/Weapon/VBoxContainer/GunBurstCount.text = str("Bursts per trigger pull: ", gun_stats.shots_per_burst)
