extends Control
class_name InventoryItemScene

func _ready() -> void:
	hide_tooltip()

func setup(inventory_item: InventoryItem) -> void:
	$ImageBG/ItemImage.texture = load(inventory_item.item_image_path)
	$Tooltip/Tooltext.text = generate_tooltip_text(inventory_item)
	pass

func generate_tooltip_text(inventory_item: InventoryItem) -> String:
	var title = str("[b]", inventory_item.item_name, "[/b]")
	return str(title, "\n", inventory_item.item_description)

func show_tooltip() -> void:
	$Tooltip.show()
	
func hide_tooltip() -> void:
	$Tooltip.hide()

func _on_mouse_entered() -> void:
	print("Yoooo")
	show_tooltip()

func _on_mouse_exited() -> void:
	print("Noooo")
	hide_tooltip()
