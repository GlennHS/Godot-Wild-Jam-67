extends Node2D

@onready var tile_map = get_node("/root/Game/%TileMap")
@onready var cursor_script = get_node("/root/Game/CursorScript")
@onready var max_health = health
@onready var ui = get_node("/root/Game/UI")

@export var health = 100.0

signal player_damaged
signal ammo_counts_updated
signal gun_updated
signal ammo_updated

var is_turn = true
var can_shoot = true
var in_mag = 6
var mags_held = 2

func _ready():
	%Healthbar.value = health
	ui.connect("ui_entered", disable_firing)
	ui.connect("ui_exited", enable_firing)
	change_gun("res://scenes/guns/burst_rifle.tscn")

func _physics_process(_delta):
	$RotationPoint.look_at(get_global_mouse_position())

func _input(event):
	if not is_turn:
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
	if has_shot:
		cursor_script.set_cursor("wait")
		$TurnWaitTimer.start()
		await $TurnWaitTimer.timeout
		cursor_script.set_cursor("base")
	
	for mob in get_tree().get_nodes_in_group("mobs"):
		if mob.has_method("execute_turn"):
			mob.execute_turn()
	
	is_turn = true

func move(direction: Vector2):
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	# Get custom data from the target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return false
		
	# Move player
	global_position = tile_map.map_to_local(target_tile)
	return true
	
func hit(hit_data):
	health -= hit_data.damage
	update_healthbar()
	emit_signal("player_damaged", health / max_health)
	if health <= 0:
		game_over()

func ui_refresh():
	ammo_counts_changed()
	update_healthbar()

func update_healthbar():
	%Healthbar.value = health
	
func disable_firing():
	can_shoot = false
	
func enable_firing():
	can_shoot = true
	
func ammo_counts_changed():
	emit_signal("ammo_counts_updated", {
		"in_mag": in_mag,
		"mag_size": get_gun().mag_size,
		"mags_held": mags_held,
	})
	
func change_gun(new_gun_scene: String):
	var gun_scene = load(new_gun_scene)
	var gun = gun_scene.instantiate()
	get_gun().name = "Gun_R"
	$RotationPoint/Gun_R.queue_free()
	$RotationPoint.add_child(gun)
	gun.name = "Gun"
	emit_signal("gun_updated", gun.get_gun_stats())
	ui_refresh()
	
func get_gun():
	return $RotationPoint/Gun

func game_over():
	queue_free()
	get_tree().paused = true
	get_node("/root/Game/GameOver").show()
