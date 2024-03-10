extends Node2D

class_name Gun

signal gun_fired

var bullets_per_shot = 1
var shots_per_burst = 1
var spread = 15
var damage_multiplier = 1
var gun_name = "gun"

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")
var can_shoot = true

func shoot():
	# Check FirePoint not overlapping collider or other nonsense
	if(!can_shoot):
		return
	# Instantiate X bullets with random destinations inside cone of fire
	for s in shots_per_burst:
		for i in bullets_per_shot:
			# Pick a point inside the fire cone as a target and shoot at it
			var random_rotation = randf_range(-spread, spread)
			fire_bullet(random_rotation)
		$BurstTimer.start()
		await $BurstTimer.timeout
	
func fire_bullet(bullet_rotation):
	var b: Node2D = bullet_scene.instantiate()
	var resulting_rotation = get_node("/root/Game/Player/RotationPoint").rotation_degrees + bullet_rotation
	b.start($FirePoint.global_position, resulting_rotation, {
		"damage_multiplier": damage_multiplier
	})
	get_tree().root.add_child(b)


func _on_fire_point_body_entered(_body):
	can_shoot = false

func _on_fire_point_body_exited(_body):
	can_shoot = true

func change_ammo(ammo_scene):
	bullet_scene = ammo_scene
