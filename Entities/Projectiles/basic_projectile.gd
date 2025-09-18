extends Area2D
class_name BasicProjectile

@export var proj_ttl = 10
@export var proj_speed: float = 300.0
@export var proj_damage: float
var pierce: int
var pierce_count: int = 0

var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += proj_speed * direction * delta



func _on_ttl_timer_timeout() -> void:
	queue_free()



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		if pierce_count >= pierce:
			queue_free()
		else:
			pierce_count += 1
