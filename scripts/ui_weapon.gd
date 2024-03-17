extends PanelContainer
class_name UI_Weapon

func _ready() -> void:
	pass
	
func prep(gun_stats: GunStats) -> void:
	var gun_texture: TextureRect = $GunTexture
	gun_texture.texture = load(gun_stats.gun_image_path)
	$VBoxContainer/GunName.text = gun_stats.gun_display_name
	$VBoxContainer/GunDamage.text = str("Damage Multiplier: ", gun_stats.damage_multiplier)
	$VBoxContainer/GunFireRate.text = str("Shots per burst: ", gun_stats.bullets_per_shot)
	$VBoxContainer/GunBurstCount.text = str("Bursts per trigger pull: ", gun_stats.shots_per_burst)
