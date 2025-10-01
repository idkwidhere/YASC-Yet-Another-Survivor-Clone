extends Area2D
class_name Health

var health_amount: int = 1

func picked_up() -> void:
	queue_free()
