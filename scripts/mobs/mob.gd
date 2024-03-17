extends Node2D

class_name Mob

@onready var tile_map: TileMap = get_node("/root/Level/%TileMap")
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var move_pause: Timer = $MovePause
@onready var player: Player = get_tree().root.get_node("Level/Player")

@export var health = 30
@export var move_speed = 1
@export var damage_dealt = 10

var target_unreachable = false

func _ready():
	$Healthbar.value = health
	$Healthbar.max_value = health
	visible = check_if_visible()

func _physics_process(_delta):
	await get_tree().physics_frame
	nav_agent.target_position = player.global_position

func get_directions(x: Vector2, y: Vector2) -> Array[Vector2]:
	# Calculate the vector from X to Y
	var v = y - x
	if v.x == 0:
		if v.y > 0:
			return [Vector2.DOWN]
		else:
			return [Vector2.UP]
	if v.y == 0:
		if v.x > 0:
			return [Vector2.RIGHT]
		else:
			return [Vector2.LEFT]
	
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
	if health <= 0:
		return
		
	target_unreachable = !nav_agent.is_target_reachable()
	
	for i in move_speed:
		if global_position.distance_to(player.global_position) <= 16:
			attack()
			return
		# Get next point in navigation
		if not target_unreachable:
			var next_pos: Vector2 = nav_agent.get_next_path_position()
			
			# calculate the cardinal direction
			var dirs_to_move: Array[Vector2] = get_directions(global_position, next_pos)
			# move
			# NOTE: It is fully possible a mob won't move if they're surrounded by other mobs
			if(dirs_to_move.size() == 1):
				move(dirs_to_move[0])
			elif(not move(dirs_to_move[0])):
				move(dirs_to_move[1])
		else:
			move([Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT][randi_range(0, 3)])
		
		visible = check_if_visible() or true
		#if check_if_visible():
			#$RotationPoint/Sprite2D.modulate = Color.RED
		move_pause.start()
		await move_pause.timeout

func check_if_visible() -> bool:
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > player.get_light_radius():
		return false
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	var nodes_to_exclude: Array[RID] = [self]
	for mob: Mob in get_tree().get_nodes_in_group("mobs"):
		nodes_to_exclude.append(mob.get_rid())
	query.exclude = nodes_to_exclude
	var result = space_state.intersect_ray(query)
	if result and not result.collider.get("name") == "Player":
		return false
	else:
		return true

func move(direction: Vector2):
	if(health <= 0):
		return
	
	# Get current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# Get target tile Vector2i
	@warning_ignore("narrowing_conversion")
	var target_tile : Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	# Get custom data from the target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return false
		
	for mob: Mob in get_tree().get_nodes_in_group("mobs"):
		if mob.health > 0:
			var mob_tile = tile_map.local_to_map(mob.global_position)
			if target_tile == mob_tile:
				return false
	
	global_position = tile_map.map_to_local(target_tile)
	return true
	
func hit(hit_data):
	health -= hit_data.damage
	update_healthbar()
	if health <= 0:
		death()
		
func death():
	health = 0
	$RotationPoint/Sprite2D.texture = load("res://sprites/spider_dead.png")
	$CollisionShape2D.disabled = true
	$KilledAudio.play()
		
func attack() -> void:
	player.hit({
		"damage": damage_dealt
	})
	
func update_healthbar():
	$Healthbar.value = health
