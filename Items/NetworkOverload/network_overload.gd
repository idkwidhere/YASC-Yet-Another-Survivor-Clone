extends Node2D

var damage: float = 10000
const NETWORK_OVERLOAD_ZAP = preload("uid://doucikh885ork")

@onready var player = get_tree().root.get_node("/root/Game/Player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_timer_timeout() -> void:
	var enemies_on_screen = get_tree().get_nodes_in_group("EnemyOnScreen")
	if enemies_on_screen:
		for enemy in enemies_on_screen:
			if enemy != Mob or Elite:
				enemies_on_screen.erase(enemy)
		if enemies_on_screen:
			enemies_on_screen.shuffle()
			var temp_zap = NETWORK_OVERLOAD_ZAP.instantiate()
			temp_zap.position = enemies_on_screen[0].global_position
			get_tree().root.add_child(temp_zap)
			enemies_on_screen[0].take_damage(player.attack_damage * .5)
