extends PanelContainer
class_name UI_Weapon

var gun_stats: GunStats

@onready var player: Player = get_node("/root/Level/Player")

func _ready() -> void:
	pass
	
func prep(_gun_stats: GunStats) -> void:
	var gun_texture: TextureRect = $GunTexture
	gun_texture.texture = load(_gun_stats.gun_image_path)
	$VBoxContainer/GunName.text = _gun_stats.gun_display_name
	$VBoxContainer/GunDamage.text = str("Damage Multiplier: ", _gun_stats.damage_multiplier)
	$VBoxContainer/GunFireRate.text = str("Shots per burst: ", _gun_stats.bullets_per_shot)
	$VBoxContainer/GunBurstCount.text = str("Bursts per trigger pull: ", _gun_stats.shots_per_burst)
	
	gun_stats = _gun_stats

func _on_gui_input(event: InputEvent) -> void:
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		player.change_gun_by_name(gun_stats.gun_name)
