extends Area2D
class_name MobProjectile

@export var proj_ttl = 10
@export var proj_speed: float 
@export var proj_damage: float
var pierce: int
var pierce_count: int = 0
var proj_texture: Texture2D
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ProjectileSprite.texture = proj_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += proj_speed * direction * delta


func _on_ttl_timer_timeout() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(proj_damage)
	queue_free()
