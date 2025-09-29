extends CharacterBody2D
class_name Player


@onready var player_range: CollisionShape2D = $RangeArea/PlayerRange
@onready var health_label: Label = $Health

#preloads
@onready var player_basic_projectile = preload("res://Entities/Projectiles/basic_projectile.tscn")
const LEVEL_UP_SCREEN = preload("uid://rhhk4klikl5o")
const ITEM_CHOICE_SCREEN = preload("uid://xlvnd6c8acru")



@export var character: Character_Data
var speed
var attack_damage
var attack_speed
var max_health
var health
var pierce
var crit_rate
var crit_mult
var pickup_range

# leveling stuff
@export_category("Player Level Detail")
@export var level: int = 1
@export var xp_base: float = 100
@export var xp_growth_rate: float = 1.2
@export var xp: float = 0
@export var xp_needed: float
@export var total_xp: float = 0

@export_category("Player Items")
@export var player_items: Array = []

# enemies in range array i guess
var enemies_in_range: Array = []

func _ready() -> void:
	# connect signals
	SignalBus.connect("upgrade_chosen", upgrade_stats)
	SignalBus.connect("item_chosen", add_new_item)
	character = GameLoader.selected_character
	
	# load character data on game start
	speed = character.speed
	attack_damage = character.attack_damage
	pierce = character.proj_pierce
	crit_rate = character.crit_rate
	crit_mult = character.crit_mult
	pickup_range = character.pickup_range
	%PickupCollider.shape.radius = pickup_range
	
	attack_speed = character.attack_speed
	%AttackTimer.wait_time = 1 / attack_speed 
	
	max_health = character.max_health
	health = max_health
	
	health_label.text = str(health) + "/" + str(max_health)
	
	xp_needed = (xp_base * pow(xp_growth_rate, level - 1))
	
	# item handle on startup
	player_items = character.character_items
	apply_items(player_items)
	
	update_stats()

func _physics_process(_delta: float) -> void:

	var direction = Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	direction = direction.normalized()
	velocity = direction * speed
	move_and_slide()
	

func _process(_delta: float) -> void:
	if !enemies_in_range:
		%AttackTimer.paused = true
	else:
		%AttackTimer.paused = false
		
	#if player_health <= 0:
		#print("game over WIP")


# adding and applying items
func add_new_item(item) -> void:
	pass

func apply_items(items: Array):
	pass


# dealing damage
func player_attack(direction) -> void:
	var bullet_temp = player_basic_projectile.instantiate()
	var dmg_temp = attack_damage
	
	
	var is_crit = randf() < (crit_rate / 100)
	if is_crit:
		dmg_temp *= crit_mult
	
	
	bullet_temp.position = %BulletSpawn.global_position
	bullet_temp.direction = (find_closest_enemy().global_position - global_position).normalized()
	bullet_temp.proj_damage = dmg_temp
	bullet_temp.pierce = pierce
	get_tree().root.add_child(bullet_temp)


func _on_attack_timer_timeout() -> void:
	player_attack(find_closest_enemy().global_position)
	

# taking damage
func take_damage(damage_amount):
	var mat = $PlayerSprite.material
	if mat is ShaderMaterial:
		mat.set_shader_parameter("flash_strength", 1.0)
		var tween = create_tween()
		tween.tween_property(mat, "shader_parameter/flash_strength", 0.0, 0.3)
	
	health -= damage_amount
	health_label.text = str(health) + "/" + str(max_health)

func update_stats():
	%"Level Label".text = "Level: " + str(level)
	%Health.text = str(health) + "/" + str(max_health)
	%"Damage Label".text = "Damage: " + str(attack_damage)
	%"AttackSpeed Label".text = "Attack Speed: " + str(1/attack_speed)
	%"Speed Label".text = "Speed: " + str(speed)
	%CritChanceLabel.text = "Crit %: " + str(crit_rate) + "%"
	%CritMultLabel.text = "Crit Multiplier: " + str(crit_mult)
	

func update_level():
	%LevelProgress.value = xp
	

func level_up():
	level += 1
	var temp_level_choices = LEVEL_UP_SCREEN.instantiate()
	%UI.add_child(temp_level_choices)
	xp_needed = (xp_base * pow(xp_growth_rate, level - 1))
	%LevelProgress.max_value = xp_needed

func upgrade_stats(stat, value):
	var to_upgrade = get(stat)
	var upgrade_value = to_upgrade + value 
	set(stat, upgrade_value)
	if stat == "attack_speed":
		%AttackTimer.wait_time = 1 / attack_speed
	if stat == "pickup_range":
		%PickupCollider.shape.radius = pickup_range
	update_stats()
	
func find_closest_enemy() -> Node2D:
	var closest_enemy: Node2D = null
	var shortest_distance: float = INF
	if enemies_in_range:
		for enemy in enemies_in_range:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < shortest_distance:
				shortest_distance = distance
				closest_enemy = enemy
	return closest_enemy


# Add and remove enemies from player range
func _on_range_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		enemies_in_range.append(area)

func _on_range_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		enemies_in_range.erase(area)

func _on_range_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		enemies_in_range.append(body)

func _on_range_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		enemies_in_range.erase(body)

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area is XPDrop:
		#%CoinEffect.play() add coineffect node and add effect to stream player
		xp += area.value
		total_xp += area.value
		if xp >= xp_needed:
			level_up()
			xp -= xp_needed
		area.picked_up()
		update_level()
	if area is Item_Canister:
		area.picked_up()
		var temp_item_choices = ITEM_CHOICE_SCREEN.instantiate()
		%UI.add_child(temp_item_choices)
