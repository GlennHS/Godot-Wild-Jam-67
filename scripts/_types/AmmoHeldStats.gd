extends Node
class_name AmmoHeldStats

var in_mag: int = 0
var mag_size: int = 0
var mags_held: int = 0

func _init(
	_in_mag: int,
	_mag_size: int,
	_mags_held: int
) -> void:
	in_mag = _in_mag
	mag_size = _mag_size
	mags_held = _mags_held

static func fromObj(obj) -> AmmoHeldStats:
	var a = AmmoHeldStats.new(
		obj.in_mag,
		obj.mag_size,
		obj.mags_held,
	)
	return a
