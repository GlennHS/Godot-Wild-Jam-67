extends Node2D
class_name Level

var door_locations: Array[Vector2] = []
var doors: Array[Door] = []
@onready var tile_map = %TileMap

const OPEN_DOOR_ATLAS_COORDS = Vector2i(7,12)

func _ready() -> void:
	set_doors()
	get_node("/root/AudioManager/MusicPlayer").stream = load("res://audio/music/SCP-x6x.mp3")
	get_node("/root/AudioManager/MusicPlayer").play()

func set_doors() -> void:
	doors = []
	door_locations = []
	for door: Node2D in get_tree().get_nodes_in_group("doors"):
		if door.visible:
			door_locations.append(door.global_position)
			doors.append(door)

func check_door_at_location(location: Vector2) -> bool:
	var i = door_locations.find(location)
	return i != -1

func get_door_at_location(location: Vector2) -> Variant:
	if not check_door_at_location(location):
		return false
	
	var i = door_locations.find(location)
	for door in doors:
		if door.global_position == location:
			return door
	
	printerr("Tried finding a door that didn't exist at ", location)
	return false

func remove_door(door: Door) -> void:
	var door_location: Vector2 = door.global_position
	var door_pos_in_TM: Vector2i = %TileMap.local_to_map(door_location)
	var tilemap_source_id = %TileMap.tile_set.get_source_id(0)
	%TileMap.set_cell(0, door_pos_in_TM, tilemap_source_id, OPEN_DOOR_ATLAS_COORDS)
	door.unlock_door()
	set_doors()
