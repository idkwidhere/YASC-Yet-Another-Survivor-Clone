extends Node2D


@onready var enemies_node: Node2D = $Enemies
@onready var projectiles_node: Node2D = $Projectiles

var player = null
var enemy_spawn_path = null

const PATCHRAT = preload("uid://dw1y7w1nigo6u")
const WIREHEAD = preload("uid://hbespbwpg4em")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	player = get_node("Player")
	enemy_spawn_path = player.get_node("EnemySpawn/EnemySpawnPath")
	
	
	for i in range(5):
		spawn_mob()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func spawn_mob() -> void:
	var mob_temp = WIREHEAD.instantiate()
	enemy_spawn_path.progress_ratio = randf_range(0, 1)
	mob_temp.position = enemy_spawn_path.global_position
	mob_temp.add_to_group("Enemies")
	get_node("Enemies").add_child(mob_temp)

func level_up() -> void:
	print("leveled up, show screen")


func _on_enemy_timer_timeout() -> void:
	for i in range(randi_range(1, 3)):
		spawn_mob()
