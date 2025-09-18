extends CanvasLayer


var stats = ["attack_damage", "attack_speed", "speed", "max_health", "pierce", "crit_rate", "crit_mult", "pickup_range"]

# goal is that there is a 70% chance of getting a tier1 upgrade, 15% chance of getting a tier2 upgrade, 10% chance of getting a tier3 upgrade and 5% chance at tier 4

var stats_dict = {
	"tier1": {"attack_damage": 5, "attack_speed": 0.1, "speed": 5, "max_health": 1, "pierce":1, "crit_rate": 5, "crit_mult": 0.25, "pickup_range": 10},
	"tier2": {"attack_damage": 10, "attack_speed": 0.2, "speed": 10, "max_health": 2, "pierce":2, "crit_rate": 10, "crit_mult": 0.5, "pickup_range": 25},
	"tier3": {"attack_damage": 15, "attack_speed": 0.4, "speed": 15, "max_health": 3, "pierce":3, "crit_rate": 15, "crit_mult": 1, "pickup_range": 35},
	"tier4": {"attack_damage": 20, "attack_speed": 0.8, "speed": 20, "max_health": 5, "pierce":5, "crit_rate": 20, "crit_mult": 2, "pickup_range": 50},
}

const UPGRADE_CHOICE = preload("uid://cj21novd8g2ef")
var choice_amount: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	create_buttons()
	#SignalBus.connect("upgrade_chosen", choice_made)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func upgrade_choices(n) -> Array:
	var rand_choices = stats.duplicate()
	var current_roll = upgrade_choice_tier()
	var current_tier_choices = stats_dict[current_roll]
	current_tier_choices.shuffle()
	print(stats_dict[upgrade_choice_tier()])
	return rand_choices.slice(0, n)

func upgrade_choice_tier() -> String:
	var roll = randf() * 100
	if roll < 70:
		return "tier1"
	elif roll < 85:
		return "tier2"
	elif roll < 95:
		return "tier3"
	else: return "tier4"

func create_buttons():
	var choices = upgrade_choices(choice_amount)
	for i in range(choices.size()):
		var temp_choice = UPGRADE_CHOICE.instantiate()
		temp_choice.text = choices[i]
		temp_choice.stat = choices[i]
		temp_choice.amount = 50
		%ChoiceContainer.add_child(temp_choice)

func choice_made(n, i):
	get_tree().paused = false
	queue_free()
