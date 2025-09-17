extends Label

var start_pos = position
var end_pos = start_pos + Vector2(0, -30)
var amount: float
@onready var tween := create_tween()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str(amount)
	tween.tween_property(self, "global_position", end_pos, .75)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	


func _on_destroy_timeout() -> void:
	queue_free()
