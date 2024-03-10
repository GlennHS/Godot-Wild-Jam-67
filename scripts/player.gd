extends Node2D

@onready var tile_map = get_node("/root/Game/%TileMap")

@export var health = 100

var is_turn = true

func _ready():
	%Healthbar.value = health

func _physics_process(delta):
	$RotationPoint.look_at(get_global_mouse_position())

func _input(event):
	if not is_turn:
		return
	
	var has_moved = false
	if event.is_action_pressed("move_down"):
		has_moved = move(Vector2.DOWN)
	elif event.is_action_pressed("move_up"):
		has_moved = move(Vector2.UP)
	elif event.is_action_pressed("move_left"):
		has_moved = move(Vector2.LEFT)
	elif event.is_action_pressed("move_right"):
		has_moved = move(Vector2.RIGHT)
	elif event.is_released() && event.is_action_released("shoot"):
		$RotationPoint/Gun.shoot()
		has_moved = true
	else:
		# We don't want to bother continuing or process a turn so exit here
		return
	
	if not has_moved:
		return
	is_turn = false
	$TurnWaitTimer.start()
	await $TurnWaitTimer.timeout
	
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
	if health <= 0:
		game_over()
	
func update_healthbar():
	%Healthbar.value = health
	
func game_over():
	queue_free()
	get_tree().paused = true
	get_node("/root/Game/GameOver").show()
