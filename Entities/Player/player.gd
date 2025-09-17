extends CharacterBody2D
class_name Player


@onready var player_range: CollisionShape2D = $RangeArea/PlayerRange
@onready var health_label: Label = $Health

#preloads
@onready var player_basic_projectile = preload("res://Entities/Projectiles/basic_projectile.tscn")


@export var character: Character
var speed
var attack_damage
var attack_speed
var max_health
var health
var pierce
@export var level: int = 0
var xp: float = 0
var total_xp: float = 0

var enemies_in_range: Array = []


func _ready() -> void:
	# load character data on game start
	speed = character.speed
	attack_damage = character.attack_damage
	pierce = character.proj_pierce
	
	attack_speed = character.attack_speed
	%AttackTimer.wait_time = 1 / attack_speed 
	
	max_health = character.max_health
	health = max_health
	
	health_label.text = str(health) + "/" + str(max_health)
	

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
		
	# handle XP collection and levels
	if xp >= 100:
		SignalBus.level_up.emit()


# dealing damage
func player_attack(direction) -> void:
	var bullet_temp = player_basic_projectile.instantiate()
	bullet_temp.position = %BulletSpawn.global_position
	bullet_temp.direction = (find_closest_enemy().global_position - global_position).normalized()
	bullet_temp.proj_damage = attack_damage
	bullet_temp.pierce = pierce
	get_tree().root.add_child(bullet_temp)


func _on_attack_timer_timeout() -> void:
	player_attack(find_closest_enemy().global_position)
	

# taking damage
func take_damage(damage_amount):
	health -= damage_amount
	health_label.text = str(health) + "/" + str(max_health)


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
		#print("added " + str(area))

func _on_range_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemies"):
		enemies_in_range.erase(area)
		#print("deleted " + str(area))


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area is XPDrop:
		xp += area.value
		total_xp += area.value
		%LevelProgress.value = total_xp / 100
		area.picked_up()
