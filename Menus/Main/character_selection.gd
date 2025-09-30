extends Control

const CHARACTER_PANEL = preload("uid://cvxm3stls6h84")
const GAME = preload("uid://dyrkc0j48lpvr")


var available_characters: Array[Character_Data] = [
	preload("uid://ctrx2ejg188ib"), 
	preload("uid://dksfu72v5me58")
	]

var chosen_character: Character_Data


var scroll_speed : int = 300  # pixels per second


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	SignalBus.connect("chosen_character", set_character)
	
	for character in available_characters:
		var temp_char_panel = CHARACTER_PANEL.instantiate()
		temp_char_panel.character = character
		%CharacterContainer.add_child(temp_char_panel)


func set_character(character):
	GameLoader.selected_character = character
	print(character.character_name)


func _on_start_button_pressed() -> void:
	if GameLoader.selected_character:
		var new_game = GAME.instantiate()
		new_game.chosen_character = GameLoader.selected_character
		get_tree().root.add_child(new_game)
		queue_free()


func _on_back_button_pressed() -> void:
	hide()
	get_tree().root.get_node("/root/MainMenu/MainScreen").show()
