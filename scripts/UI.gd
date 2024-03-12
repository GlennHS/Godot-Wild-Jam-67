extends CanvasLayer

@onready var ui = get_node("/root/Game/UI")
@onready var fb = get_node("FacePanel/FaceBackground")
@onready var player = get_node("/root/Game/Player")
@onready var gun = get_node("/root/Game/Player/RotationPoint/Gun")

func _ready():
	player.connect("player_damaged", set_face_background_alpha)
	gun.connect("ammo_changed", ui_update_ammo)

func set_face_background_alpha(percent: float):
	var c: Color = fb.get_color()
	fb.set_color(Color(c.r, c.g, c.b, percent))
	
func ui_update_gun(gun_stats):
	var gun_texture: TextureRect = ui.get_node("WeaponContainer/GunRect/GunTexture")
	gun_texture.texture = gun_stats.image
	pass
	
func ui_update_ammo(ammo_stats):
	pass
