extends CanvasLayer

@onready var ui: CanvasLayer = get_node("/root/Game/UI")
@onready var fb: ColorRect = get_node("FacePanel/FaceBackground")
@onready var player: Player = get_node("/root/Game/Player")
@onready var gun: Gun = player.get_gun()

@onready var in_mag_ui: Label = $GunStats/GunMags
@onready var mags_remaining_ui: Label = $GunStats/GunMagR
@onready var player_health_ui: Label = $PlayerStats/PlayerHealth
@onready var player_shield_ui: Label = $PlayerStats/PlayerShield

signal ui_entered
signal ui_exited

func _ready() -> void:
	player.connect("player_damaged", set_face_background_alpha)
	player.connect("gun_updated", ui_update_gun)
	player.connect("ammo_counts_updated", ui_update_ammo_counts)
	player.connect("player_stats_updated", ui_update_player_stats)
	gun.connect("ammo_changed", ui_update_ammo)
	player.refresh_ui() # Call here to avoid race condition with signal connects above

func set_face_background_alpha(percent: float) -> void:
	var c: Color = fb.get_color()
	fb.set_color(Color(c.r, c.g, c.b, percent))
	
func ui_update_gun(gun_stats) -> void:
	#var gun_texture: TextureRect = ui.get_node("WeaponContainer/GunRect/GunTexture")
	#gun_texture.texture = gun_stats.image
	pass
	
func ui_update_ammo(ammo_stats) -> void:
	pass
	
func ui_update_player_stats(player_stats: PlayerStats) -> void:
	player_health_ui.text = str(player_stats.health)
	player_shield_ui.text = str(player_stats.armor)
	
func ui_update_ammo_counts(ammo_data: AmmoHeldStats) -> void:
	mags_remaining_ui.text = str(ammo_data.mags_held)
	in_mag_ui.text = str(ammo_data.in_mag, "/", ammo_data.mag_size)

func ui_mouse_entered() -> void:
	emit_signal("ui_entered")

func ui_mouse_exited() -> void:
	emit_signal("ui_exited")


func _on_tab_hovered(_tab) -> void:
	ui_mouse_entered()
