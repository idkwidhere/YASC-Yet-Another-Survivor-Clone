extends Button
class_name ItemChoice


var item: Item_Data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = item.item_name
	tooltip_text = item.item_description

func _on_button_down() -> void:
	SignalBus.emit_signal("item_chosen", item)
