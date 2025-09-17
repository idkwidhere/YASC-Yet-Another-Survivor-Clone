extends Resource
class_name Mob_Data


@export_category("Mob Base Stats")
@export var mob_name: String
@export var mob_health: float
@export var mob_damage: float
@export var mob_speed: float
@export var mob_sprite: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
