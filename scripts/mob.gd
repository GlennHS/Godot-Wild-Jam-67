extends Node2D

class_name Mob

@onready var tile_map: TileMap = get_node("/root/Game/%TileMap")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var move_pause: Timer = $MovePause
@onready var player: CharacterBody2D = get_tree().root.get_node("Game/Player")

@export var health = 30
@export var move_speed = 1

func _ready():
	$Healthbar.value = health
	$Healthbar.max_value = health

func _physics_process(_delta):
	await get_tree().physics_frame
	nav_agent.target_position = player.global_position
	nav_agent.is_target_reachable()

func get_directions(x: Vector2, y: Vector2) -> Array[Vector2]:
	# Calculate the vector from X to Y
	var v = y - x
	
	if(v.x > 0 and v.y < 0):
		if(abs(v.x) > abs(v.y)):
			return [Vector2.RIGHT, Vector2.UP]
		else:
			return [Vector2.UP, Vector2.RIGHT]
	elif(v.x < 0 and v.y < 0):
		if(abs(v.x) > abs(v.y)):
			return [Vector2.LEFT, Vector2.UP]
		else:
			return [Vector2.UP, Vector2.LEFT]
	elif(v.x > 0 and v.y > 0):
		if(abs(v.x) > abs(v.y)):
			return [Vector2.RIGHT, Vector2.DOWN]
		else:
			return [Vector2.DOWN, Vector2.RIGHT]
	elif(v.x < 0 and v.y > 0):
		if(abs(v.x) > abs(v.y)):
			return [Vector2.LEFT, Vector2.DOWN]
		else:
			return [Vector2.DOWN, Vector2.LEFT]
	else:
		return [Vector2.LEFT, Vector2.UP]
	
func execute_turn():
	for i in move_speed:
		# Get next point in navigation
		var next_pos: Vector2 = nav_agent.get_next_path_position()
		
		# calculate the cardinal direction
		var dirs_to_move: Array[Vector2] = get_directions(global_position, next_pos)
		# move
		if(dirs_to_move.size() == 1):
			move(dirs_to_move[0])
		elif(not move(dirs_to_move[0])):
			move(dirs_to_move[1])
				
		move_pause.start()
		await move_pause.timeout

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
	
	# Should NEVER happen. Check navigation layers in nav agent if so
	if tile_data.get_custom_data("walkable") == false:
		return false
	
	global_position = tile_map.map_to_local(target_tile)
	return true
	
func hit(hit_data):
	health -= hit_data.damage
	update_healthbar()
	if health <= 0:
		queue_free()
	
func update_healthbar():
	$Healthbar.value = health
