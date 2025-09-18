extends Button
class_name UpgradeChoice

var stat
var amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_button_down() -> void:
	SignalBus.emit_signal("upgrade_chosen", stat, amount)
