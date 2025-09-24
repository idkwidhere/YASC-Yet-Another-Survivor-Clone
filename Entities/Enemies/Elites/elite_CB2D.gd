extends CharacterBody2D
class_name Elite

@export var elite_data: Elite_Data
const BASIC_XP_DROP = preload("uid://bu3bseyt21tk5")
const DAMAGE_LABEL = preload("uid://b5l6n8d3mgsbb")

var player
var health
var damage
var speed
var is_ranged
var elite_range
var player_in_ranged_range
var elite_projectile_texture
var elite_can_fire = false

const MOB_PROJECTILE = preload("uid://csewfudf1m4xx")
const ELITE_UPGRADE_DROP = preload("uid://coswhma77rkqk")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game/Player")
	
	health = elite_data.elite_health
	damage = elite_data.elite_damage
	speed = elite_data.elite_speed
	is_ranged = elite_data.is_ranged
	elite_range = elite_data.elite_range
	

	
	if is_ranged:
		%RangedAttackTimer.wait_time = elite_data.elite_attack_speed
		%RangedAttackTimer.start()
		elite_projectile_texture = elite_data.elite_projectile_texture
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if health <= 0:
		var temp_xp = BASIC_XP_DROP.instantiate()
		temp_xp.position = global_position
		get_tree().root.get_node("/root/Game/Drops").add_child(temp_xp)
		
		var temp_drop = ELITE_UPGRADE_DROP.instantiate()
		temp_drop.position = global_position
		get_tree().root.get_node("/root/Game/Drops").add_child(temp_drop)
		queue_free()
		

func _physics_process(_delta: float) -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# handle ranged mobs
		if is_ranged:
			if global_position.distance_to(player.global_position) < elite_range:
				elite_can_fire = true
				
			else:
				elite_can_fire = false
				move_and_slide()
		else:
			move_and_slide()

func ranged_attack():
	if elite_can_fire:
		var bullet_temp = MOB_PROJECTILE.instantiate()
		
		# may add crit to mobs?
		#var is_crit = randf() < (crit_rate / 100)
		#if is_crit:
			#dmg_temp *= crit_mult
		
		bullet_temp.proj_texture = elite_projectile_texture
		bullet_temp.proj_speed = elite_data.elite_projectile_speed
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


func _on_ranged_attack_timer_timeout() -> void:
	if elite_can_fire:
		ranged_attack()

func _on_elite_area_area_entered(area: Area2D) -> void:
	if area is PlayerProjectile:
		take_damage(area.proj_damage)

func _on_elite_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
