extends Node2D
class_name Level

var door_locations: Array[Vector2] = []
var doors: Array[Door] = []
@onready var tile_map = %TileMap

func _ready() -> void:
	set_doors()

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
	door.unlock_door()
	set_doors()
