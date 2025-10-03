extends Node2D

@onready var player: Player = get_parent().get_parent()

var attack_damage_modifier: float = -0.1
var attack_speed_modifier: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.attack_damage_modifier += attack_damage_modifier
	player.attack_speed_modifier += attack_speed_modifier
