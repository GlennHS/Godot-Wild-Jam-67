extends Node2D
class_name Player

@onready var tile_map: TileMap = get_node("/root/Level/%TileMap")
@onready var cursor_script = get_node("/root/Level/CursorScript")
@onready var max_health: int = health
@onready var ui: UIScript = get_node("/root/UI")
@onready var level: Level = get_node("/root/Level")

@export var health = 100.0

signal player_damaged

# UI Signals
signal ammo_counts_updated
signal gun_updated
signal ammo_updated
signal player_stats_updated
signal inventory_updated

var is_turn := true
var can_shoot := true
var in_mag: int = 6
var mags_held: int = 2
var inventory: Array[InventoryItem] = []

func _ready():
	%Healthbar.value = health
	
	ui.show_ui()
	ui.connect("ui_entered", disable_firing)
	ui.connect("ui_exited", enable_firing)
	
	if get_tree().get_nodes_in_group("pickups").size() > 0:
		for p in get_tree().get_nodes_in_group("pickups"):
			p.connect("picked_up", inventory_add_item)
	
	# Debugging stuff
	if OS.is_debug_build():
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
			in_mag = get_gun().mag_size
			ammo_counts_changed()
			has_moved = true
	elif event.is_released() && event.is_action_released("shoot"):
		if(can_shoot and in_mag > 0):
			get_gun().shoot()
			has_moved = true
			has_shot = true
			in_mag -= 1
			ammo_counts_changed()
	else:
		# We don't want to bother continuing or process a turn so exit here
		return
	
	if not has_moved:
		return
	is_turn = false
	refresh_ui()
	
	if has_shot:
		cursor_script.set_cursor("wait")
		$TurnWaitTimer.start()
		await $TurnWaitTimer.timeout
		cursor_script.set_cursor("base")
	
	for mob in get_tree().get_nodes_in_group("mobs"):
		if mob.has_method("execute_turn"):
			mob.execute_turn()
	
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
		@warning_ignore("narrowing_conversion")
		var mob_tile = tile_map.local_to_map(mob.global_position)
		if target_tile == mob_tile:
			return false
	
	# Move player
	global_position = tile_map.map_to_local(target_tile)
	return true

func try_open_door() -> bool:
	return false

func hit(hit_data):
	health -= hit_data.damage
	update_healthbar()
	emit_signal("player_damaged", health / max_health)
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
		0,
		0,
	)

func get_ammo_held_stats() -> AmmoHeldStats:
	return AmmoHeldStats.new(
		in_mag,
		get_gun().mag_size,
		mags_held
	)

func change_gun(new_gun_scene: String) -> void:
	var gun_scene: Resource = load(new_gun_scene) # Load the new Gun's scene
	var gun: Gun = gun_scene.instantiate() # Instantiate the new Gun
	var saved_offset: Vector2 = get_gun().position # Remember the offset for the gun so it looks normal
	gun.position = saved_offset
	
	$RotationPoint/Gun.name = "GunR" # Do this otherwise new gun gets called "Gun2" and breaks everything
	$RotationPoint/GunR.queue_free()
	$RotationPoint.add_child(gun)
	gun.name = "Gun"
	
	in_mag = gun.mag_size
	gun_changed()
	refresh_ui()
	
func get_gun() -> Node2D:
	return $RotationPoint/Gun

func inventory_add_item(item: InventoryItem) -> void:
	if not inventory_check_for_item_by_name(item.item_name):
		inventory.append(item)
		emit_signal("inventory_updated", inventory)
		print("Inventory size: ", inventory.size())
	
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

func game_over():
	get_tree().paused = true
	$RotationPoint/PlayerSprite.texture = load("res://sprites/tombstone.png")
	$RotationPoint.rotation_degrees = 270
	$RotationPoint/PlayerSprite.position = Vector2.ZERO
	get_node("/root/Level/GameOver").show()
