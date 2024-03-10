extends CharacterBody2D

var speed = 150

const CAN_BOUNCE = true
const CAN_PENETRATE = false
const damage = 10

var gun_stats = {
	"damage_mult": 1
}

func start(_position, direction, _gun_stats):
	rotation_degrees = direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)
	gun_stats = _gun_stats
	
func calculate_damage():
	return damage * gun_stats.damage_multiplier

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit({
				"damage": calculate_damage()
			})
			if(not CAN_PENETRATE):
				queue_free()
		if(CAN_BOUNCE):
			velocity = velocity.bounce(collision.get_normal())
		else:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	# Deletes the bullet when it exits the screen.
	queue_free()

func _on_lifetime_timeout():
	queue_free()
