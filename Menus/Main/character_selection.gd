extends Control

const CHARACTER_PANEL = preload("uid://cvxm3stls6h84")
const GAME = preload("uid://dyrkc0j48lpvr")


var available_characters: Array[Character_Data] = [
	preload("uid://ctrx2ejg188ib"), 
	preload("uid://dksfu72v5me58")
	]

var chosen_character: Character_Data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SignalBus.connect("chosen_character", set_character)
	
	for character in available_characters:
		var temp_char_panel = CHARACTER_PANEL.instantiate()
		temp_char_panel.character = character
		%CharacterContainer.add_child(temp_char_panel)
		
func set_character(character):
	GameLoader.selected_character = character
	print(character)
	var new_game = GAME.instantiate()
	new_game.chosen_character = character
	get_tree().root.add_child(new_game)
	queue_free()
	
