extends Button

var character: Character_Data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CharacterName.text = character.character_name
	$CharacterDescription.text = character.character_description


func _on_button_down() -> void:
	SignalBus.emit_signal("chosen_character", character)
