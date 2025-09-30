extends Area2D


@export var orbit_radius: float = 64.0
@export var orbit_speed: float = 1.0
var angle: float = 0.0
var center: Node2D

func _ready() -> void:
	center = get_parent() # the player (or orbit manager)

func _process(delta: float) -> void:
	angle += orbit_speed * delta
	global_position = center.global_position + Vector2(orbit_radius, 0).rotated(angle)


func _on_area_entered(area: Area2D) -> void:
	if area is MobProjectile:
		area.queue_free()
