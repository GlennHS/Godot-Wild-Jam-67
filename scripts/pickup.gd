extends Area2D
class_name Pickup

@export var image: Texture
@export var item_name: String
@export var item_description: String
@export var item_type: String

signal picked_up

const CELL_SIZE: int = 16
var move_cycle: int = 0
var moving_up = true
var is_paused = false

var inv_item: InventoryItem

func _ready() -> void:
	$Sprite2D.texture = image
	if($Sprite2D.texture.get_size().x > $Sprite2D.texture.get_size().y):
		apply_scale(Vector2(CELL_SIZE / $Sprite2D.texture.get_size().x, CELL_SIZE / $Sprite2D.texture.get_size().x))
	else:
		apply_scale(Vector2(CELL_SIZE / $Sprite2D.texture.get_size().x, CELL_SIZE / $Sprite2D.texture.get_size().y))
	inv_item = InventoryItem.new(item_name, item_description, image.resource_path, item_type)
	
func _physics_process(delta: float) -> void:
	if is_paused:
		return
		
	is_paused = true
	
	if(move_cycle < 3 && moving_up):
		position.y += 1
		move_cycle += 1
	else:
		moving_up = false
		position.y -= 1
		move_cycle -= 1
		if move_cycle < 0:
			moving_up = true
	
	await get_tree().create_timer(0.3).timeout
	is_paused = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$PickupAudio.play()
		emit_signal("picked_up", inv_item)
		queue_free()
