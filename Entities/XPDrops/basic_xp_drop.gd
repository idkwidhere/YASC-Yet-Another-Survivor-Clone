extends Area2D
class_name XPDrop

var value = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func picked_up():
	queue_free()
