extends Node
class_name PlayerStats

var health: int = 0
var armor: int = 0
var dodge: int = 0

func _init(
	_health: int,
	_armor: int,
	_dodge: int
) -> void:
	health = _health
	armor = _armor
	dodge = _dodge

static func fromObj(obj) -> PlayerStats:
	var a = PlayerStats.new(
		obj.health,
		obj.armor,
		obj.dodge,
	)
	return a
