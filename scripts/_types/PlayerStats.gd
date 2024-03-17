extends Node
class_name PlayerStats

var health: int = 0
var max_health: int = 0
var armor: int = 0
var dodge: int = 0

func _init(
	_health: int,
	_max_health: int,
	_armor: int,
	_dodge: int
) -> void:
	health = _health
	max_health = _max_health
	armor = _armor
	dodge = _dodge
