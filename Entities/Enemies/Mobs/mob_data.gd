extends Resource
class_name Mob_Data

@export_category("Mob Base Stats")
@export var mob_name: String
@export var mob_sprite: Texture2D
@export var mob_health: float
@export var mob_damage: float
@export var mob_speed: float
@export var is_ranged: bool
@export var mob_projectile_texture: Texture2D
@export var mob_range: float
@export var mob_attack_speed: float
@export var mob_projectile_speed: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
