extends CanvasLayer


const ITEM_CHOICE = preload("uid://rx0354jm7oqb")

var item_array: Array = GameLoader.remaining_item_choices
var item_amount: int = 3
var check_doubles_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	
	# call create buttons here
	create_buttons(item_array)
	
	SignalBus.connect("item_chosen", choice_made)



func create_buttons(choices: Array):
	for item in choices:
		var temp_item = ITEM_CHOICE.instantiate()
		temp_item.item = item
		%ChoiceContainer.add_child(temp_item)

func choice_made(_item):
	get_tree().paused = false
	queue_free()
