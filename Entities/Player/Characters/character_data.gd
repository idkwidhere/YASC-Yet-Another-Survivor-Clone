extends Resource
class_name Character_Data

@export_category("Character Base Stats")
@export var character_name: String
@export var character_sprite: Texture
@export_multiline var character_description: String
@export var max_health: int
@export var speed: float
@export var attack_speed: float
@export var proj_pierce: int
@export var attack_range: float
@export var attack_damage: float
@export var crit_rate: float
@export var crit_mult: float
@export var pickup_range: float

@export_category("Character Base Items")
@export var character_items: Array[Item_Data]
