extends CanvasLayer

# goal is that there is a 70% chance of getting a tier1 upgrade, 15% chance of getting a tier2 upgrade, 10% chance of getting a tier3 upgrade and 5% chance at tier 4
var stats_dict = {
	1: {"attack_damage": 5, "attack_speed": 0.1, "speed": 5, "max_health": 1, "pierce":1, "crit_rate": 5, "crit_mult": 0.25, "pickup_range": 10},
	2: {"attack_damage": 10, "attack_speed": 0.2, "speed": 10, "max_health": 2, "pierce":2, "crit_rate": 10, "crit_mult": 0.5, "pickup_range": 25},
	3: {"attack_damage": 15, "attack_speed": 0.4, "speed": 15, "max_health": 3, "pierce":3, "crit_rate": 15, "crit_mult": 1, "pickup_range": 35},
	4: {"attack_damage": 20, "attack_speed": 0.8, "speed": 20, "max_health": 5, "pierce":5, "crit_rate": 20, "crit_mult": 2, "pickup_range": 50},
}


const UPGRADE_CHOICE = preload("uid://cj21novd8g2ef")
var choices_array: Array = []
var choice_amount: int = 3
var check_doubles_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	create_buttons(get_choices_from_tier(choice_amount))
	SignalBus.connect("upgrade_chosen", choice_made)

func get_tier() -> int:
	var roll = randf() * 100
	if roll < 70:
		return 1
	elif roll < 85:
		return 2
	elif roll < 95:
		return 3
	else: return 4


func get_choices_from_tier(n) -> Dictionary:
	var new_dict = {}
	check_doubles_array = []
	var i = 0
	#for i in range(n):
		#var tier = get_tier()
		#var tier_upgrades = stats_dict[tier]
		#var keys = tier_upgrades.keys()
		#var chosen_key = keys[randi() % keys.size()]
		#var chosen_value = tier_upgrades[chosen_key]
		#new_dict[chosen_key] = chosen_value
	while (i < n):
		var tier = get_tier()
		var tier_upgrades = stats_dict[tier]
		var keys = tier_upgrades.keys()
		var chosen_key = keys[randi() % keys.size()]
		var chosen_value = tier_upgrades[chosen_key]
		if check_doubles_array.has(chosen_key):
			print("doubled")
		else:
			check_doubles_array.append(chosen_key)
			new_dict[chosen_key] = chosen_value
			i += 1
		
	return new_dict

func create_buttons(choices: Dictionary):
	var choices_as_array = choices.keys()
	#print(choices_as_array)
	for i in range(choices_as_array.size()):
		var temp_choice = UPGRADE_CHOICE.instantiate()
		temp_choice.text = choices_as_array[i] + "\n" + str(choices[choices_as_array[i]])
		temp_choice.stat = choices_as_array[i]
		temp_choice.amount = choices[choices_as_array[i]]
		%ChoiceContainer.add_child(temp_choice)

func choice_made(_n, _i):
	get_tree().paused = false
	queue_free()
