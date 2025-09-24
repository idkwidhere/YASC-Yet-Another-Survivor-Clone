extends CanvasLayer

# goal is that there is a 70% chance of getting a tier1 upgrade, 15% chance of getting a tier2 upgrade, 10% chance of getting a tier3 upgrade and 5% chance at tier 4
var stats_dict = {}

const ITEM_CHOICE = preload("uid://rx0354jm7oqb")

var choices_array: Array = []
var choice_amount: int = 3
var check_doubles_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	create_buttons(get_choices_from_tier(choice_amount))
	SignalBus.connect("item_chosen", choice_made)

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
		var temp_choice = ITEM_CHOICE.instantiate()
		temp_choice.text = choices_as_array[i] + "\n" + str(choices[choices_as_array[i]])
		temp_choice.stat = choices_as_array[i]
		temp_choice.amount = choices[choices_as_array[i]]
		%ChoiceContainer.add_child(temp_choice)

func choice_made(_item):
	get_tree().paused = false
	queue_free()
