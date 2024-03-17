extends Node2D
class_name Player

@onready var tile_map: TileMap = get_node("/root/Level/%TileMap")
@onready var cursor_script = get_node("/root/Level/CursorScript")
@onready var max_health: int = health
@onready var ui: UIScript = get_node("/root/UI")
@onready var level: Level = get_node("/root/Level")

@export var health = 100.0

var shotgun = InventoryItem.new("Shotgun", "", "res://sprites/ui_sprites/guns/shotgun.png", "Gun")

signal player_damaged

# UI Signals
signal ammo_counts_updated
signal gun_updated
signal guns_held_updated
signal ammo_updated
signal player_stats_updated
signal inventory_updated

var is_turn := true
var can_shoot := true
var in_mag: int = 0
var mags_held: int = 2
var inventory: Array[InventoryItem] = []
var guns_held: Array[Gun] = []

const GUN_SCENE_MAP = {
	"Pistol": "res://scenes/guns/pistol.tscn",
	"Shotgun": "res://scenes/guns/shotgun.tscn",
	"MP5": "res://scenes/guns/mp5.tscn",
}

func _ready():
	%Healthbar.value = health
	
	ui.show_ui()
	ui.connect("ui_entered", disable_firing)
	ui.connect("ui_exited", enable_firing)
	
	if get_tree().get_nodes_in_group("pickups").size() > 0:
		for p in get_tree().get_nodes_in_group("pickups"):
			p.connect("picked_up", picked_item_up)
	
	# Debugging stuff
	if OS.is_debug_build():
		picked_item_up(InventoryItem.new("Pistol", "Charles' trusy sidearm, been with him through 20 years of service and never leaves his side. So why is it here?...", "res://sprites/ui_sprites/guns/pistol.png", "Gun"))
		change_gun("res://scenes/guns/pistol.tscn")

func _physics_process(_delta):
	if health > 0:
		$RotationPoint.look_at(get_global_mouse_position())

func _input(event):
	if not is_turn or health <= 0:
		return
	
	var has_moved = false
	var has_shot = false
	if event.is_action_pressed("move_down"):
		has_moved = move(Vector2.DOWN)
	elif event.is_action_pressed("move_up"):
		has_moved = move(Vector2.UP)
	elif event.is_action_pressed("move_left"):
		has_moved = move(Vector2.LEFT)
	elif event.is_action_pressed("move_right"):
		has_moved = move(Vector2.RIGHT)
	elif event.is_action_pressed("reload"):
		if mags_held > 0:
			mags_held -= 1
			get_gun().reload()
			in_mag = get_gun().get_ammo_count()
			ammo_counts_changed()
			has_moved = true
	elif event.is_released() && event.is_action_released("shoot"):
		if(can_shoot and in_mag > 0):
			get_gun().shoot()
			has_moved = true
			has_shot = true
			in_mag = get_gun().get_ammo_count()
			ammo_counts_changed()
	else:
		# We don't want to bother continuing or process a turn so exit here
		return
	
	if not has_moved:
		return
	is_turn = false
	refresh_ui()
	
	if has_shot or has_moved:
		cursor_script.set_cursor("wait")
		$TurnWaitTimer.start()
		await $TurnWaitTimer.timeout
		cursor_script.set_cursor("base")
	
	for mob in get_tree().get_nodes_in_group("mobs"):
		if mob.has_method("execute_turn"):
			mob.execute_turn()
	
	if get_tree().get_nodes_in_group("pickups").size() > 0:
		for p in get_tree().get_nodes_in_group("pickups"):
			if not p.is_connected("picked_up", picked_item_up):
				p.connect("picked_up", picked_item_up)
	
	is_turn = true
	refresh_ui()

func move(direction: Vector2):
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	@warning_ignore("narrowing_conversion")
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	
	var target_tile_global = tile_map.map_to_local(target_tile)
	if level.check_door_at_location(target_tile_global):
		var target_door = level.get_door_at_location(target_tile_global)
		if target_door is Door:
			var key_needed = target_door.get_needed_key_name()
			
			for item in inventory:
				if item.item_name == key_needed:
					level.remove_door(target_door)
			return false
	# Get custom data from the target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return false
	
	for mob: Mob in get_tree().get_nodes_in_group("mobs"):
		if mob.health > 0:
			var mob_tile = tile_map.local_to_map(mob.global_position)
			if target_tile == mob_tile:
				return false
	
	# Move player
	global_position = tile_map.map_to_local(target_tile)
	$WalkSound.pitch_scale = randf_range(0.8, 1.2)
	$WalkSound.play()
	return true

func try_open_door() -> bool:
	return false

func hit(hit_data):
	health -= hit_data.damage
	update_healthbar()
	emit_signal("player_damaged", health / max_health)
	emit_signal("player_stats_updated", get_player_stats())
	$HurtSound.play()
	if health <= 0:
		health = 0
		game_over()

func get_light_radius() -> float:
	return $PointLight2D.texture.get_width() * $PointLight2D.scale.x / 2

func refresh_ui() -> void:
	ammo_counts_changed()
	player_stats_changed()
	update_healthbar()

func update_healthbar() -> void:
	%Healthbar.value = health
	
func disable_firing() -> void:
	can_shoot = false
	
func enable_firing() -> void:
	can_shoot = true
	
func ammo_counts_changed() -> void:
	emit_signal("ammo_counts_updated", get_ammo_held_stats())
	
func player_stats_changed() -> void:
	emit_signal("player_stats_updated", get_player_stats())
	
func gun_changed() -> void:
	emit_signal("gun_updated", get_gun().get_gun_stats())
	
func get_player_stats() -> PlayerStats:
	return PlayerStats.new(
		health,
		max_health,
		0,
		0,
	)

func get_ammo_held_stats() -> AmmoHeldStats:
	return AmmoHeldStats.new(
		in_mag,
		get_gun().mag_size,
		mags_held
	)

func get_gun_by_scene(scene_path: String) -> String:
	for _name in GUN_SCENE_MAP:
		if GUN_SCENE_MAP[_name] == scene_path:
			return _name
	return ""

func change_gun(new_gun_scene: String) -> void:
	#var gun_scene: Resource = load(new_gun_scene) # Load the new Gun's scene
	#var gun: Gun = gun_scene.instantiate() # Instantiate the new Gun
	var gun = get_gun_from_held_guns(get_gun_by_scene(new_gun_scene)).duplicate()
	var saved_offset: Vector2 = get_gun().position # Remember the offset for the gun so it looks normal
	gun.position = saved_offset
	in_mag = gun.get_ammo_count()

	$RotationPoint/Gun.name = "GunR" # Do this otherwise new gun gets called "Gun2" and breaks everything
	$RotationPoint/GunR.queue_free()
	$RotationPoint.add_child(gun)
	gun.name = "Gun"
	
	gun_changed()
	refresh_ui()

func change_gun_by_name(name: String) -> void:
	change_gun(GUN_SCENE_MAP[name])

func get_gun() -> Gun:
	return $RotationPoint/Gun

func picked_item_up(item: InventoryItem) -> void:
	if item.item_type == "Gun":
		picked_gun_up(item)
	elif item.item_type == "Key":
		if not inventory_check_for_item_by_name(item.item_name):
			inventory.append(item)
			emit_signal("inventory_updated", inventory)
			
func picked_gun_up(item: InventoryItem) -> void:
	if not guns_check_for_gun_by_name(item.item_name):
		var gun_scene: Gun = load(GUN_SCENE_MAP[item.item_name]).instantiate()
		guns_held.append(gun_scene)
		emit_signal("guns_held_updated", guns_held)
	
func inventory_check_for_item_by_name(item_name: String) -> bool:
	return get_inventory_item_index_by_name(item_name) != -1
	
func get_inventory_item_index_by_name(item_name: String) -> int:
	var i: int = 0
	for item: InventoryItem in inventory:
		if item.item_name == item_name:
			return i
		else:
			i += 1
	return -1
	
func inventory_remove_item(item_name: String) -> bool:
	if inventory_check_for_item_by_name(item_name):
		var index = get_inventory_item_index_by_name(item_name)
		inventory.remove_at(index)
		return true
	else:
		return false

func guns_check_for_gun_by_name(item_name: String) -> bool:
	return get_inventory_item_index_by_name(item_name) != -1

func get_gun_index_from_guns_by_name(item_name: String) -> int:
	var i: int = 0
	for _gun: Gun in guns_held:
		if _gun.gun_name == item_name:
			return i
		else:
			i += 1
	return -1

func get_gun_from_held_guns(gun_name: String) -> Variant:
	var i: int = 0
	for _gun: Gun in guns_held:
		if _gun.gun_name == gun_name:
			return _gun
		else:
			i += 1
	return null

func game_over():
	get_tree().paused = true
	$RotationPoint/PlayerSprite.texture = load("res://sprites/tombstone.png")
	$RotationPoint.rotation_degrees = 270
	$RotationPoint/PlayerSprite.position = Vector2.ZERO
	get_node("/root/Level/GameOver").show()
