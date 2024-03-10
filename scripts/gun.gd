extends Node2D

class_name Gun

signal gun_fired

const BULLETS_PER_SHOT = 1
const SPREAD = 15
const DAMAGE_MULTIPLIER = 4

var BULLET_SCENE = preload("res://scenes/bullet.tscn")
var can_shoot = true

func shoot():
	# Check FirePoint not overlapping collider or other nonsense
	if(!can_shoot):
		return
	# Instantiate X bullets with random destinations inside cone of fire
	for i in BULLETS_PER_SHOT:
		print(i)
		# Pick a point inside the fire cone as a target and shoot at it
		var random_rotation = randf_range(-SPREAD, SPREAD)
		fire_bullet(random_rotation)
	
func fire_bullet(bullet_rotation):
	var b: Node2D = BULLET_SCENE.instantiate()
	var resulting_rotation = get_node("/root/Game/Player/RotationPoint").rotation_degrees + bullet_rotation
	b.start($FirePoint.global_position, resulting_rotation, {
		"damage_multiplier": DAMAGE_MULTIPLIER
	})
	get_tree().root.add_child(b)


func _on_fire_point_body_entered(body):
	can_shoot = false


func _on_fire_point_body_exited(body):
	can_shoot = true
