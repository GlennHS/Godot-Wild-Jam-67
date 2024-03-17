extends CanvasLayer
class_name UIScript

@onready var ui: CanvasLayer = get_node("/root/UI")
@onready var fb: ColorRect = get_node("FacePanel/FaceBackground")
@onready var in_mag_ui: Label = $GunStats/InMagText
@onready var mags_remaining_ui: Label = $GunStats/MagsHeldText
@onready var player_health_ui: Label = $PlayerStats/PlayerHealth
@onready var player_shield_ui: Label = $PlayerStats/PlayerShield

var player: Player
var gun: Gun

signal ui_ready
signal ui_entered
signal ui_exited

func _ready() -> void:
	hide_ui()
	emit_signal("ui_ready")
	
func prep_ui() -> void:
	player = get_node("/root/Level/Player")
	gun = player.get_gun()
	
	player.connect("player_damaged", set_face_background_alpha)
	player.connect("gun_updated", ui_update_held_gun)
	player.connect("guns_held_updated", ui_update_guns)
	player.connect("ammo_counts_updated", ui_update_ammo_counts)
	player.connect("player_stats_updated", ui_update_player_stats)
	player.connect("inventory_updated", ui_update_inventory_items)
	gun.connect("ammo_changed", ui_update_ammo)
	player.refresh_ui() # Call here to avoid race condition with signal connects above

func set_face_background_alpha(percent: float) -> void:
	var c: Color = fb.get_color()
	fb.set_color(Color(c.r, c.g, c.b, percent))
	
func ui_update_held_gun(gun_stats: GunStats) -> void:
	pass

func ui_update_guns(guns: Array[Gun]) -> void:
	for child in %GunsContainer.get_children():
		%GunsContainer.remove_child(child)
	for _gun in guns:
		var ui_weapon_scene: UI_Weapon = load("res://scenes/ui_weapon.tscn").instantiate()
		ui_weapon_scene.prep(_gun.get_gun_stats())
		%GunsContainer.add_child(ui_weapon_scene)

func ui_update_ammo(ammo_stats) -> void:
	pass
	
func ui_update_player_stats(player_stats: PlayerStats) -> void:
	player_health_ui.text = str(player_stats.health)
	player_shield_ui.text = str(player_stats.armor)
	
func ui_update_ammo_counts(ammo_data: AmmoHeldStats) -> void:
	mags_remaining_ui.text = str(ammo_data.mags_held)
	in_mag_ui.text = str(ammo_data.in_mag, "/", ammo_data.mag_size)
	
func ui_update_objective(obj: String) -> void:
	$"ObjectiveContainer/Current Objective".text = obj

func ui_update_inventory_items(inventory: Array[InventoryItem]) -> void:
	for child in $ItemsContainer/Inventory.get_children():
		$ItemsContainer/Inventory.remove_child(child)
	var item_scene = preload("res://scenes/inventory_item.tscn")
	for item: InventoryItem in inventory:
		var prefab: InventoryItemScene = item_scene.instantiate()
		prefab.setup(item)
		$ItemsContainer/Inventory.add_child(prefab)
	pass

func ui_mouse_entered() -> void:
	emit_signal("ui_entered")

func ui_mouse_exited() -> void:
	emit_signal("ui_exited")

func _on_tab_hovered(_tab) -> void:
	ui_mouse_entered()

func hide_ui() -> void:
	visible = false

func show_ui() -> void:
	prep_ui()
	visible = true
