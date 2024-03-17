extends Node2D

class_name Gun

signal gun_fired
signal ammo_changed

var bullets_per_shot := 1
var shots_per_burst := 1
var spread := 1.0
var damage_multiplier := 1.0
var gun_name := "Gun"
var gun_image_path := ""
var gun_display_name := "Gun"
var mag_size := 1
var bullets_in_mag := mag_size

@onready var stats = get_gun_stats()

var bullet_scene = preload("res://scenes/bullets/bullet.tscn")
var can_shoot = true

func shoot():
	# Check FirePoint not overlapping collider or other nonsense
	if(!can_shoot):
		return
	# Instantiate X bullets with random destinations inside cone of fire
	for s in shots_per_burst:
		$ShootSound.play()
		for i in bullets_per_shot:
			# Pick a point inside the fire cone as a target and shoot at it
			var random_rotation = randf_range(-spread, spread)
			fire_bullet(random_rotation)
		$BurstTimer.start()
		await $BurstTimer.timeout
	reduce_ammo_count()
	
func fire_bullet(bullet_rotation):
	var b: Node2D = bullet_scene.instantiate()
	var resulting_rotation = get_node("../../RotationPoint").rotation_degrees + bullet_rotation
	b.start($FirePoint.global_position, resulting_rotation, {
		"damage_multiplier": damage_multiplier
	})
	get_tree().root.add_child(b)

func reload() -> void:
	$ReloadSound.play()
	bullets_in_mag = mag_size

# Enable this if you want to babysit the player...
func _on_fire_point_body_entered(_body) -> void:
	#can_shoot = false
	pass

func _on_fire_point_body_exited(_body) -> void:
	can_shoot = true

func change_ammo(ammo_scene) -> void:
	bullet_scene = ammo_scene
	emit_signal("ammo_changed")
	
func get_texture() -> Texture2D:
	return $Sprite2D.texture
	
func get_ammo_count() -> int:
	return bullets_in_mag
	
func reduce_ammo_count(qty := 1) -> void:
	bullets_in_mag -= qty
	
func get_gun_stats() -> GunStats:
	return GunStats.new(
		bullets_per_shot,
		shots_per_burst,
		spread,
		damage_multiplier,
		gun_name,
		gun_image_path,
		gun_display_name,
		mag_size,
	)
