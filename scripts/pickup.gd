extends Area2D

@export var image: Image
@export var item_name: String
@export var item_description: String
@export var item_type: String

var inv_item: InventoryItem

func _ready() -> void:
	$Sprite2D.texture = image
	inv_item = InventoryItem.new(item_name, item_description, image.resource_path, item_type)
