extends CharacterBody2D
class_name Mob

@export var mob_data: Mob_Data
const BASIC_XP_DROP = preload("uid://bu3bseyt21tk5")
const DAMAGE_LABEL = preload("uid://b5l6n8d3mgsbb")

var player
var health
var damage
var speed
var is_ranged
var mob_range
var player_in_ranged_range
var mob_projectile_texture
var mob_can_fire = false

const MOB_PROJECTILE = preload("uid://csewfudf1m4xx")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game/Player")
	
	health = mob_data.mob_health
	damage = mob_data.mob_damage
	speed = mob_data.mob_speed
	is_ranged = mob_data.is_ranged
	mob_range = mob_data.mob_range
	
	
	if is_ranged:
		%RangedAttackTimer.wait_time = mob_data.mob_attack_speed
		%RangedAttackTimer.start()
		mob_projectile_texture = mob_data.mob_projectile_texture
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if health <= 0:
		var temp_xp = BASIC_XP_DROP.instantiate()
		temp_xp.position = global_position
		get_tree().root.get_node("/root/Game/XP").add_child(temp_xp)
		queue_free()
		

func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# handle ranged mobs
		if is_ranged:
			if global_position.distance_to(player.global_position) < mob_range:
				mob_can_fire = true
				
			else:
				mob_can_fire = false
				move_and_slide()
		else:
			move_and_slide()

func ranged_attack():
	if mob_can_fire:
		var bullet_temp = MOB_PROJECTILE.instantiate()
		
		# may add crit to mobs?
		#var is_crit = randf() < (crit_rate / 100)
		#if is_crit:
			#dmg_temp *= crit_mult
		
		bullet_temp.proj_texture = mob_projectile_texture
		bullet_temp.proj_speed = mob_data.mob_projectile_speed
		bullet_temp.position = global_position
		bullet_temp.direction = (player.global_position - global_position).normalized()
		bullet_temp.proj_damage = damage
		get_tree().root.add_child(bullet_temp)

func take_damage(damage_amount):
	health -= damage_amount
	damage_popup(damage_amount)

# fuck this thing, fix later
func damage_popup(damage_amount):
	var dmglabel = DAMAGE_LABEL.instantiate()
	dmglabel.amount = damage_amount
	#dmglabel.position = %DmgLabel.position
	dmglabel.global_position = global_position
	get_tree().root.add_child(dmglabel)

func _on_enemy_area_area_entered(area: Area2D) -> void:
	if area is PlayerProjectile:
		take_damage(area.proj_damage)

func _on_enemy_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)


func _on_ranged_attack_timer_timeout() -> void:
	if mob_can_fire:
		ranged_attack()
	
