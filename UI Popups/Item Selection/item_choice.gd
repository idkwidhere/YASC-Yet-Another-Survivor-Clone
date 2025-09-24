extends Button
class_name ItemChoice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_down() -> void:
	SignalBus.emit_signal("item_chosen")
