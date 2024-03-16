extends Node
class_name InventoryItem

var item_name := "Item"
var item_description := "Description"
var item_image_path := ""
var item_type: String = "Key"

func _init(
	_item_name,
	_item_description,
	_item_image_path,
	_item_type,
) -> void:
	item_name = _item_name
	item_description = _item_description
	item_image_path = _item_image_path
	item_type = _item_type

static func fromObj(obj) -> void:
	return InventoryItem.new(
		obj.item_name,
		obj.item_description,
		obj.item_image_path,
		obj.item_type,
	)
