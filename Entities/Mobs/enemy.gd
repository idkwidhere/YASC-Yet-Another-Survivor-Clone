extends Area2D


@export var mob_data: Mob_Data
const BASIC_XP_DROP = preload("uid://bu3bseyt21tk5")
const DAMAGE_LABEL = preload("uid://b5l6n8d3mgsbb")

var player
var health
var damage
var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Game/Player")
	
	health = mob_data.mob_health
	damage = mob_data.mob_damage
	speed = mob_data.mob_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	
	if health <= 0:
		var temp_xp = BASIC_XP_DROP.instantiate()
		temp_xp.position = global_position
		get_tree().root.get_node("/root/Game/XP").add_child(temp_xp)
		queue_free()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	position += delta * speed * direction


func take_damage(damage_amount):
	health -= damage_amount
	damage_popup(damage_amount)
	

func damage_popup(damage_amount):
	var dmglabel = DAMAGE_LABEL.instantiate()
	dmglabel.amount = damage_amount
	#dmglabel.position = %DmgLabel.position
	add_child(dmglabel)


func _on_area_entered(area: Area2D) -> void:
	if area is BasicProjectile:
		take_damage(area.proj_damage)
		


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage(damage)
