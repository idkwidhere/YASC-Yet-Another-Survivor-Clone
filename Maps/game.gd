extends Node2D


@onready var enemies_node: Node2D = $Enemies
@onready var projectiles_node: Node2D = $Projectiles

var player: Player = null
var chosen_character: Character_Data
var enemy_spawn_path = null
var minutes_elapsed: int = 0

# enemies
var mobs: Array = [
	preload("uid://dw1y7w1nigo6u"),
	preload("uid://hbespbwpg4em"),
	preload("uid://bd2t8oqdhval8")
	
]

var elites: Array = [
	preload("uid://c12kmpm8xieh7")
	
]

var current_elites: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# signals
	SignalBus.connect("minute_passed", minute_passed)
	
	player = get_node("Player")
	player.character = chosen_character
	enemy_spawn_path = player.get_node("EnemySpawn/EnemySpawnPath")
	
	# populate remaining items from available items
	GameLoader.remaining_item_choices = GameLoader.available_item_choices
	
	for i in range(5):
		spawn_mob(get_random_mob())
		
	# handle elites left in queue
	for i in range(elites.size()):
		current_elites.append(elites[i])

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_random_mob():
	return mobs[randi() % mobs.size()]

func spawn_mob(mob_type) -> void:
	var mob_temp = mob_type.instantiate()
	enemy_spawn_path.progress_ratio = randf_range(0, 1)
	mob_temp.position = enemy_spawn_path.global_position
	mob_temp.add_to_group("Enemies")
	get_node("Enemies").add_child(mob_temp)

func get_random_elite():
	return current_elites[randi() % current_elites.size()]
	
func spawn_elite(elite_type):
	current_elites.erase(elite_type)
	var elite_temp = elite_type.instantiate()
	enemy_spawn_path.progress_ratio = randf_range(0, 1)
	elite_temp.position = enemy_spawn_path.global_position
	elite_temp.add_to_group("Enemies")
	get_node("Enemies").add_child(elite_temp)

func eval_time(elapsed_time):
	match elapsed_time:
		1:
			spawn_elite(get_random_elite())

func minute_passed(minute) -> void:
	print(str(minute) + " minutes passed")

func _on_enemy_timer_timeout() -> void:
	for i in range(randi_range(1, 3)):
		spawn_mob(get_random_mob())


func _on_minute_timer_timeout() -> void:
	minutes_elapsed += 1
	eval_time(minutes_elapsed)
